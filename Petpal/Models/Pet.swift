//
//  Pet.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import Foundation

struct Pet: Identifiable, Codable {
    let id: UUID
    var name: String
    var breed: String
    var imageURL: String
    var days: Int // 陪伴天数
    var weightData: [WeightEntry]
    var diet: [String] // 饮食标签
    var tasks: [PetTask]

    init(
        id: UUID = UUID(),
        name: String,
        breed: String,
        imageURL: String,
        days: Int,
        weightData: [WeightEntry] = [],
        diet: [String] = [],
        tasks: [PetTask] = []
    ) {
        self.id = id
        self.name = name
        self.breed = breed
        self.imageURL = imageURL
        self.days = days
        self.weightData = weightData
        self.diet = diet
        self.tasks = tasks
    }
}

struct WeightEntry: Identifiable, Codable {
    let id: UUID
    var month: String
    var weight: Double

    init(id: UUID = UUID(), month: String, weight: Double) {
        self.id = id
        self.month = month
        self.weight = weight
    }
}

struct PetTask: Identifiable, Codable {
    let id: UUID
    var title: String
    var time: String
    var done: Bool

    init(id: UUID = UUID(), title: String, time: String, done: Bool = false) {
        self.id = id
        self.title = title
        self.time = time
        self.done = done
    }
}

// Mock Data
extension Pet {
    static let mockData: [Pet] = [
        Pet(
            name: "Momo",
            breed: "金毛寻回犬",
            imageURL: "dog1",
            days: 365,
            weightData: [
                WeightEntry(month: "1月", weight: 28),
                WeightEntry(month: "2月", weight: 29),
                WeightEntry(month: "3月", weight: 29.5),
                WeightEntry(month: "4月", weight: 30),
                WeightEntry(month: "5月", weight: 30.2),
                WeightEntry(month: "6月", weight: 30.5)
            ],
            diet: ["对鸡肉过敏", "爱吃冻干", "每天两顿"],
            tasks: [
                PetTask(title: "今日需喂食心脏处方粮", time: "08:00", done: false),
                PetTask(title: "距离下次驱虫还有 3 天", time: "待办", done: false)
            ]
        ),
        Pet(
            name: "Oreo",
            breed: "英短蓝白",
            imageURL: "cat1",
            days: 128,
            weightData: [
                WeightEntry(month: "1月", weight: 3.5),
                WeightEntry(month: "2月", weight: 3.8),
                WeightEntry(month: "3月", weight: 4.0),
                WeightEntry(month: "4月", weight: 4.2),
                WeightEntry(month: "5月", weight: 4.3),
                WeightEntry(month: "6月", weight: 4.5)
            ],
            diet: ["玻璃胃", "只吃鱼肉", "需化毛膏"],
            tasks: [
                PetTask(title: "喂化毛膏", time: "20:00", done: false)
            ]
        )
    ]
}
