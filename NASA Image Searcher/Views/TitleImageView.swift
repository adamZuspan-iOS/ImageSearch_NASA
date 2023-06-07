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
                .padding([.leading, .trailing], 8)
            Spacer()
            ForEach(links) { link in
                Group {
                    if let imageURL = URL(string: link.imageURL) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView("Loading Image")
                                    .frame(width: 100, height: 100)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                            case .failure(_):
                                failedImageView(text: "No image available")
                            @unknown default:
                                failedImageView(text: "Error loading image")
                            }
                        }
                    } else {
                        failedImageView(text: "No url to retrieve image")
                    }
                }
                .padding()
            }
        }
    }
    
    @ViewBuilder
    func failedImageView(text: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Image(systemName: "photo.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            Text(text)
                .font(.system(size: 12, weight: .light))
        }
    }
}
