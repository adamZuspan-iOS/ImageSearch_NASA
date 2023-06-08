//
//  ThickDividerView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/7/23.
//

import SwiftUI

struct ThickDividerView: View {
    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .frame(maxWidth: geo.size.width, maxHeight: 2)
                .foregroundColor(Color.black)
        }
    }
}

struct ThickDividerView_Previews: PreviewProvider {
    static var previews: some View {
        ThickDividerView()
            .padding(.top, 100)
    }
}
