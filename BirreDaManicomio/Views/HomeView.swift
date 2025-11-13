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
 
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BrandYellow").ignoresSafeArea()
                if vm.isLoading {
                    VStack {
                        ProgressView()
                        Text("Caricamento prodotti…")
                            .font(.headline)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Che birra cerchi?")
                                .font(.title2.bold())
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(vm.beerTypes) { type in
                                        let items = vm.productsByType[type.id] ?? []
                                        
                                        NavigationLink(
                                            destination: ProductListView(
                                                title: type.name,
                                                products: items
                                            )
                                        ) {
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
                                }
                                .padding(.horizontal)
                            }
                            
                            SectionTitle("Ultimi arrivi")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 18) {
                                    if vm.latest.isEmpty {
                                        PlaceholderCard()
                                    } else {
                                        ForEach(vm.latest) { product in
                                            NavigationLink(destination: ProductDetailView(product: product)) {
                                                ProductCard(product: product)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            SectionTitle("Birre consigliate")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 18) {
                                    if vm.recommended.isEmpty {
                                        PlaceholderCard()
                                    } else {
                                        ForEach(vm.recommended) { product in
                                            NavigationLink(destination: ProductDetailView(product: product)) {
                                                ProductCard(product: product)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            Spacer(minLength: 80)
                        }
                    }
                }
                
                if showMenu {
                    SideMenuView(showMenu: $showMenu)
                        .environmentObject(vm)
                }
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("birreDaManicomioLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button { withAnimation { showMenu.toggle() } } label: {
                        Image(systemName: "line.3.horizontal")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button { showCart = true } label: {
                        Image(systemName: "cart")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {} label: {
                        Image(systemName: "person.circle")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showCart) { Text("Carrello") }
            .task { await vm.loadFromCacheOrAPI() }
        }
    }
}


private struct SectionTitle: View {
    let text: String
    init(_ t: String) { self.text = t }
    
    var body: some View {
        Text(text)
            .font(.title3.bold())
            .padding(.horizontal)
    }
}

struct PlaceholderCard: View {
    var body: some View {
        VStack(spacing: 8) {
            Image("beer_sad")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text("Prodotto non disponibile")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .cornerRadius(14)
    }
}
