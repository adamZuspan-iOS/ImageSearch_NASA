//
//  FailedImageView.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/7/23.
//

import SwiftUI

struct FailedImageView: View {
    var errorText: String
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            Image(systemName: "photo.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            Text(errorText)
                .font(.system(size: 12, weight: .light))
        }
    }
}

struct FailedImageView_Previews: PreviewProvider {
    static var previews: some View {
        FailedImageView(errorText: "errorText")
    }
}
