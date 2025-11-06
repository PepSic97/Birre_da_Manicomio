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
    @StateObject private var cart = CartViewModel()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showSplash = false }
                            }
                        }
                } else {
                    HomeView()
                        .environmentObject(cart)
                }
            }
        }
    }
}
