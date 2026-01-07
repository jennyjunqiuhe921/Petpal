//
//  HealthView.swift
//  Petpal
//
//  Created by Claude on 2026/1/7.
//

import SwiftUI
import Charts

struct HealthView: View {
    @State private var currentPetIndex = 0
    @State private var pets = Pet.mockData
    @State private var showTodoSplit = false

    private var currentPet: Pet {
        pets[currentPetIndex]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                HeaderSection(pet: currentPet, togglePet: togglePet)

                VStack(spacing: 24) {
                    // Quick Actions
                    QuickActionsCard()

                    // AI Todo Split Button
                    Button {
                        showTodoSplit = true
                    } label: {
                        HStack {
                            Image(systemName: "sparkles.rectangle.stack.fill")
                                .font(.system(size: 20))

                            Text("AI 任务拆分")
                                .font(.system(size: 16, weight: .bold))

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray.opacity(0.5))
                        }
                        .foregroundColor(.white)
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(24)
                        .shadow(color: Color.orange.opacity(0.3), radius: 8, x: 0, y: 4)
                    }

                    // Today's Tasks
                    TasksCard(tasks: $pets[currentPetIndex].tasks)

                    // Weight Chart
                    WeightChartCard(pet: currentPet)
                }
                .padding(.horizontal, 24)
                .padding(.top, -64)
                .padding(.bottom, 100)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showTodoSplit) {
            TodoSplitView { newTodos in
                // Add new todos to current pet's tasks
                let newTasks = newTodos.map { title in
                    PetTask(title: title, time: "待办", done: false)
                }
                pets[currentPetIndex].tasks.append(contentsOf: newTasks)
            }
        }
    }

    private func togglePet() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentPetIndex = (currentPetIndex + 1) % pets.count
        }
    }
}

struct HeaderSection: View {
    let pet: Pet
    let togglePet: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(Color.orange)
                .frame(height: 220)
                .ignoresSafeArea(edges: .top)

            HStack(alignment: .top) {
                // Pet Avatar & Info
                Button(action: togglePet) {
                    HStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 64, height: 64)

                            Circle()
                                .fill(Color.orange.opacity(0.3))
                                .frame(width: 64, height: 64)

                            Image(systemName: pet.name == "Momo" ? "dog.fill" : "cat.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white)

                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                                .padding(4)
                                .background(Circle().fill(Color.white))
                                .offset(x: 4, y: 4)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text(pet.name)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)

                                Text(pet.breed)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(12)
                            }

                            Text("已陪伴你 \(pet.days) 天")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                // Bell Icon
                Button {} label: {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 80)
        }
    }
}

struct QuickActionsCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ActionButton(icon: "doc.text.fill", label: "电子病历", color: .blue)
                ActionButton(icon: "syringe.fill", label: "疫苗提醒", color: .green)
                ActionButton(icon: "scalemass.fill", label: "体重记录", color: .orange)
                ActionButton(icon: "flask.fill", label: "化验存档", color: .purple)
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(32)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

struct ActionButton: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        Button {} label: {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(color.opacity(0.1))
                        .frame(width: 56, height: 56)

                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                }

                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

struct TasksCard: View {
    @Binding var tasks: [PetTask]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("今日待办")
                    .font(.system(size: 18, weight: .bold))

                Text("\(tasks.filter { !$0.done }.count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)

                Spacer()
            }

            VStack(spacing: 16) {
                ForEach(tasks.indices, id: \.self) { index in
                    HStack(spacing: 12) {
                        // Timeline Dot
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .frame(width: 24, height: 24)

                            Circle()
                                .fill(Color.orange)
                                .frame(width: 8, height: 8)
                        }

                        // Task Content
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(tasks[index].title)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(tasks[index].done ? .secondary : .primary)
                                    .strikethrough(tasks[index].done)

                                Text(tasks[index].time)
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Button {
                                withAnimation {
                                    tasks[index].done.toggle()
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(tasks[index].done ? Color.green : Color.white)
                                        .frame(width: 32, height: 32)

                                    if !tasks[index].done {
                                        Circle()
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                            .frame(width: 32, height: 32)
                                    }

                                    if tasks[index].done {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(16)
                    }
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(32)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

struct WeightChartCard: View {
    let pet: Pet

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("体重曲线")
                    .font(.system(size: 18, weight: .bold))

                Spacer()

                Text("近6个月")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            // Chart
            Chart(pet.weightData) { entry in
                LineMark(
                    x: .value("月份", entry.month),
                    y: .value("体重", entry.weight)
                )
                .foregroundStyle(Color.orange)
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("月份", entry.month),
                    y: .value("体重", entry.weight)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.3), Color.orange.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
            .frame(height: 180)
            .chartYScale(domain: .automatic(includesZero: false))

            // Diet Tags
            FlowLayout(spacing: 8) {
                ForEach(pet.diet, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(16)
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(32)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

// Flow Layout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                frames.append(CGRect(origin: CGPoint(x: currentX, y: currentY), size: size))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }

            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview {
    HealthView()
}
