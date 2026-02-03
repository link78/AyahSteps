//
//  LessonView.swift
//  DeenLearn
//
//  Individual lesson content view
//

import SwiftUI

struct LessonView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let lesson: Lesson
    let moduleColor: Color
    
    @State private var currentStepIndex = 0
    @State private var showCompletionCelebration = false
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var isCompleted: Bool {
        appState.completedLessons.contains(lesson.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Lesson Header
                VStack(spacing: 12) {
                    Text(lesson.title)
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                    
                    Text(lesson.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        Label("\(lesson.duration) min", systemImage: "clock")
                        
                        if isCompleted {
                            Label("Completed", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding()
                
                // Content based on type
                switch lesson.content {
                case .text(let content):
                    TextLessonContent(content: content, color: moduleColor, isKidsMode: isKidsMode)
                    
                case .steps(let steps):
                    StepsLessonContent(
                        steps: steps,
                        currentIndex: $currentStepIndex,
                        color: moduleColor,
                        isKidsMode: isKidsMode
                    )
                    
                case .quran(let quranLesson):
                    QuranLessonContent(quranLesson: quranLesson, color: moduleColor, isKidsMode: isKidsMode)
                }
                
                // Complete Button
                if !isCompleted {
                    Button(action: completeLesson) {
                        HStack {
                            Image(systemName: isKidsMode ? "star.fill" : "checkmark.circle.fill")
                            Text(isKidsMode ? "I Learned It! ⭐️" : "Mark as Complete")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(moduleColor)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if showCompletionCelebration {
                CompletionCelebrationView(isKidsMode: isKidsMode) {
                    showCompletionCelebration = false
                    dismiss()
                }
            }
        }
    }
    
    private func completeLesson() {
        appState.completeLesson(lesson.id, points: isKidsMode ? 20 : 10)
        
        if isKidsMode {
            showCompletionCelebration = true
        } else {
            dismiss()
        }
    }
}

struct TextLessonContent: View {
    let content: String
    let color: Color
    let isKidsMode: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(content)
                .font(isKidsMode ? .title3 : .body)
                .lineSpacing(8)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
        }
        .padding(.horizontal)
    }
}

struct StepsLessonContent: View {
    let steps: [LessonStep]
    @Binding var currentIndex: Int
    let color: Color
    let isKidsMode: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Progress indicator
            HStack(spacing: 4) {
                ForEach(0..<steps.count, id: \.self) { index in
                    Capsule()
                        .fill(index <= currentIndex ? color : Color.gray.opacity(0.3))
                        .frame(height: 4)
                }
            }
            .padding(.horizontal)
            
            // Current Step
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Text("\(steps[currentIndex].stepNumber)")
                        .font(.largeTitle.bold())
                        .foregroundColor(color)
                }
                
                Text(steps[currentIndex].title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                
                Text(steps[currentIndex].description)
                    .font(isKidsMode ? .title3 : .body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .padding(.horizontal)
            
            // Navigation Buttons
            HStack(spacing: 16) {
                Button(action: { currentIndex = max(0, currentIndex - 1) }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Previous")
                    }
                    .foregroundColor(currentIndex > 0 ? color : .gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
                .disabled(currentIndex == 0)
                
                Button(action: { currentIndex = min(steps.count - 1, currentIndex + 1) }) {
                    HStack {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(currentIndex < steps.count - 1 ? color : .gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
                .disabled(currentIndex == steps.count - 1)
            }
            .padding(.horizontal)
            
            // All steps list
            VStack(alignment: .leading, spacing: 12) {
                Text(isKidsMode ? "📋 All Steps" : "All Steps")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(steps) { step in
                    Button(action: { currentIndex = step.stepNumber - 1 }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(step.stepNumber - 1 == currentIndex ? color : Color.gray.opacity(0.2))
                                    .frame(width: 32, height: 32)
                                
                                Text("\(step.stepNumber)")
                                    .font(.caption.bold())
                                    .foregroundColor(step.stepNumber - 1 == currentIndex ? .white : .secondary)
                            }
                            
                            Text(step.title)
                                .font(.subheadline)
                                .foregroundColor(step.stepNumber - 1 == currentIndex ? color : .primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(.top)
        }
    }
}

struct QuranLessonContent: View {
    let quranLesson: QuranLesson
    let color: Color
    let isKidsMode: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Surah Header
            VStack(spacing: 8) {
                Text("سورة \(quranLesson.surahNameArabic)")
                    .font(.title)
                
                Text("Surah \(quranLesson.surahName)")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(color.opacity(0.1))
            .cornerRadius(16)
            .padding(.horizontal)
            
            // Verses
            ForEach(quranLesson.verses) { verse in
                VStack(spacing: 16) {
                    // Verse number
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(color.opacity(0.2))
                                .frame(width: 32, height: 32)
                            
                            Text("\(verse.id)")
                                .font(.caption.bold())
                                .foregroundColor(color)
                        }
                    }
                    
                    // Arabic text
                    Text(verse.arabic)
                        .font(.system(size: isKidsMode ? 28 : 32, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    // Transliteration
                    Text(verse.transliteration)
                        .font(isKidsMode ? .title3 : .headline)
                        .foregroundColor(color)
                        .multilineTextAlignment(.center)
                    
                    // Translation
                    Text(verse.translation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Divider()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
            }
        }
    }
}

struct CompletionCelebrationView: View {
    let isKidsMode: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("🎉")
                    .font(.system(size: 80))
                
                Text("Amazing Job!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text("You earned +20 points!")
                    .font(.title2)
                    .foregroundColor(.yellow)
                
                Text("⭐️ ⭐️ ⭐️")
                    .font(.largeTitle)
                
                Button(action: onDismiss) {
                    Text("Continue Learning")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 32)
                        .background(Color(hex: "FF6B6B"))
                        .cornerRadius(16)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(hex: "2d8b6e"))
            )
            .padding(40)
        }
    }
}

#Preview {
    NavigationStack {
        LessonView(
            lesson: LearningModule.sampleModules[0].lessons[1],
            moduleColor: .blue
        )
        .environmentObject(AppState())
    }
}
