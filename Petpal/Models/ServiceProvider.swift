//
//  ServiceProvider.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import Foundation
import SwiftUI

struct ServiceProvider: Identifiable, Codable {
    let id: UUID
    var name: String
    var badge: String
    var experience: String
    var description: String
    var distance: String
    var price: Int
    var avatarColor: String

    init(
        id: UUID = UUID(),
        name: String,
        badge: String,
        experience: String,
        description: String,
        distance: String,
        price: Int,
        avatarColor: String
    ) {
        self.id = id
        self.name = name
        self.badge = badge
        self.experience = experience
        self.description = description
        self.distance = distance
        self.price = price
        self.avatarColor = avatarColor
    }
}

// Mock Data
extension ServiceProvider {
    static let mockData: [ServiceProvider] = [
        ServiceProvider(
            name: "李阿姨",
            badge: "实名认证",
            experience: "5年经验",
            description: "擅长照顾大型犬，自带零食",
            distance: "300m",
            price: 30,
            avatarColor: "orange"
        ),
        ServiceProvider(
            name: "王同学",
            badge: "金牌遛狗员",
            experience: "200+单",
            description: "专业训犬师资质，主要接周末",
            distance: "800m",
            price: 45,
            avatarColor: "blue"
        ),
        ServiceProvider(
            name: "萌宠之家",
            badge: "连锁店",
            experience: "评分4.9",
            description: "全天候监控，超大活动草坪",
            distance: "1.5km",
            price: 120,
            avatarColor: "green"
        )
    ]
}
