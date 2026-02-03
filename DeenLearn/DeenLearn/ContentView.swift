//
//  ContentView.swift
//  DeenLearn
//
//  Main content view with navigation
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.userMode == nil {
                WelcomeView()
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut, value: appState.userMode)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
