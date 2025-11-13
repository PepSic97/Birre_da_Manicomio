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

    var body: some View {
        ZStack(alignment: .leading) {

            if showMenu {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showMenu = false } }
            }

            HStack {
                VStack(alignment: .leading, spacing: 22) {
                    ForEach(homeVM.menu, id: \.self) { item in
                        NavigationLink(
                            destination: destinationForItem(item)
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

    @ViewBuilder
    private func destinationForItem(_ item: String) -> some View {
        switch item {
        case "Birre Artigianali":
            BeerTypesListView()
        case "Regali":
            GiftListView()
        default:
            ProductListView(
                title: item,
                products: homeVM.latest
            )
        }
    }
}
