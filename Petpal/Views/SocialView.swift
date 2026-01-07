//
//  SocialView.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import SwiftUI

struct SocialView: View {
    @State private var selectedTab = "推荐"
    @State private var showRadar = false
    private let tabs = ["推荐", "同城", "话题", "相亲角"]
    private let posts = Post.mockData

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Sticky Header
                VStack(spacing: 12) {
                    Spacer(minLength: 48)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(tabs, id: \.self) { tab in
                                TabButton(title: tab, isSelected: selectedTab == tab) {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedTab = tab
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 8)
                .background(Color.white.opacity(0.95))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)

                // Masonry Grid
                ScrollView {
                    MasonryGrid(posts: posts)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 100)
                }
            }

            // Floating Radar Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            showRadar = true
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.orange)

                            Text("寻找遛狗搭子")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.black)
                                .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 6)
                        )
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 96)
                }
            }

            // Radar Overlay
            if showRadar {
                RadarView(isShowing: $showRadar)
                    .transition(.opacity)
            }
        }
        .background(Color.white)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.orange : Color.clear)
                        .shadow(color: isSelected ? Color.orange.opacity(0.3) : Color.clear, radius: 8)
                )
        }
    }
}

struct MasonryGrid: View {
    let posts: [Post]
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(posts) { post in
                PostCard(post: post)
            }
        }
    }
}

struct PostCard: View {
    let post: Post

    var body: some View {
        VStack(spacing: 0) {
            // Image
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(CGFloat.random(in: 0.7...1.3), contentMode: .fit)

                // Gradient Overlay
                LinearGradient(
                    colors: [Color.clear, Color.black.opacity(0.6)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .cornerRadius(16)

                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    HStack {
                        HStack(spacing: 2) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 10))
                            Text(post.distance)
                                .font(.system(size: 10))
                        }

                        Spacer()

                        HStack(spacing: 2) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 10))
                            Text("\(post.likes)")
                                .font(.system(size: 10))
                        }
                    }
                    .foregroundColor(.white.opacity(0.9))
                }
                .padding(12)
            }
        }
        .cornerRadius(16)
    }
}

struct RadarView: View {
    @Binding var isShowing: Bool
    @State private var animateRadar = false

    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.95)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }

            VStack(spacing: 32) {
                // Close Button
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            isShowing = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.5))
                            .padding(12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 48)

                Spacer()

                // Radar Animation
                ZStack {
                    // Radar circles
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                            .frame(width: 240 - CGFloat(index * 60), height: 240 - CGFloat(index * 60))
                            .scaleEffect(animateRadar ? 1.2 : 1.0)
                            .opacity(animateRadar ? 0.0 : 1.0)
                            .animation(
                                .easeOut(duration: 2.0)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.5),
                                value: animateRadar
                            )
                    }

                    // Center dot
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 16, height: 16)
                        .shadow(color: Color.orange, radius: 10)

                    // Found pets (mock)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "dog.fill")
                                .foregroundColor(.orange)
                        )
                        .offset(x: -60, y: -80)
                        .scaleEffect(animateRadar ? 1.0 : 0.0)
                        .animation(.spring(response: 0.5).delay(1.5), value: animateRadar)

                    Circle()
                        .fill(Color.white)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "cat.fill")
                                .foregroundColor(.orange)
                        )
                        .offset(x: 70, y: 60)
                        .scaleEffect(animateRadar ? 1.0 : 0.0)
                        .animation(.spring(response: 0.5).delay(2.5), value: animateRadar)
                }
                .frame(width: 240, height: 240)

                VStack(spacing: 8) {
                    Text("正在扫描附近毛孩子...")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)

                    Text("已发现 2 位潜在玩伴")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }

                Spacer()
            }
        }
        .onAppear {
            animateRadar = true
        }
    }
}

#Preview {
    SocialView()
}
