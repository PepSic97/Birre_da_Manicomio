//
//  Product.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import Foundation

struct ProductImage: Codable {
    let src: String?
}

struct Product: Identifiable, Codable {
    let id: Int
    let name: String
    let description: String?
    let short_description: String?
    let images: [ProductImage]?
    let price_html: String?
    let beerType: Int? // Cambiato da String a Int

    var decodedName: String {
        name
    }

    var displayPrice: String {
        price_html ?? "N/D"
    }

    var firstImageURL: URL? {
        guard let src = images?.first?.src else { return nil }
        return URL(string: src)
    }
}
