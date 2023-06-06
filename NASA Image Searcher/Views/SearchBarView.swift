//
//  SearchBarView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/4/23.
//

import SwiftUI

struct SearchBarView: View {
    @State var searchText: String = ""
    var searchButtonPressed: () -> ()
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            //MARK: Search Text Entry
            TextField("Search", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.default)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black, lineWidth: 2)
                )
                .padding(8)
            HStack(alignment: .top) {
                Spacer()
                //MARK: Search Button
                Button(action: {
                    print("SearchButtonPressed")
                    Task {
                        await SearchResultsViewModel().getSearchResultsFor(query: searchText)
                        searchButtonPressed()
                    }
                }) {
                    HStack {
                        Text("Search")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                    }
                }
                .backgroundStyle(.black)
                .buttonStyle(.bordered)
                .border(.black, width: 1)
                .cornerRadius(2)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 8)
            .padding(8)
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchButtonPressed: {})
    }
}
