//
//  MainTabView.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showAIAssistant = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            TabView(selection: $selectedTab) {
                HealthView()
                    .tag(0)

                SocialView()
                    .tag(1)

                Color.clear
                    .tag(2)

                ServiceView()
                    .tag(3)

                ProfileView()
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab, showAIAssistant: $showAIAssistant)
        }
        .sheet(isPresented: $showAIAssistant) {
            AIAssistantView()
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var showAIAssistant: Bool

    var body: some View {
        ZStack(alignment: .top) {
            // Tab Bar Background
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.white)
                .frame(height: 80)
                .shadow(color: Color.black.opacity(0.05), radius: 20, x: 0, y: -4)

            HStack(spacing: 0) {
                TabBarButton(icon: "house.fill", label: "管家", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }

                TabBarButton(icon: "person.2.fill", label: "社区", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }

                Spacer()
                    .frame(width: 60)

                TabBarButton(icon: "map.fill", label: "服务", isSelected: selectedTab == 3) {
                    selectedTab = 3
                }

                TabBarButton(icon: "person.fill", label: "我的", isSelected: selectedTab == 4) {
                    selectedTab = 4
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)

            // AI Button
            VStack(spacing: 4) {
                Button {
                    showAIAssistant = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.orange, Color.yellow],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)
                            .shadow(color: Color.orange.opacity(0.4), radius: 8, x: 0, y: 4)

                        Image(systemName: "sparkles")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .offset(y: -32)

                Text("AI助手")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.orange)
                    .offset(y: -28)
            }
        }
        .frame(height: 80)
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(isSelected ? .orange : .gray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)

                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? .orange : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
}
