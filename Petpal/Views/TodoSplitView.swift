//
//  TodoSplitView.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import SwiftUI

struct TodoSplitView: View {
    @Environment(\.dismiss) private var dismiss
    private let apiClient = QwenAPIClient.shared
    @State private var taskInput = ""
    @State private var generatedTodos: [String] = []
    @State private var isGenerating = false
    @State private var showError = false
    @State private var errorMessage = ""

    var onTodosGenerated: ([String]) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "sparkles.rectangle.stack.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(.top, 20)

                    Text("AI 任务拆分助手")
                        .font(.system(size: 24, weight: .bold))

                    Text("输入一个大任务，AI 会帮你拆分成可执行的小步骤")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 32)

                // Input Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("输入任务")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.horizontal, 24)

                    ZStack(alignment: .topLeading) {
                        if taskInput.isEmpty {
                            Text("例如：准备Momo的体检")
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                        }

                        TextEditor(text: $taskInput)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(height: 120)
                            .scrollContentBackground(.hidden)
                    }
                    .background(Color(white: 0.95))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)

                    Button {
                        splitTask()
                    } label: {
                        HStack {
                            if isGenerating {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "sparkles")
                                Text("AI 拆分任务")
                            }
                        }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: taskInput.isEmpty ? [.gray] : [.orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .disabled(taskInput.isEmpty || isGenerating)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }

                // Results Section
                if !generatedTodos.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("已生成 \(generatedTodos.count) 个子任务")
                                .font(.system(size: 16, weight: .semibold))

                            Spacer()

                            Button {
                                generatedTodos = []
                            } label: {
                                Text("清空")
                                    .font(.system(size: 14))
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(Array(generatedTodos.enumerated()), id: \.offset) { index, todo in
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.orange.opacity(0.1))
                                                .frame(width: 32, height: 32)

                                            Text("\(index + 1)")
                                                .font(.system(size: 14, weight: .bold))
                                                .foregroundColor(.orange)
                                        }

                                        Text(todo)
                                            .font(.system(size: 15))
                                            .foregroundColor(.primary)
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                        Button {
                                            generatedTodos.remove(at: index)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray.opacity(0.3))
                                        }
                                    }
                                    .padding(16)
                                    .background(Color.white)
                                    .cornerRadius(16)
                                }
                            }
                            .padding(.horizontal, 24)
                        }

                        Button {
                            onTodosGenerated(generatedTodos)
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("添加到待办列表")
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.green)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                    }
                } else {
                    Spacer()
                }
            }
            .background(.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .alert("错误", isPresented: $showError) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    private func splitTask() {
        guard !taskInput.isEmpty else { return }

        isGenerating = true

        Task {
            do {
                let todos = try await apiClient.splitTodoList(task: taskInput)

                await MainActor.run {
                    isGenerating = false
                    generatedTodos = todos
                }
            } catch {
                await MainActor.run {
                    isGenerating = false
                    errorMessage = "拆分失败：\(error.localizedDescription)"
                    showError = true
                }
            }
        }
    }
}

#Preview {
    TodoSplitView { todos in
        print("Generated todos: \(todos)")
    }
}
