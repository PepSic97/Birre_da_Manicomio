//
//  HomeView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
    @EnvironmentObject var cart: CartViewModel
    @State private var showMenu = false
    @State private var showCart = false
    
    let beerTypes = [
        BeerType(name: "BIONDA", imageName: "beer_bionda"),
        BeerType(name: "BIANCA", imageName: "beer_bianca"),
        BeerType(name: "FRUTTATA", imageName: "beer_fruttata"),
        BeerType(name: "AMBRATA", imageName: "beer_ambrata"),
        BeerType(name: "SCURA", imageName: "beer_scura")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - Che birra cerchi?
                        Text("Che birra cerchi?")
                            .font(.title2.bold())
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(beerTypes) { type in
                                    VStack {
                                        Image(type.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 70)
                                        
                                        Text(type.name)
                                            .font(.callout)
                                    }
                                    .frame(width: 100)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // MARK: - Ultimi arrivi
                        Text("Ultimi arrivi")
                            .font(.title3.bold())
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
                                ForEach(vm.latest) { product in
                                    ProductCard(product: product)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // MARK: - Consigliati
                        Text("Birre consigliate")
                            .font(.title3.bold())
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
                                ForEach(vm.recommended) { product in
                                    ProductCard(product: product)
                                }
                            }
                            .padding(.horizontal)
                        }
                        Spacer(minLength: 80)
                    }
                }
                
                if showMenu {
                    SideMenuView(showMenu: $showMenu)
                }
            }
            .navigationTitle("Birre da Manicomio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        withAnimation { showMenu.toggle() }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button {
                        showCart = true
                    } label: {
                        Image(systemName: "cart")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // future profile
                    } label: {
                        Image(systemName: "person.circle")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showCart) {
                Text("Carrello") // puoi rimettere la tua view
            }
            .task { await vm.load() }
        }
    }
}
