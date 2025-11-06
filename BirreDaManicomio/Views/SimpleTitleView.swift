//
//  SimpleTitleView.swift
//  BirreDaManicomio
//
//  Created by Giuseppe Sica on 06/11/25.
//


import SwiftUI

struct SimpleTitleView: View {
    let title: String

    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.largeTitle.bold())
            Spacer()
        }
        .navigationTitle(title)
    }
}
