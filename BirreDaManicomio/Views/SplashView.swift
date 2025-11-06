//
//  SplashView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 05/11/25.
//

import SwiftUI

struct SplashView: View {
    @State private var progress: CGFloat = 0.0
    @State private var currentMessage = ""
    @State private var messageIndex = 0

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
            startFakeLoading()
        }
    }

    private func startFakeLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { timer in
            progress += 0.12

            messageIndex = (messageIndex + 1) % messages.count
            currentMessage = messages[messageIndex]

            if progress >= 1.0 {
                timer.invalidate()
            }
        }
    }
}
