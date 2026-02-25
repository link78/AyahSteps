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
    @State private var showAddChild = false
    
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
                
                // Family Profiles Section
                Section {
                    // Active profile indicator
                    if let activeChild = appState.activeChildProfile {
                        HStack {
                            Text(activeChild.avatarEmoji)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Using: \(activeChild.name)")
                                    .font(.headline)
                                Text("Age \(activeChild.age)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button("Switch to Parent") {
                                appState.switchToParentProfile()
                            }
                            .font(.subheadline)
                            .foregroundColor(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
                        }
                        .padding(.vertical, 4)
                    } else {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
                                .font(.title2)
                            Text("Parent Profile (Active)")
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // Child profiles list
                    ForEach(appState.childProfiles) { child in
                        HStack {
                            Text(child.avatarEmoji)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(child.name)
                                    .font(.subheadline)
                                Text("Age \(child.age)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if appState.activeChildProfileId == child.id {
                                Text("Active")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            } else {
                                Button("Use") {
                                    appState.switchToChildProfile(id: child.id)
                                }
                                .font(.subheadline)
                                .foregroundColor(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
                            }
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let child = appState.childProfiles[index]
                            appState.removeChildProfile(id: child.id)
                        }
                    }
                    
                    // Add child button
                    Button(action: { showAddChild = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
                            Text("Add Child Profile")
                                .foregroundColor(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
                        }
                    }
                } header: {
                    Text("Family Profiles")
                } footer: {
                    Text("Create profiles for your children to track their learning progress separately. Swipe left on a profile to remove it.")
                }
                
                // Appearance Section
                Section {
                    Picker(selection: $appState.appearanceMode) {
                        ForEach(AppearanceMode.allCases, id: \.self) { mode in
                            Label(mode.rawValue, systemImage: mode.icon)
                                .tag(mode)
                        }
                    } label: {
                        HStack {
                            Image(systemName: appState.appearanceMode.icon)
                                .foregroundColor(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
                                .font(.title2)
                            Text("Appearance")
                        }
                    }
                } header: {
                    Text("Display")
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
            .sheet(isPresented: $showAddChild) {
                AddChildSheet(onAdd: { child in
                    appState.addChildProfile(child)
                })
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
