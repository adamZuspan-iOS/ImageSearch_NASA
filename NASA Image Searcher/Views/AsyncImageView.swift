//
//  AsyncImageView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/7/23.
//

import SwiftUI

struct AsyncImageView: View {
    var imageURL: String
    var sizeOfImage: CGSize
    var body: some View {
        if let imageURL = URL(string: imageURL) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView("Loading Image")
                        .frame(width: 100, height: 100)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: sizeOfImage.width, maxHeight: sizeOfImage.height)
                        .cornerRadius(2)
                case .failure(_):
                    FailedImageView(errorText: "No image available")
                @unknown default:
                    FailedImageView(errorText: "Error loading image")
                }
            }
        } else {
            FailedImageView(errorText: "No url to retrieve image")
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(imageURL: "https://dummyimage.com/100/fff7ff/000000", sizeOfImage: CGSize(width: 100, height: 100))
    }
}
