//
//  AIAssistantView.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import SwiftUI

struct AIAssistantView: View {
    @Environment(\.dismiss) private var dismiss
    private let apiClient = QwenAPIClient.shared
    @State private var messages: [AIMessage] = [
        AIMessage(role: .ai, content: "你好！我是你的AI宠物健康助手。拍个照或者告诉我你的毛孩子怎么了？🐶🐱")
    ]
    @State private var inputText = ""
    @State private var isTyping = false
    @State private var showError = false
    @State private var errorMessage = ""

    private let suggestions = [
        "我家狗呕吐黄水怎么办？",
        "这也是细小病毒吗？",
        "猫咪一直蹭屁股是怎么了？",
        "推荐适合金毛的狗粮"
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "brain.head.profile")
                            .foregroundColor(.orange)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("AI 宠物助手")
                        .font(.system(size: 18, weight: .bold))

                    Text("24小时在线 • 智能诊断")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.orange)
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color(UIColor.systemGray6)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)

            // Disclaimer
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.orange)

                Text("AI建议仅供参考，急症请及时就医")
                    .font(.system(size: 12))
                    .foregroundColor(.orange)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.orange.opacity(0.1))

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }

                        if isTyping {
                            TypingIndicator()
                        }
                    }
                    .padding(20)
                }
                .background(Color(UIColor.systemGroupedBackground))
                .onChange(of: messages.count) { _ in
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Input Area
            VStack(spacing: 12) {
                // Suggestions
                if messages.count < 3 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(suggestions, id: \.self) { suggestion in
                                Button {
                                    inputText = suggestion
                                } label: {
                                    Text(suggestion)
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // Input Bar
                HStack(spacing: 12) {
                    Button {} label: {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }

                    Button {} label: {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }

                    HStack {
                        TextField("描述症状或上传照片...", text: $inputText)
                            .font(.system(size: 14))

                        if !inputText.isEmpty {
                            Button {
                                inputText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(24)

                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(inputText.isEmpty ? Color.gray : Color.orange)
                            )
                    }
                    .disabled(inputText.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color.white)
        }
        .alert("错误", isPresented: $showError) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    private func sendMessage() {
        guard !inputText.isEmpty else { return }

        let userMessage = AIMessage(role: .user, content: inputText)
        messages.append(userMessage)

        inputText = ""
        isTyping = true

        Task {
            do {
                let response = try await apiClient.sendMessage(messages: messages)

                await MainActor.run {
                    isTyping = false
                    let aiResponse = AIMessage(role: .ai, content: response)
                    messages.append(aiResponse)
                }
            } catch {
                await MainActor.run {
                    isTyping = false
                    errorMessage = "发送失败：\(error.localizedDescription)"
                    showError = true

                    // Add error message to chat
                    let errorMsg = AIMessage(
                        role: .ai,
                        content: "抱歉，我遇到了一些问题。请稍后再试。\n错误信息：\(error.localizedDescription)"
                    )
                    messages.append(errorMsg)
                }
            }
        }
    }
}

struct MessageBubble: View {
    let message: AIMessage

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.role == .user {
                Spacer()
            }

            if message.role == .ai {
                Circle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "sparkles")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                    )
            }

            Text(message.content)
                .font(.system(size: 14))
                .foregroundColor(message.role == .user ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(message.role == .user ? Color.orange : Color.white)
                )
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: message.role == .user ? .trailing : .leading)

            if message.role == .ai {
                Spacer()
            }

            if message.role == .user {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    )
            }
        }
    }
}

struct TypingIndicator: View {
    @State private var animating = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.orange.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundColor(.orange)
                )

            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 8, height: 8)
                        .scaleEffect(animating ? 1.0 : 0.5)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: animating
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white)
            )

            Spacer()
        }
        .onAppear {
            animating = true
        }
    }
}

#Preview {
    AIAssistantView()
}
