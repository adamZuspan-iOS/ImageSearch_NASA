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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
