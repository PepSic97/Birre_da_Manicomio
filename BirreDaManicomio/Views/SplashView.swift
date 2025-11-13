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

    @State private var messageTimer: Timer?
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
            currentMessage = messages.first ?? ""
            startMessageCycle()
            startProgressAnimation()
            mockLoading()
        }
        .onDisappear {
            messageTimer?.invalidate()
            progressTimer?.invalidate()
        }
    }

    // MARK: - Ciclo messaggi
    private func startMessageCycle() {
        messageTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { timer in
            DispatchQueue.main.async {
                messageIndex += 1

                if messageIndex >= messages.count {
                    timer.invalidate()
                    finishSplash()
                    return
                }

                currentMessage = messages[messageIndex]
            }
        }
    }

    private func startProgressAnimation() {
        let totalSteps = messages.count
        let increment = 1.0 / CGFloat(totalSteps)

        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { timer in
            DispatchQueue.main.async {
                progress += increment

                if progress >= 1.0 {
                    timer.invalidate()
                }
            }
        }
    }

    private func mockLoading() {
        Task {
            try? await Task.sleep(nanoseconds: UInt64(messages.count) * 700_000_000)
            await MainActor.run { homeVM.isLoading = false }
        }
    }

    private func finishSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                homeVM.isLoading = false
            }
        }
    }
}
