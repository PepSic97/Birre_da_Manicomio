//
//  HomeViewModel.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var latest: [Product] = []
    @Published var recommended: [Product] = []

    func load() async {
        async let _ = await fetchCategories()
        async let _ = await fetchLatest()
    }

    private func fetchCategories() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            APIService.shared.fetchCategories { [weak self] result in
                if case let .success(list) = result {
                    self?.categories = list
                }
                continuation.resume()
            }
        }
    }

    private func fetchLatest() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            APIService.shared.fetchProducts(perPage: 12) { [weak self] result in
                if case let .success(list) = result {
                    self?.latest = list
                    self?.recommended = Array(list.prefix(8))
                }
                continuation.resume()
            }
        }
    }
}
