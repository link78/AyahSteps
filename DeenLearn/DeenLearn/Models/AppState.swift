//
//  AppState.swift
//  DeenLearn
//
//  App-wide state management
//

import SwiftUI

enum UserMode: String, Codable {
    case kids
    case adults
}

class AppState: ObservableObject {
    @Published var userMode: UserMode? {
        didSet {
            if let mode = userMode {
                UserDefaults.standard.set(mode.rawValue, forKey: "userMode")
            }
        }
    }
    
    @Published var completedLessons: Set<String> = []
    @Published var currentStreak: Int = 0
    @Published var totalPoints: Int = 0
    
    init() {
        // Load saved user mode
        if let savedMode = UserDefaults.standard.string(forKey: "userMode"),
           let mode = UserMode(rawValue: savedMode) {
            self.userMode = mode
        }
        
        // Load completed lessons
        if let savedLessons = UserDefaults.standard.array(forKey: "completedLessons") as? [String] {
            self.completedLessons = Set(savedLessons)
        }
        
        // Load streak and points
        self.currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        self.totalPoints = UserDefaults.standard.integer(forKey: "totalPoints")
    }
    
    func completeLesson(_ lessonId: String, points: Int = 10) {
        completedLessons.insert(lessonId)
        totalPoints += points
        UserDefaults.standard.set(Array(completedLessons), forKey: "completedLessons")
        UserDefaults.standard.set(totalPoints, forKey: "totalPoints")
    }
    
    func resetProgress() {
        completedLessons.removeAll()
        currentStreak = 0
        totalPoints = 0
        UserDefaults.standard.removeObject(forKey: "completedLessons")
        UserDefaults.standard.set(0, forKey: "currentStreak")
        UserDefaults.standard.set(0, forKey: "totalPoints")
    }
    
    func switchMode() {
        userMode = nil
        UserDefaults.standard.removeObject(forKey: "userMode")
    }
}
