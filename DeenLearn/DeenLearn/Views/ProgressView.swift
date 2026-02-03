//
//  ProgressView.swift
//  DeenLearn
//
//  Progress tracking view
//

import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var appState: AppState
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var completionPercentage: Double {
        let totalLessons = LearningModule.modulesFor(mode: appState.userMode ?? .adults)
            .flatMap { $0.lessons }
            .count
        guard totalLessons > 0 else { return 0 }
        return Double(appState.completedLessons.count) / Double(totalLessons) * 100
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Main Progress Card
                    VStack(spacing: 20) {
                        if isKidsMode {
                            // Kids Mode - Fun progress display
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                                    .frame(width: 180, height: 180)
                                
                                Circle()
                                    .trim(from: 0, to: completionPercentage / 100)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color(hex: "FF6B6B"), Color(hex: "FFE66D")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                    )
                                    .frame(width: 180, height: 180)
                                    .rotationEffect(.degrees(-90))
                                
                                VStack {
                                    Text("⭐️")
                                        .font(.largeTitle)
                                    Text("\(Int(completionPercentage))%")
                                        .font(.title.bold())
                                }
                            }
                            
                            Text("Keep going, you're doing great!")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        } else {
                            // Adults Mode - Clean progress display
                            VStack(spacing: 8) {
                                Text("\(Int(completionPercentage))%")
                                    .font(.system(size: 60, weight: .bold))
                                    .foregroundColor(Color(hex: "2d8b6e"))
                                
                                Text("Course Completion")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            
                            ProgressBar(value: completionPercentage / 100, color: Color(hex: "2d8b6e"))
                                .frame(height: 12)
                                .padding(.horizontal)
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                    .padding(.horizontal)
                    
                    // Stats Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ProgressStatCard(
                            title: isKidsMode ? "Points" : "Total Points",
                            value: "\(appState.totalPoints)",
                            icon: "star.fill",
                            color: .yellow,
                            isKidsMode: isKidsMode
                        )
                        
                        ProgressStatCard(
                            title: isKidsMode ? "Lessons Done" : "Completed",
                            value: "\(appState.completedLessons.count)",
                            icon: "checkmark.circle.fill",
                            color: .green,
                            isKidsMode: isKidsMode
                        )
                        
                        ProgressStatCard(
                            title: "Day Streak",
                            value: "\(appState.currentStreak)",
                            icon: "flame.fill",
                            color: .orange,
                            isKidsMode: isKidsMode
                        )
                        
                        ProgressStatCard(
                            title: isKidsMode ? "Modules" : "Modules Started",
                            value: "\(modulesStarted)",
                            icon: "book.fill",
                            color: .purple,
                            isKidsMode: isKidsMode
                        )
                    }
                    .padding(.horizontal)
                    
                    // Achievements Section (Kids Mode)
                    if isKidsMode {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("🏆 Achievements")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    AchievementBadge(
                                        title: "First Step",
                                        icon: "figure.walk",
                                        isUnlocked: appState.completedLessons.count >= 1
                                    )
                                    
                                    AchievementBadge(
                                        title: "Learner",
                                        icon: "book.fill",
                                        isUnlocked: appState.completedLessons.count >= 5
                                    )
                                    
                                    AchievementBadge(
                                        title: "Star Student",
                                        icon: "star.fill",
                                        isUnlocked: appState.totalPoints >= 100
                                    )
                                    
                                    AchievementBadge(
                                        title: "Quran Reader",
                                        icon: "text.book.closed.fill",
                                        isUnlocked: appState.completedLessons.contains("quran-fatiha")
                                    )
                                    
                                    AchievementBadge(
                                        title: "Champion",
                                        icon: "trophy.fill",
                                        isUnlocked: appState.completedLessons.count >= 10
                                    )
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Module Progress
                    VStack(alignment: .leading, spacing: 16) {
                        Text(isKidsMode ? "📚 Module Progress" : "Module Progress")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(LearningModule.modulesFor(mode: appState.userMode ?? .adults)) { module in
                            ModuleProgressRow(module: module, appState: appState, isKidsMode: isKidsMode)
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(isKidsMode ? "⭐️ My Progress" : "Progress")
        }
    }
    
    var modulesStarted: Int {
        let modules = LearningModule.modulesFor(mode: appState.userMode ?? .adults)
        return modules.filter { module in
            module.lessons.contains { appState.completedLessons.contains($0.id) }
        }.count
    }
}

struct ProgressBar: View {
    let value: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                
                Capsule()
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(min(value, 1.0)))
            }
        }
    }
}

struct ProgressStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let isKidsMode: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(value)
                .font(.title.bold())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct AchievementBadge: View {
    let title: String
    let icon: String
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isUnlocked ? .yellow : .gray)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(isUnlocked ? .primary : .secondary)
        }
        .opacity(isUnlocked ? 1 : 0.5)
    }
}

struct ModuleProgressRow: View {
    let module: LearningModule
    let appState: AppState
    let isKidsMode: Bool
    
    var completedCount: Int {
        module.lessons.filter { appState.completedLessons.contains($0.id) }.count
    }
    
    var progressValue: Double {
        guard module.lessons.count > 0 else { return 0 }
        return Double(completedCount) / Double(module.lessons.count)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: module.icon)
                    .foregroundColor(module.color)
                
                Text(module.title)
                    .font(.headline)
                
                Spacer()
                
                Text("\(completedCount)/\(module.lessons.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressBar(value: progressValue, color: module.color)
                .frame(height: 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    ProgressView()
        .environmentObject(AppState())
}
