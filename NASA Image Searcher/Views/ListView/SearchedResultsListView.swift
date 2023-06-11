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
    var searchText: String
    var body: some View {
        if searchedDataVM.isLoadingFirstPage {
            ProgressView("Loading searched content")
        } else {
            if let displayedData = searchedDataVM.collectionOfData {
                NavigationView {
                    VStack {
                        listOfSearchedResultsView(displayedData: displayedData)
                        if searchedDataVM.isLoadingNextPage {
                            ProgressView("Loading more search results")
                        }
                    }
                }
            } else {
                Text("Retry search to show results")
                    .fontWeight(.light)
            }
        }
    }
    
    @ViewBuilder
    func listOfSearchedResultsView(displayedData: Collection) -> some View {
        List(displayedData.items) { item in
            ForEach(item.data) { data in
                let dataForDetailsView = searchedDataVM.retrieveDataForDetailView(data: data, links: item.links)
                NavigationLink(destination: DetailPageView(dataForDisplay: dataForDetailsView)) {
                    TitleImageView(data: data, links: item.links)
                        .onAppear {
                            if data.id == searchedDataVM.collectionOfData?.items.last?.data.last?.id {
                                loadNextPage()
                            }
                        }
                        .environmentObject(searchedDataVM)
                }
                .listRowSeparator(.hidden)
                ThickDividerView()
            }
        }
        .listStyle(.inset)
    }
    
    private func loadNextPage() {
        Task {
            await searchedDataVM.loadNextPage(query: searchText)
        }
    }
}
