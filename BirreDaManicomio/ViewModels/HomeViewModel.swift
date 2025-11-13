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
    var productsByType: [Int: [Product]] = [:]

    @Published var giftCategories: [Category] = []

    let giftCategoriesMock: [Category] = [
        Category(id: 9001, name: "Box Regalo", slug: "box-regalo"),
        Category(id: 9002, name: "Kit Degustazione", slug: "kit-degustazione")
    ]

    let latestMock: [Product] = [
        Product(id: 1, name: "ALHAMBRA 1925", description: nil, short_description: nil,
                images: [ProductImage(src: "https://www.birredamanicomio.com/wp-content/uploads/ALHAMBRA-1925-OK-324x324.png")],
                price_html: "5,50 €", beerType: 0),
        Product(id: 2, name: "ALHAMBRA RESERVA", description: nil, short_description: nil,
                images: [ProductImage(src: "https://www.birredamanicomio.com/wp-content/uploads/ALHAMBRA-RESERVA-OK-324x324.jpg")],
                price_html: "6,50 €", beerType: 0),
        Product(id: 3, name: "ANTIKORPO BLACK", description: nil, short_description: nil,
                images: [ProductImage(src: "https://www.birredamanicomio.com/wp-content/uploads/antikorpo-black-324x324.jpg")],
                price_html: "7,00 €", beerType: 4)
    ]

    let recommendedMock: [Product] = []
    
    let beerTypes = [
        BeerType(id: 0, name: "BIONDA",   imageName: "beer_bionda"),
        BeerType(id: 1, name: "BLANCHE", imageName: "beer_bianca"),
        BeerType(id: 2, name: "FRUTTATA", imageName: "beer_fruttata"),
        BeerType(id: 3, name: "AMBRATA",  imageName: "beer_ambrata"),
        BeerType(id: 4, name: "SCURA",    imageName: "beer_scura")
    ]
    
    let menu: [String] = [
        "Birre Artigianali",
        "Regali",
        "Discovery Box",
        "Abbonamenti",
        "Bicchieri"
    ]

    func loadFromCacheOrAPI() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 400_000_000)

        latest = latestMock
        recommended = recommendedMock

        productsByType = Dictionary(grouping: latest, by: { $0.beerType ?? -1 })

        await loadGiftCategories()

        isLoading = false
    }

    func loadGiftCategories() async {
        APIService.shared.fetchCategories { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let categories):
                let filtered = categories.filter {
                    $0.name.localizedCaseInsensitiveContains("regal")
                }

                self.giftCategories = filtered.isEmpty ? self.giftCategoriesMock : filtered

            case .failure:
                self.giftCategories = self.giftCategoriesMock
            }
        }
    }
}
