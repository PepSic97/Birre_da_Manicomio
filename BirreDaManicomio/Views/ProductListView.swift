//
//  ProductListView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 06/11/25.
//


import SwiftUI

struct ProductListView: View {
    let title: String
    let items: [Product]

    var body: some View {
        VStack {
            if items.isEmpty {
                VStack(spacing: 14) {
                    Image("beer_sad")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                    Text("Prodotto non disponibile")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)

            } else {
                List(items) { product in
                    NavigationLink(
                        destination: ProductDetailView(product: product)
                    ) {
                        HStack(spacing: 16) {
                            AsyncImageView(url: product.firstImageURL)
                                .frame(width: 70, height: 70)
                                .cornerRadius(10)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.decodedName)
                                    .font(.headline)
                                    .lineLimit(2)

                                Text(product.displayPrice)
                                    .font(.subheadline)
                                    .foregroundColor(Color("BrandYellow"))
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(title)
    }
}
