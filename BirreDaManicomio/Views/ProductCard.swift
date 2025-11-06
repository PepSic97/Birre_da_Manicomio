//
//  ProductCard.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 06/11/25.
//


import SwiftUI

struct ProductCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImageView(url: product.firstImageURL)
                .frame(width: 140, height: 140)
                .cornerRadius(10)

            Text(product.decodedName)
                .font(.headline)
                .lineLimit(2)

            Text(product.displayPrice)
                .font(.subheadline)
                .foregroundColor(Color("BrandYellow"))
        }
        .frame(width: 160)
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.1), radius: 3)
    }
}
