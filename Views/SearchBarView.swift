//
//  SearchBarView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/4/23.
//

import SwiftUI

struct SearchBarView: View {
    @State var searchText: String = ""
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            TextField("Search", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black, lineWidth: 2)
                )
                .padding(8)
            HStack(alignment: .top) {
                Spacer()
                Button(action: {
                    print("SearchButtonPressed")
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
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 8)
            .padding(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}
