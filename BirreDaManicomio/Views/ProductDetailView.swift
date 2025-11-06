//
//  ProductDetailView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 06/11/25.
//


import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var cart: CartViewModel
    let product: Product

    @State private var addedToCart = false
    @State private var animate = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: - Product Image
                AsyncImageView(url: product.firstImageURL)
                    .frame(height: 300)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    .scaleEffect(animate ? 1 : 0.95)
                    .animation(.spring(), value: animate)

                // MARK: - Title + Price
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.decodedName)
                        .font(.title2.bold())

                    Text(product.displayPrice)
                        .font(.title3)
                        .foregroundColor(Color("BrandYellow"))
                }
                .padding(.horizontal)

                Divider()

                // MARK: - Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Descrizione")
                        .font(.headline)

                    Text(product.description ?? "Nessuna descrizione disponibile")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                Spacer(minLength: 40)

                // MARK: - Add to Cart Button
                Button(action: {
                    cart.add(product)
                    withAnimation(.easeInOut(duration: 0.35)) {
                        addedToCart = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        withAnimation { addedToCart = false }
                    }
                }) {
                    HStack {
                        Image(systemName: addedToCart ? "checkmark" : "cart.badge.plus")
                        Text(addedToCart ? "Aggiunto!" : "Aggiungi al carrello")
                            .bold()
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("BrandYellow"))
                    .cornerRadius(14)
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .padding(.top)
        }
        .navigationTitle(product.decodedName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            animate = true
        }
    }
}
