//
//  ContentView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeScreenForSearchingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HomeScreenForSearchingView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("NASA Image Search")
                    .fontDesign(.monospaced)
                    .fontWeight(.bold)
                    
                SearchBarView()
            }
            .vAlign(.leading)
            .padding([.leading, .trailing], 8)
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
