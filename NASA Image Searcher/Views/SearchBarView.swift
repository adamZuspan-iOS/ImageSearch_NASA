//
//  SearchBarView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/4/23.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var searchedDataVM: SearchResultsViewModel
    @State var searchText: String = ""
    @Binding var showListView: Bool
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
                .onSubmit {
                    retrieveData()
                }
                .padding(8)
            HStack(alignment: .top) {
                Spacer()
                //MARK: Search Button
                Button(action: {
                    retrieveData()
                }) {
                    HStack {
                        Text("Search")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
                .background(.green)
                .buttonStyle(.bordered)
                .border(.black, width: 1)
                .cornerRadius(2)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 8)
            .padding(8)
        }
    }
    private func retrieveData() {
        showListView = false
        Task {
            await searchedDataVM.getSearchResultsFor(query: searchText)
            withAnimation(Animation.easeOut(duration: 0.5)) {
                showListView = true
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(showListView: Binding.constant(false))
    }
}
