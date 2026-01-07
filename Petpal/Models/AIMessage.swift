//
//  AIMessage.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import Foundation

struct AIMessage: Identifiable, Codable {
    let id: UUID
    var role: MessageRole
    var content: String

    enum MessageRole: String, Codable {
        case user
        case ai
    }

    init(id: UUID = UUID(), role: MessageRole, content: String) {
        self.id = id
        self.role = role
        self.content = content
    }
}
