//
//  BirreDaManicomioApp.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import SwiftUI
import CoreData

@main
struct BirreDaManicomioApp: App {

    @StateObject var cart = CartViewModel()
    @StateObject var homeVM = HomeViewModel()

    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {

                // ✅ Passiamo homeVM alla gerarchia
                HomeView()
                    .environmentObject(cart)
                    .environmentObject(homeVM)
                    .opacity(showSplash ? 0 : 1)

                if showSplash {
                    SplashView(homeVM: homeVM)
                        .transition(.opacity)
                        .onChange(of: homeVM.isLoading) { loading in
                            if loading == false {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    withAnimation { showSplash = false }
                                }
                            }
                        }
                }
            }
        }
    }
}
