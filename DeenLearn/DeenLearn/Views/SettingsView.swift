//
//  SettingsView.swift
//  DeenLearn
//
//  App settings and preferences
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showResetAlert = false
    @State private var showModeSwitchAlert = false
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Current Mode Section
                Section {
                    HStack {
                        Image(systemName: isKidsMode ? "face.smiling.fill" : "person.fill")
                            .foregroundColor(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Current Mode")
                                .font(.headline)
                            Text(isKidsMode ? "Kids Mode" : "Adults Mode")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Switch") {
                            showModeSwitchAlert = true
                        }
                        .foregroundColor(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Learning Mode")
                }
                
                // Progress Section
                Section {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Total Points")
                        Spacer()
                        Text("\(appState.totalPoints)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Completed Lessons")
                        Spacer()
                        Text("\(appState.completedLessons.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("Current Streak")
                        Spacer()
                        Text("\(appState.currentStreak) days")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Your Progress")
                }
                
                // About Section
                Section {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link(destination: URL(string: "https://github.com/link78/AyahSteps")!) {
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                            Text("GitHub Repository")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("About DeenLearn")
                } footer: {
                    Text("DeenLearn - Islamic Learning for Kids & Adults. Making Islamic education simple, visual, joyful, and accessible for every age.")
                }
                
                // Danger Zone
                Section {
                    Button(action: { showResetAlert = true }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(.red)
                            Text("Reset All Progress")
                                .foregroundColor(.red)
                        }
                    }
                } header: {
                    Text("Data")
                } footer: {
                    Text("This will reset all your learning progress, points, and streaks. This action cannot be undone.")
                }
            }
            .navigationTitle(isKidsMode ? "⚙️ Settings" : "Settings")
            .alert("Reset Progress", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    appState.resetProgress()
                }
            } message: {
                Text("Are you sure you want to reset all your learning progress? This cannot be undone.")
            }
            .alert("Switch Mode", isPresented: $showModeSwitchAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Switch", role: .destructive) {
                    withAnimation {
                        appState.switchMode()
                    }
                }
            } message: {
                Text("Switch to \(isKidsMode ? "Adults" : "Kids") mode? Your progress will be saved.")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
