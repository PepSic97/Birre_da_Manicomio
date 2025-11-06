//
//  CategoryProductsView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 06/11/25.
//


import SwiftUI

struct CategoryProductsView: View {
    let categoryName: String

    var body: some View {
        Text(categoryName)
            .navigationTitle(categoryName)
    }
}
