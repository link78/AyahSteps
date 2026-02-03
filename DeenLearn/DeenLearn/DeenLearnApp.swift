//
//  DeenLearnApp.swift
//  DeenLearn
//
//  Islamic Learning App for Kids & Adults
//

import SwiftUI

@main
struct DeenLearnApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
