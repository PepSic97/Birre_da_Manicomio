//
//  SideMenuView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var showMenu: Bool
    @EnvironmentObject var homeVM: HomeViewModel
    let width: CGFloat = 260

    let menu: [String] = [
        "Birre Artigianali",
        "Kit Degustazione",
        "Discovery Box",
        "Abbonamenti",
        "Bicchieri",
        "Regali"
    ]

    var body: some View {
        ZStack(alignment: .leading) {
            if showMenu {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showMenu = false } }
            }

            HStack {
                VStack(alignment: .leading, spacing: 22) {
                    ForEach(menu, id: \.self) { item in
                        let products = itemsForMenu(item)

                        NavigationLink(
                            destination: ProductListView(
                                title: item,
                                items: products
                            )
                        ) {
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

    private func itemsForMenu(_ item: String) -> [Product] {
        switch item {
        case "Birre Artigianali":
            return homeVM.latest
        case "Regali":
            return homeVM.recommended
        default:
            return []
        }
    }
}
