//
//  SearchResultsViewModel.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/5/23.
//

import SwiftUI

enum LoadingType {
    case firstPage, nextPage
}

final class SearchResultsViewModel: ObservableObject {
    private var networkService: NetworkService
    private(set) var currentPage: Int = 1
    private(set) var maxNumberOfPages: Int = 1
    
    @Published var collectionOfData: Collection?
    @Published var showError: Bool = false

    @Published private(set) var isLoadingFirstPage: Bool = false
    @Published private(set) var isLoadingNextPage: Bool = false
    @Published private(set) var errorMessage: String = ""

    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func getSearchResultsFor(query: String, currentPage: Int = 1, loadingType: LoadingType = .firstPage) async {
        await setLoadingState(isLoading: true, loadingType: loadingType)
        do {
            let queryItems = [URLQueryItem(name: "q", value: query),
                              URLQueryItem(name: "page", value: String(currentPage)),
                              URLQueryItem(name: "media_type", value: "image")]
            let apiResponse: SearchedDataListModel = try await networkService.makeAPIRequest(path: "search", queryItems: queryItems)
            DispatchQueue.main.async {
                if self.collectionOfData != nil {
                    //nextPage
                    self.collectionOfData?.items.append(contentsOf: apiResponse.collection.items)
                    self.isLoadingNextPage = false
                } else {
                    //firstPage
                    self.collectionOfData = apiResponse.collection
                    self.maxNumberOfPages = apiResponse.collection.metaData.totalItems.maxPageCount()
                    self.isLoadingFirstPage = false
                }
            }
        } catch {
            await setErrorState(hasError: true, error: error)
            await setLoadingState(isLoading: false, loadingType: .firstPage)
        }
    }
    
    func loadNextPage(query: String) async {
        guard currentPage <= maxNumberOfPages else { return }
        currentPage += 1
        let nextPage = currentPage
        await getSearchResultsFor(query: query, currentPage: nextPage, loadingType: .nextPage)
    }
    
    func imageURLFor(links: [Links]) -> [URL?] {
        var imageURLs = [URL?]()
        for link in links {
            imageURLs.append(URL(string: link.imageURL))
        }
        return imageURLs
    }
    
    func retrieveDataForDetailView(data: RelevantData, links: [Links]) -> DataForDetailView {
        let title = data.title
        let description = data.description ?? data.description_508 ?? "No Description Available"
        let dateCreated = data.dateCreatedFormatted ?? data.dateCreated_ISO8601
        return DataForDetailView(links: links, title: title, description: description, dateCreated: dateCreated)
    }
    
    @MainActor
    private func setLoadingState(isLoading: Bool, loadingType: LoadingType) {
        switch loadingType {
        case .firstPage:
            isLoadingFirstPage = isLoading
        case .nextPage:
            isLoadingNextPage = isLoading
        }
    }
    
    @MainActor
    private func setErrorState(hasError: Bool, error: Error) {
        showError = hasError
        errorMessage = error.localizedDescription
    }
}
