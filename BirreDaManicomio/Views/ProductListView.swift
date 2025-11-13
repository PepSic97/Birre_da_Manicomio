//
//  ProductListView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 06/11/25.
//


import SwiftUI

struct ProductListView: View {
    let title: String
    let products: [Product]

    var body: some View {
        List {
            if products.isEmpty {
                Text("Nessun prodotto disponibile")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(products) { product in
                    NavigationLink(
                        destination: ProductDetailView(product: product)
                    ) {
                        Text(product.name)
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}
