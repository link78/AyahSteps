//
//  MainTabView.swift
//  DeenLearn
//
//  Main tab navigation after user selects mode
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            PillarsView()
                .tabItem {
                    Label("Pillars", systemImage: "building.columns.fill")
                }
                .tag(1)
            
            ModulesView()
                .tabItem {
                    Label("Learn", systemImage: "book.fill")
                }
                .tag(2)
            
            QuranView()
                .tabItem {
                    Label("Quran", systemImage: "text.book.closed.fill")
                }
                .tag(3)
            
            ProgressView()
                .tabItem {
                    Label("Progress", systemImage: isKidsMode ? "star.fill" : "chart.bar.fill")
                }
                .tag(4)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(5)
        }
        .tint(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
