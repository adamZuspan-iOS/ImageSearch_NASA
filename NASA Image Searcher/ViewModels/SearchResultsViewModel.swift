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
    
    //TODO: Move this functionality into a string extension file
    ///Should update due to being dependant on a @Published but if not handle optional value in the view for @Published
    //    var dateCreatedString: String {
    //        guard let dateCreatedDate = dateCreated else {
    //            return ""
    //        }
    //        return dateCreatedDate
    //    }
    
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
}
