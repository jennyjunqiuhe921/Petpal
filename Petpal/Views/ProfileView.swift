//
//  ProfileView.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Background
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .fill(Color.orange)
                        .frame(height: 180)
                        .ignoresSafeArea(edges: .top)

                    Button {} label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 48)
                            .padding(.trailing, 24)
                    }
                }

                // Profile Card
                VStack(spacing: 0) {
                    // Avatar
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.orange.opacity(0.3), Color.purple.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 96, height: 96)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        )
                        .overlay(
                            Button {} label: {
                                Image(systemName: "pencil")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(6)
                                    .background(Circle().fill(Color(UIColor.systemGray6)))
                            }
                            .offset(x: 32, y: 32)
                        )
                        .offset(y: -48)

                    Text("爱宠铲屎官")
                        .font(.system(size: 20, weight: .bold))
                        .offset(y: -40)

                    Text("ID: 9527 • 北京朝阳")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .offset(y: -36)

                    // Stats
                    HStack(spacing: 0) {
                        StatItem(value: "2", label: "毛孩子")
                        Divider().frame(height: 40)
                        StatItem(value: "128", label: "获赞")
                        Divider().frame(height: 40)
                        StatItem(value: "56", label: "关注")
                        Divider().frame(height: 40)
                        StatItem(value: "12", label: "粉丝")
                    }
                    .padding(.top, -20)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
                .padding(.top, 96)
                .background(Color.white)
                .cornerRadius(32)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                .padding(.horizontal, 24)
                .offset(y: -96)

                // Menu Groups
                VStack(spacing: 16) {
                    // First Menu Group
                    VStack(spacing: 0) {
                        MenuItem(icon: "bag.fill", label: "我的订单", badge: "2", badgeColor: .red)
                        Divider().padding(.leading, 64)
                        MenuItem(icon: "creditcard.fill", label: "我的钱包", value: "¥1,250")
                        Divider().padding(.leading, 64)
                        MenuItem(icon: "heart.fill", label: "收藏的服务")
                    }
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)

                    // Second Menu Group
                    VStack(spacing: 0) {
                        MenuItem(icon: "shield.fill", label: "宠物保险", badge: "未激活", badgeColor: .gray)
                        Divider().padding(.leading, 64)
                        MenuItem(icon: "questionmark.circle.fill", label: "帮助与客服")
                    }
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                }
                .padding(.horizontal, 24)
                .offset(y: -80)
                .padding(.bottom, 100)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
    }
}

struct StatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold))

            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MenuItem: View {
    let icon: String
    let label: String
    var value: String? = nil
    var badge: String? = nil
    var badgeColor: Color = .red

    var body: some View {
        Button {} label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .frame(width: 32)

                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)

                Spacer()

                if let value = value {
                    Text(value)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                }

                if let badge = badge {
                    Text(badge)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(badgeColor))
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(16)
        }
    }
}

#Preview {
    ProfileView()
}
