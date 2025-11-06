//
//  CartViewModel.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CartViewModel: ObservableObject {
    @Published var items: [Product] = []

    var total: String {
        let nums = items.compactMap { Double($0.displayPrice.replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: ".")) }
        let sum = nums.reduce(0, +)
        return String(format: "%.2f €", sum)
    }

    func add(_ product: Product) { items.append(product) }
    func remove(_ product: Product) { items.removeAll { $0.id == product.id } }
}
