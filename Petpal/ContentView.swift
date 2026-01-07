//
//  ContentView.swift
//  Petpal
//
//  Created by gong on 2026/1/7.
//

import SwiftUI

struct ContentView: View {
    @State private var showTestView = false

    var body: some View {
        ZStack {
            MainTabView()

            // Developer signature and test button
            VStack {
                Spacer()

                // Test button
                Button {
                    showTestView = true
                } label: {
                    Text("进入测试页")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                .padding(.bottom, 4)

                Text("Developed by Claude")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray.opacity(0.6))
                    .padding(.bottom, 8)
            }
        }
        .sheet(isPresented: $showTestView) {
            TestView()
        }
    }
}

#Preview {
    ContentView()
}
