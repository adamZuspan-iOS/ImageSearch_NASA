//
//  HomeScreenForSearchingView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/5/23.
//

import SwiftUI

struct HomeScreenForSearchingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center) {
                    Text("NASA Image Search")
                        .fontDesign(.monospaced)
                        .fontWeight(.bold)
                        .font(Font.system(size: 28))
                        .padding(.top, 8)
                    Spacer()
                    SearchBarView() {

                    }
                    Text("Search NASA Images Above")
                        .padding(.top, 16)
                        .font(Font.system(size: 14))
                        .fontWeight(.light)
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
