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
            
            PrayerView()
                .tabItem {
                    Label("Prayer", systemImage: "person.fill")
                }
                .tag(2)
            
            QuranView()
                .tabItem {
                    Label("Quran", systemImage: "text.book.closed.fill")
                }
                .tag(3)
            
            Group {
                if isKidsMode {
                    HadithKidsWorldView()
                } else {
                    ArabicView()
                }
            }
            .tabItem {
                Label(isKidsMode ? "Hadith" : "Arabic",
                      systemImage: isKidsMode ? "sparkles" : "textformat.abc")
            }
            .tag(4)
            
            ProfileView()
                .tabItem {
                    Label(isKidsMode ? "Me" : "Profile", systemImage: "person.crop.circle.fill")
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
