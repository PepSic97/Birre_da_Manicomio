//
//  HomeViewModel.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import Foundation
import SwiftUI
import Combine
import SwiftSoup

@MainActor
class HomeViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var latest: [Product] = []
    @Published var recommended: [Product] = []

    // ✅ Archivio per tipo, già pronto per la Home
    @Published var productsByType: [Int: [Product]] = [:]

    // ✅ MOCK aggiornato
    let latestMock: [Product] = [
        Product(id: 1,
                name: "ALHAMBRA 1925",
                description: nil,
                short_description: nil,
                images: [ProductImage(src: "https://www.birredamanicomio.com/wp-content/uploads/ALHAMBRA-1925-OK-324x324.png")],
                price_html: "5,50 €",
                beerType: 0),
        
        Product(id: 2,
                name: "ALHAMBRA RESERVA",
                description: nil,
                short_description: nil,
                images: [ProductImage(src: "https://www.birredamanicomio.com/wp-content/uploads/ALHAMBRA-RESERVA-OK-324x324.jpg")],
                price_html: "6,50 €",
                beerType: 0),
        
        Product(id: 3,
                name: "ANTIKORPO BLACK",
                description: nil,
                short_description: nil,
                images: [ProductImage(src: "https://www.birredamanicomio.com/wp-content/uploads/antikorpo-black-324x324.jpg")],
                price_html: "7,00 €",
                beerType: 4)
    ]

    let recommendedMock: [Product] = []


    // MARK: - LOAD
    func loadFromCacheOrAPI() async {
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        latest = latestMock
        recommended = recommendedMock
        
        buildProductsByType()

        isLoading = false
    }

    // MARK: - BUILD TYPE MAP
    private func buildProductsByType() {
        var dict: [Int: [Product]] = [:]

        for product in latest {
            guard let type = product.beerType else { continue }
            dict[type, default: []].append(product)
        }

        productsByType = dict
    }
}
