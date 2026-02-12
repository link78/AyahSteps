//
//  ModulesView.swift
//  DeenLearn
//
//  Learning modules listing view
//

import SwiftUI

struct ModulesView: View {
    @EnvironmentObject var appState: AppState
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var modules: [LearningModule] {
        LearningModule.modulesFor(mode: appState.userMode ?? .adults)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(modules) { module in
                        NavigationLink(destination: ModuleDetailView(module: module)) {
                            ModuleCard(module: module, isKidsMode: isKidsMode)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(isKidsMode ? "📚 Learn" : "Learning Modules")
        }
    }
}

struct ModuleCard: View {
    let module: LearningModule
    let isKidsMode: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Module Icon
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(module.color.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(systemName: module.icon)
                    .font(.title)
                    .foregroundColor(module.color)
            }
            
            // Module Info
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(module.title)
                        .font(isKidsMode ? .title3.bold() : .headline)
                    
                    Text(module.titleArabic)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(module.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "book.closed.fill")
                        .font(.caption)
                    Text("\(module.lessons.count) lessons")
                        .font(.caption)
                }
                .foregroundColor(module.color)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct ModuleDetailView: View {
    @EnvironmentObject var appState: AppState
    let module: LearningModule
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Module Header
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(module.color.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: module.icon)
                            .font(.system(size: 40))
                            .foregroundColor(module.color)
                    }
                    
                    VStack(spacing: 8) {
                        Text(module.title)
                            .font(.largeTitle.bold())
                        
                        Text(module.titleArabic)
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text(module.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                
                // Lessons List
                VStack(alignment: .leading, spacing: 12) {
                    Text(isKidsMode ? "📖 Lessons" : "Lessons")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(module.lessons) { lesson in
                        NavigationLink(destination: LessonView(lesson: lesson, moduleColor: module.color)) {
                            LessonRow(
                                lesson: lesson,
                                isCompleted: appState.completedLessons.contains(lesson.id),
                                color: module.color,
                                isKidsMode: isKidsMode
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LessonRow: View {
    let lesson: Lesson
    let isCompleted: Bool
    let color: Color
    let isKidsMode: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Completion indicator
            ZStack {
                Circle()
                    .fill(isCompleted ? color : Color.gray.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: isCompleted ? "checkmark" : "play.fill")
                    .foregroundColor(isCompleted ? .white : color)
                    .font(.body)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(lesson.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text("\(lesson.duration) min")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isCompleted && isKidsMode {
                Text("⭐️")
                    .font(.title2)
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    ModulesView()
        .environmentObject(AppState())
}
