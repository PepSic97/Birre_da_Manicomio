//
//  BeerTypesListView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 07/11/25.
//


import SwiftUI

struct BeerTypesListView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        List(homeVM.beerTypes) { type in
            let products = homeVM.productsByType[type.id] ?? []
            NavigationLink(
                destination: ProductListView(
                    title: type.name,
                    products: products
                )
            ) {
               beerImage(type: type)
            }
        }
        .navigationTitle("Birre Artigianali")
    }
}

extension BeerTypesListView {
    @ViewBuilder
    private func beerImage(type: BeerType) -> some View {
        HStack {
            Image(type.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            Text(type.name)
                .font(.headline)
        }
    }
}
