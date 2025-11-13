//
//  AsyncImageView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//


import SwiftUI

struct AsyncImageView: View {
    let url: URL?

    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.1))

            if let url = url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let img):
                        successImg(img: img)
                    case .empty:
                        ProgressView()
                    default:
                        defaultImg()
                    }
                }
            }
        }
        .clipped()
    }
}

extension AsyncImageView {
    @ViewBuilder
    private func successImg(img: Image) -> some View {
        img
            .resizable()
            .scaledToFill()
    }
    
    @ViewBuilder
    private func defaultImg() -> some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .padding(20)
    }
}
