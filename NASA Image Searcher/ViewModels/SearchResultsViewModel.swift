//
//  SearchResultsViewModel.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/5/23.
//

import SwiftUI
import Foundation

class SearchResultsViewModel: ObservableObject {
    //MARK: Network Service Var
    private var networkService: NetworkService
    
    //MARK: Published Vars
    @Published var collectionOfData: Collection?
    @Published var isLoadingNetworkResponse: Bool = false
        
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func getSearchResultsFor(query: String) async {
        await setLoadingState(isLoading: true)
        do {
            let queryItems = [URLQueryItem(name: "q", value: query)]
            let apiResponse = try await networkService.makeAPIRequest(path: "search", queryItems: queryItems)
            DispatchQueue.main.async {
                self.collectionOfData = apiResponse.collection
                self.isLoadingNetworkResponse = false
            }
        } catch {
            //TODO: Handle the error passback
            // Handle the error
            print(error)
            await setLoadingState(isLoading: false)
        }
    }
    
    @MainActor
    private func setLoadingState(isLoading: Bool) {
        isLoadingNetworkResponse = isLoading
    }
    
    func imageURLFor(links: [Links]) -> [URL?] {
        var imageURLs = [URL?]()
        for link in links {
            imageURLs.append(URL(string: link.imageURL))
        }
        return imageURLs
    }
    
    func retrieveDataForDetailView(data: RelevantData, links: [Links]) -> DetailViewData {
        let title = data.title
        let description = data.description ?? data.description_508 ?? "No Description Available"
        let dateCreated = data.dateCreatedFormatted ?? data.dateCreated_ISO8601 
        return DetailViewData(links: links, title: title, description: description, dateCreated: dateCreated)
    }
}
