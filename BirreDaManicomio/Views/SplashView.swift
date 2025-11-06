//
//  SplashView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import SwiftUI

struct SplashView: View {
    @ObservedObject var homeVM: HomeViewModel

    @State private var progress: CGFloat = 0.0
    @State private var currentMessage = ""
    @State private var messageIndex = 0

    @State private var timer: Timer?
    @State private var progressTimer: Timer?

    let messages = [
        "Stappiamo la creatività…",
        "Versiamo un’idea alla volta…",
        "Fermentazione in corso…",
        "Prepariamo una birra ghiacciata…",
        "Un attimo, stiamo spillando…"
    ]

    var body: some View {
        ZStack {
            Color("BrandYellow").ignoresSafeArea()

            VStack(spacing: 24) {
                Image("birreDaManicomioLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160)

                Text(currentMessage)
                    .font(.headline)
                    .foregroundColor(Color("BrandBlack"))
                    .animation(.easeInOut, value: currentMessage)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandWhite").opacity(0.3))
                        .frame(width: 220, height: 20)

                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BrandWhite"))
                        .frame(width: 220 * progress, height: 20)
                        .animation(.easeInOut(duration: 0.4), value: progress)
                }
            }
        }
        .onAppear {
            startMessagesLoop()
            startProgressSimulation()
            Task { await loadDataSafely() }
        }
        .onDisappear {
            timer?.invalidate()
            progressTimer?.invalidate()
        }
    }

    // MARK: - Funzioni

    private func startMessagesLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
            // Aggiorniamo lo stato in modo sicuro usando il main thread
            DispatchQueue.main.async {
                messageIndex = (messageIndex + 1) % messages.count
                currentMessage = messages[messageIndex]
            }
        }
    }

    private func startProgressSimulation() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { t in
            DispatchQueue.main.async {
                if progress < 0.9 { progress += 0.03 }
                if !homeVM.isLoading { t.invalidate() }
            }
        }
    }

    private func loadDataSafely() async {
        // Caricamento dati senza modificare direttamente lo stato durante il render
        await homeVM.loadFromCacheOrAPI()
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.6)) {
                progress = 1.0
            }
        }
    }
}
