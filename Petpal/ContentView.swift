//
//  ContentView.swift
//  Petpal
//
//  Created by gong on 2026/1/7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            MainTabView()

            // Developer signature
            VStack {
                Spacer()
                Text("Developed by Claude")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray.opacity(0.6))
                    .padding(.bottom, 8)
            }
        }
    }
}

#Preview {
    ContentView()
}
