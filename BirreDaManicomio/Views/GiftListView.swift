//
//  GiftListView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 07/11/25.
//


import SwiftUI

struct GiftListView: View {
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {

        let gifts = homeVM.recommended.isEmpty
        ? homeVM.recommendedMock
        : homeVM.recommended
        
        return ProductListView(
            title: "Regali",
            products: gifts
        )
    }
}
