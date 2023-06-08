//
//  TitleImageView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/6/23.
//

import SwiftUI

struct TitleImageView: View {
    @State var imageIsLoading: Bool = true
    var data: RelevantData
    var links: [Links]
    
    var body: some View {
        HStack(alignment: .center) {
            Text(data.title)
            Spacer()
            ForEach(links) { link in
                AsyncImageView(imageURL: link.imageURL,
                               sizeOfImage: CGSize(width: 125, height: 125))
            }
        }
    }
}
