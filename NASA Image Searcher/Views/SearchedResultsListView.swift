//
//  SearchedResultsListView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/6/23.
//

import SwiftUI

struct SearchedResultsListView: View {
    @EnvironmentObject var searchedDataVM: SearchResultsViewModel
    @State private var imageIsLoading = true
    var body: some View {
        if searchedDataVM.isLoadingNetworkResponse {
            ProgressView("Loading searched content")
        } else {
            if let displayedData = searchedDataVM.collectionOfData {
                List(displayedData.items) { item in
                    ForEach(item.data) { data in
                        TitleImageView(data: data, links: item.links)
                    }
                }
            } else {
                //TODO: Show an alert with user friendly error message and option for retrying the network call
                Text("collectionOfData is nil.")
                    .fontWeight(.light)
            }
        }
    }
}
