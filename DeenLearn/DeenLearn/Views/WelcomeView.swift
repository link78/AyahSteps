//
//  WelcomeView.swift
//  DeenLearn
//
//  Welcome screen for user mode selection
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingModeSelection = false
    @State private var showAgeSelection = false
    @State private var selectedMode: UserMode?
    
    var body: some View {
        ZStack {
            // Beautiful gradient background
            LinearGradient(
                colors: [Color(hex: "1a5f4a"), Color(hex: "2d8b6e"), Color(hex: "3eb489")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // App Logo and Title
                VStack(spacing: 20) {
                    // DeenLearn logo
                    Image("DeenLearnLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 140, height: 140)
                    
                    VStack(spacing: 8) {
                        Text("DeenLearn")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("دين لرن")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("Islamic Learning for Everyone")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 4)
                    }
                }
                
                Spacer()
                
                // Mode Selection Buttons
                VStack(spacing: 16) {
                    Text("I am learning as...")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    // Kids Mode Button
                    Button(action: {
                        selectedMode = .kids
                        showAgeSelection = true
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "face.smiling.fill")
                                .font(.system(size: 32))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Kids Mode")
                                    .font(.title2.bold())
                                Text("Fun & colorful learning")
                                    .font(.subheadline)
                                    .opacity(0.8)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                        }
                        .foregroundColor(Color(hex: "1a5f4a"))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    }
                    
                    // Adults Mode Button
                    Button(action: {
                        selectedMode = .adults
                        withAnimation(.spring(response: 0.3)) {
                            appState.userMode = .adults
                        }
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Adults Mode")
                                    .font(.title2.bold())
                                Text("In-depth Islamic knowledge")
                                    .font(.subheadline)
                                    .opacity(0.8)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Footer
                VStack(spacing: 8) {
                    Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("In the name of Allah, the Most Gracious, the Most Merciful")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showAgeSelection) {
            AgeSelectionSheet(selectedMode: selectedMode ?? .kids) {
                // Completion handler - set the mode after age is selected
                withAnimation(.spring(response: 0.3)) {
                    appState.userMode = selectedMode
                }
            }
            .environmentObject(appState)
            .presentationDetents([.large])
            .interactiveDismissDisabled(false)
        }
    }
}

// MARK: - Age Selection Sheet

struct AgeSelectionSheet: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let selectedMode: UserMode
    let onComplete: () -> Void
    
    @State private var selectedAge: Int = 10
    
    // iPad detection
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isKidsMode: Bool {
        selectedMode == .kids
    }
    
    var ageRange: [Int] {
        isKidsMode ? Array(4...17) : Array(13...99)
    }
    
    var ageGroupDescription: String {
        switch selectedAge {
        case 4...6:
            return "Early Childhood - Simple, fun learning with lots of visuals"
        case 7...9:
            return "Children - Interactive lessons with rewards and stories"
        case 10...12:
            return "Tweens - More detailed content with Islamic vocabulary"
        case 13...17:
            return "Teens - Scholarly content with fiqh basics"
        default:
            return "Adults - Full scholarly content and detailed lessons"
        }
    }
    
    var ageGroupEmoji: String {
        switch selectedAge {
        case 4...6: return "🧸"
        case 7...9: return "⭐"
        case 10...12: return "🌟"
        case 13...17: return "📚"
        default: return "🎓"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Text(ageGroupEmoji)
                            .font(.system(size: 60))
                        
                        Text(isKidsMode ? "How old are you?" : "Select your age")
                            .font(.title.bold())
                        
                        Text("We'll personalize your learning experience")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Age Picker
                    Picker("Age", selection: $selectedAge) {
                        ForEach(ageRange, id: \.self) { age in
                            Text("\(age) years old")
                                .tag(age)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                    
                    // Age group description
                    VStack(spacing: 8) {
                        Text("Learning Level")
                            .font(.headline)
                        
                        Text(ageGroupDescription)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Content preview based on age
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What you'll get:")
                            .font(.headline)
                        
                        ForEach(contentFeatures, id: \.self) { feature in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(feature)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Continue Button - Always visible
                    Button(action: {
                        appState.userAge = selectedAge
                        dismiss()
                        onComplete()
                    }) {
                        Text("Let's Start Learning!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: isIPad ? 400 : .infinity)
                            .padding()
                            .background(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                }
                .frame(maxWidth: isIPad ? 600 : .infinity)
                .frame(maxWidth: .infinity) // Center on iPad
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var contentFeatures: [String] {
        switch selectedAge {
        case 4...6:
            return [
                "Big, colorful pictures and animations",
                "Simple 1-2 word instructions",
                "5-minute fun sessions",
                "Lots of stars and rewards!",
                "Animated characters to guide you"
            ]
        case 7...9:
            return [
                "Fun stories about Islamic heroes",
                "Interactive games and quizzes",
                "10-minute engaging lessons",
                "Badge collection and streaks",
                "Easy Arabic letter tracing"
            ]
        case 10...12:
            return [
                "Detailed Islamic knowledge",
                "Arabic vocabulary building",
                "15-minute focused sessions",
                "Progress tracking",
                "Mini-games with learning"
            ]
        case 13...17:
            return [
                "Scholarly Islamic content",
                "Basic fiqh introduction",
                "20-minute comprehensive lessons",
                "Quran memorization tools",
                "Critical thinking exercises"
            ]
        default:
            return [
                "Full scholarly content",
                "Detailed fiqh discussions",
                "Flexible session lengths",
                "Advanced tajweed rules",
                "In-depth Quran study"
            ]
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppState())
}
