//
//  DetailPageView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/7/23.
//

import SwiftUI

struct DetailPageView: View {
    var dataForDisplay: DataForDetailView
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                ForEach(dataForDisplay.links) { link in
                    AsyncImageView(imageURL: link.imageURL,
                                   sizeOfImage: CGSize(width: CGFloat.infinity, height: CGFloat.infinity))
                }
                Group {
                    Text(dataForDisplay.title)
                        .font(.system(size: 28, design: .rounded))
                        .fontWeight(.bold)
                    Text(dataForDisplay.description)
                        .font(.system(size: 18, design: .default))
                        .fontWeight(.semibold)
                        .padding()
                        .border(.gray, width: 2)
                    Text(dataForDisplay.dateCreated)
                        .font(.system(size: 14, design: .default))
                        .fontWeight(.regular)
                }
                .textSelection(.enabled)
                .padding([.top, .bottom], 8)
                .padding([.leading, .trailing], 8)
            }
        }
        .navigationTitle("Details")
    }
}
