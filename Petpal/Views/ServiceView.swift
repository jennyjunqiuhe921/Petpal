//
//  ServiceView.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct ServiceView: View {
    @State private var selectedService = "上门喂养"
    private let services = ["上门喂养", "遛狗服务", "家庭寄养", "洗护预约"]
    private let providers = ServiceProvider.mockData

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    // Map Section
                    MapPlaceholder()
                        .frame(height: geometry.size.height * 0.45)

                // Bottom Sheet
                VStack(spacing: 0) {
                    // Handle
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 48, height: 6)
                        .padding(.top, 12)
                        .padding(.bottom, 24)

                    // Service Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(services, id: \.self) { service in
                                ServiceCategoryButton(
                                    title: service,
                                    icon: iconForService(service),
                                    isSelected: selectedService == service
                                ) {
                                    withAnimation {
                                        selectedService = service
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.bottom, 24)

                    // Provider List Header
                    HStack {
                        Text("附近服务")
                            .font(.system(size: 18, weight: .bold))

                        Spacer()

                        Button("查看更多") {}
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)

                    // Provider List
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(providers) { provider in
                                ProviderCard(provider: provider)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 120)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(.background)
                        .ignoresSafeArea()
                )
            }

            // Live Status Banner
            LiveServiceBanner()
                .padding(.horizontal, 24)
                .padding(.bottom, 96)
            }
            .background(.background)
        }
    }

    private func iconForService(_ service: String) -> String {
        switch service {
        case "上门喂养": return "house.fill"
        case "遛狗服务": return "figure.walk"
        case "家庭寄养": return "mappin.circle.fill"
        case "洗护预约": return "shower.fill"
        default: return "star.fill"
        }
    }
}

struct MapPlaceholder: View {
    var body: some View {
        ZStack {
            // Background color
            Color.gray.opacity(0.2)

            // Map-like gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.green.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Markers
            VStack {
                HStack {
                    Spacer()
                    MapMarker(icon: "house.fill", color: .orange)
                        .offset(x: -40, y: 40)
                    Spacer()
                    Spacer()
                }

                HStack {
                    Spacer()
                    Spacer()
                    MapMarker(icon: "figure.walk", color: .green)
                        .offset(x: 20, y: -20)
                    Spacer()
                }

                Spacer()

                // User Location
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 16, height: 16)
                    )
            }
            .padding()
        }
    }
}

struct MapMarker: View {
    let icon: String
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 40, height: 40)
                .shadow(color: Color.black.opacity(0.2), radius: 8)

            Circle()
                .stroke(color, lineWidth: 2)
                .frame(width: 40, height: 40)

            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
        }
    }
}

struct ServiceCategoryButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .orange : .gray)
                    .frame(width: 40, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? Color.orange.opacity(0.1) : Color.gray.opacity(0.1))
                    )

                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(isSelected ? .orange : .gray)
            }
            .frame(width: 80)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.orange.opacity(0.05) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.orange.opacity(0.2) : Color.clear, lineWidth: 1)
                    )
            )
        }
    }
}

struct ProviderCard: View {
    let provider: ServiceProvider

    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(avatarBackgroundColor)
                .frame(width: 56, height: 56)
                .overlay(
                    Text(String(provider.name.prefix(1)))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(avatarForegroundColor)
                )

            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(provider.name)
                        .font(.system(size: 16, weight: .bold))

                    Text(provider.badge)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                }

                Text(provider.description)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                HStack(spacing: 12) {
                    Label(provider.experience, systemImage: "clock")
                    Label(provider.distance, systemImage: "location")
                }
                .font(.system(size: 11))
                .foregroundColor(.secondary)
            }

            Spacer()

            // Price & Button
            VStack(spacing: 8) {
                HStack(alignment: .top, spacing: 2) {
                    Text("¥\(provider.price)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.orange)
                    Text("/次")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }

                Button {
                    // Book action
                } label: {
                    Text("预约")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black)
                        .cornerRadius(12)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    private var avatarBackgroundColor: Color {
        switch provider.avatarColor {
        case "orange": return Color.orange.opacity(0.1)
        case "blue": return Color.blue.opacity(0.1)
        case "green": return Color.green.opacity(0.1)
        default: return Color.gray.opacity(0.1)
        }
    }

    private var avatarForegroundColor: Color {
        switch provider.avatarColor {
        case "orange": return Color.orange
        case "blue": return Color.blue
        case "green": return Color.green
        default: return Color.gray
        }
    }
}

struct LiveServiceBanner: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.green)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "figure.walk")
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("遛狗服务进行中")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)

                Text("遛狗员正在带大黄散步，点击查看")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.9))
                .shadow(color: Color.black.opacity(0.3), radius: 16, x: 0, y: 8)
        )
    }
}

#Preview {
    ServiceView()
}
