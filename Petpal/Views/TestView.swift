//
//  TestView.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import SwiftUI

struct TestView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // 淡蓝色背景
            Color(red: 0.7, green: 0.85, blue: 1.0)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // 大标题
                Text("这里是分支宇宙的测试页")
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 40)

                // 返回按钮
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("返回主页")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(25)
                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
        }
    }
}

#Preview {
    TestView()
}
