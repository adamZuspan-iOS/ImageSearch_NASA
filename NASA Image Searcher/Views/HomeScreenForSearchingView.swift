//
//  HomeScreenForSearchingView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/5/23.
//

import SwiftUI

struct HomeScreenForSearchingView: View {
    @ObservedObject var searchedDataVM = SearchResultsViewModel()
    @State private var showDataList: Bool = false
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
                        SearchBarView(showListView: $showDataList)
                            .environmentObject(searchedDataVM)
                        if showDataList {
                            SearchedResultsListView()
                                .transition(.scale)
                                .environmentObject(searchedDataVM)
                        }
                    }
                    Text("Search NASA Images Above")
                        .padding(.top, 16)
                        .font(.system(size: 14, weight: .light))
                    Spacer()
                }
                .vAlign(.leading)
                .padding([.leading, .trailing], 8)
            }
            .background(.gray.opacity(0.5))
        }
        
    }
}

struct HomeScreenForSearchingView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenForSearchingView()
    }
}
