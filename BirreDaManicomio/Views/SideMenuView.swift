//
//  SideMenuView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var showMenu: Bool
    let width: CGFloat = 260

    let menuItems: [String] = [
        "Birre Artigianali",
        "Birre Barrel",
        "Birre Biologiche",
        "Birre Bionde Leggere",
        "Birre da Manicomio",
        "Birre Lambic e fruttate",
        "Birre non filtrate",
        "Birre Scure Strong"
    ]

    var body: some View {
        ZStack(alignment: .leading) {

            // Background trasparente
            if showMenu {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showMenu = false } }
            }

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 22) {
                    ForEach(menuItems, id: \.self) { item in
                        NavigationLink(destination: CategoryProductsView(categoryName: item)) {
                            Text(item)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                }
                .padding(.top, 40)
                .padding(.horizontal)
                .frame(width: width)
                .background(Color.white)
                .offset(x: showMenu ? 0 : -width)

                Spacer()
            }
            .animation(.easeOut(duration: 0.25), value: showMenu)
        }
    }
}
