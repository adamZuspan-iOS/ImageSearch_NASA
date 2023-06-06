//
//  SearchResultsViewModel.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/5/23.
//

import SwiftUI

class SearchResultsViewModel: ObservableObject {
    //MARK: Network Service Var
    private var networkService: NetworkService
    
    //MARK: Published Vars
    @Published var title: String?
    @Published var imageURL: URL?
    @Published var description: String?
    @Published var dateCreated: String?
    
    //MARK: Computed Vars
    ///Should update due to being dependant on a @Published but if not handle optional value in the view for @Published
    var dateCreatedString: String {
        guard let dateCreatedDate = dateCreated else {
            return ""
        }
        return dateCreatedDate
    }
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func getSearchResultsFor(query: String) async {
        do {
            let queryItems = [URLQueryItem(name: "q", value: query)]
            let apiResponse = try await networkService.makeAPIRequest(path: "search", queryItems: queryItems)
            // Handle the API response
            if let item = apiResponse.collection.items.first {
                title = item.data.first?.title
                imageURL = URL(string: item.links.first?.imageURL ?? "")
                description = item.data.description
                dateCreated = item.data.first?.dateCreatedFormatted ?? item.data.first?.dateCreated_ISO8601
            }
        } catch {
            // Handle the error
            print(error)
        }
    }
}
