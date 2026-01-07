//
//  QwenAPIClient.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import Foundation

// MARK: - API Models
struct QwenChatRequest: Codable {
    let model: String
    let messages: [QwenMessage]
}

struct QwenMessage: Codable {
    let role: String
    let content: String
}

struct QwenChatResponse: Codable {
    let choices: [QwenChoice]
    let usage: QwenUsage?
    let id: String
    let model: String

    struct QwenChoice: Codable {
        let message: QwenMessage
        let finishReason: String?
        let index: Int

        enum CodingKeys: String, CodingKey {
            case message
            case finishReason = "finish_reason"
            case index
        }
    }

    struct QwenUsage: Codable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int

        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
}

// MARK: - API Client
class QwenAPIClient {
    static let shared = QwenAPIClient()

    private init() {}

    func sendMessage(messages: [AIMessage]) async throws -> String {
        guard let url = URL(string: APIConfig.dashscopeEndpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIConfig.dashscopeAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Convert AIMessage to QwenMessage
        let qwenMessages = messages.map { message in
            QwenMessage(
                role: message.role == .user ? "user" : "assistant",
                content: message.content
            )
        }

        // Add system message if not present
        var finalMessages = qwenMessages
        if finalMessages.first?.role != "system" {
            finalMessages.insert(
                QwenMessage(
                    role: "system",
                    content: "你是一个专业的宠物健康助手，擅长回答关于宠物健康、饮食、行为等问题。请用简洁、专业但易懂的语言回答用户的问题。"
                ),
                at: 0
            )
        }

        let requestBody = QwenChatRequest(
            model: APIConfig.modelName,
            messages: finalMessages
        )

        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("API Error: \(errorMessage)")
            throw APIError.httpError(statusCode: httpResponse.statusCode, message: errorMessage)
        }

        let chatResponse = try JSONDecoder().decode(QwenChatResponse.self, from: data)

        guard let firstChoice = chatResponse.choices.first else {
            throw APIError.noResponse
        }

        return firstChoice.message.content
    }

    // MARK: - Todo List Splitting
    func splitTodoList(task: String) async throws -> [String] {
        let systemPrompt = """
        你是一个任务管理助手。用户会给你一个大任务，请帮助用户将这个任务拆分成具体的、可执行的子任务。

        要求：
        1. 每个子任务都应该是具体、可执行的行动项
        2. 按照逻辑顺序排列
        3. 每行一个子任务，不要序号
        4. 简洁明了，每个子任务不超过20个字
        5. 只输出子任务列表，不要其他解释
        """

        let messages = [
            QwenMessage(role: "system", content: systemPrompt),
            QwenMessage(role: "user", content: "请帮我拆分这个任务：\(task)")
        ]

        let requestBody = QwenChatRequest(
            model: APIConfig.modelName,
            messages: messages
        )

        guard let url = URL(string: APIConfig.dashscopeEndpoint) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIConfig.dashscopeAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        let chatResponse = try JSONDecoder().decode(QwenChatResponse.self, from: data)

        guard let content = chatResponse.choices.first?.message.content else {
            throw APIError.noResponse
        }

        // Parse the response into todo items
        let todos = content
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { line -> String in
                // Remove common prefixes like "1.", "-", "•", etc.
                var cleaned = line
                if let range = cleaned.range(of: "^[0-9]+[.、]\\s*", options: .regularExpression) {
                    cleaned.removeSubrange(range)
                }
                if cleaned.hasPrefix("- ") || cleaned.hasPrefix("• ") {
                    cleaned = String(cleaned.dropFirst(2))
                }
                return cleaned.trimmingCharacters(in: .whitespaces)
            }
            .filter { !$0.isEmpty }

        return todos
    }
}

// MARK: - Errors
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, message: String)
    case noResponse
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的 URL"
        case .invalidResponse:
            return "无效的响应"
        case .httpError(let statusCode, let message):
            return "HTTP 错误 \(statusCode): \(message)"
        case .noResponse:
            return "没有收到响应"
        case .decodingError:
            return "解析响应失败"
        }
    }
}
