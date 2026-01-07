//
//  Post.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import Foundation

struct Post: Identifiable, Codable {
    let id: UUID
    var imageURL: String
    var distance: String
    var likes: Int
    var title: String

    init(
        id: UUID = UUID(),
        imageURL: String,
        distance: String,
        likes: Int,
        title: String
    ) {
        self.id = id
        self.imageURL = imageURL
        self.distance = distance
        self.likes = likes
        self.title = title
    }
}

// Mock Data
extension Post {
    static let mockData: [Post] = [
        Post(imageURL: "social1", distance: "0.5km", likes: 128, title: "公园撒欢去！"),
        Post(imageURL: "social2", distance: "1.2km", likes: 856, title: "午后阳光好舒服~"),
        Post(imageURL: "social3", distance: "300m", likes: 42, title: "什么？没零食了？"),
        Post(imageURL: "social4", distance: "2.5km", likes: 230, title: "新买的领结"),
        Post(imageURL: "social5", distance: "800m", likes: 1205, title: "暗中观察"),
        Post(imageURL: "social6", distance: "5.0km", likes: 89, title: "歪头杀"),
        Post(imageURL: "social7", distance: "1.0km", likes: 445, title: "最爱这个球")
    ]
}
