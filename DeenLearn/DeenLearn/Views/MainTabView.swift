//
//  MainTabView.swift
//  DeenLearn
//
//  Main tab navigation after user selects mode
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
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
            
            Group {
                if isKidsMode {
                    HadithKidsWorldView()
                } else {
                    HadithAdultView()
                }
            }
                .tabItem {
                    Label("Hadith", systemImage: "sparkles")
                }
                .tag(2)
            
            PrayerView()
                .tabItem {
                    Label("Prayer", systemImage: "person.fill")
                }
                .tag(3)
            
            QuranView()
                .tabItem {
                    Label("Quran", systemImage: "text.book.closed.fill")
                }
                .tag(4)
            
            ArabicView()
                .tabItem {
                    Label("Arabic", systemImage: "textformat.abc")
                }
                .tag(5)
            
            ProfileView()
                .tabItem {
                    Label(isKidsMode ? "Me" : "Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(6)
        }
        .tint(isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e"))
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
