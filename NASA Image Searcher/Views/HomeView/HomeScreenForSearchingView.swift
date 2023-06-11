//
//  HomeScreenForSearchingView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/5/23.
//

import SwiftUI

struct HomeScreenForSearchingView: View {
    @StateObject var searchedDataVM = SearchResultsViewModel()
    @State private var showDataList: Bool = false
    @State private var searchText: String = ""
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center) {
                    Text("NASA Image Search")
                        .font(.system(size: 28, design: .monospaced))
                        .fontWeight(.bold)
                        .padding(.top, 8)
                    Spacer()
                    Group {
                        SearchBarView(searchText: $searchText, showListView: $showDataList)
                            .environmentObject(searchedDataVM)
                        if showDataList {
                            SearchedResultsListView(searchText: searchText)
                                .padding(.top, 12)
                                .transition(.scale)
                                .environmentObject(searchedDataVM)
                        }
                    }
                    Text("Search NASA Images Above")
                        .padding(.top, showDataList ? 8 : 16)
                        .font(.system(size: 12, weight: .light))
                    Spacer()
                }
                .vAlign(.leading)
                .padding([.leading, .trailing], 8)
            }
            .background(.gray.opacity(0.5))
            .alert(isPresented: $searchedDataVM.showError) {
                Alert(
                    title: Text("Error"),
                    message: Text(searchedDataVM.errorMessage),
                    primaryButton: .default(Text("Retry")) {
                        retryGetSearchResults()
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
        }
        
    }
    
    private func retryGetSearchResults() {
        Task {
            await searchedDataVM.getSearchResultsFor(query: searchText)
        }
    }
}

struct HomeScreenForSearchingView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenForSearchingView()
    }
}
