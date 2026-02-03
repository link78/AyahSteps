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

// MARK: - Progress Tracking Models

struct LearningProgress: Codable {
    var salahMastery: Double = 0.0          // 0.0 to 1.0
    var quranMemorization: Double = 0.0     // 0.0 to 1.0
    var arabicLettersLearned: Int = 0       // out of 28
    var pillarsCompleted: Int = 0           // out of 5
    var lastLessonId: String?
    var lastLessonTitle: String?
    var currentQuranSurah: Int = 1
    var currentQuranAyah: Int = 1
    var currentSalahStep: Int = 1
    var currentArabicLetter: Int = 0        // Index of current letter
}

struct DailyGoal: Codable {
    var quranMinutes: Int = 5
    var salahPractice: Bool = false
    var arabicPractice: Bool = false
    var lastUpdated: Date = Date()
}

struct Badge: Identifiable, Codable {
    let id: String
    let title: String
    let icon: String
    let earnedDate: Date?
    var isEarned: Bool { earnedDate != nil }
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
    @Published var totalStars: Int = 0
    
    // New progress tracking
    @Published var learningProgress = LearningProgress()
    @Published var dailyGoal = DailyGoal()
    @Published var badges: [Badge] = []
    @Published var remindersEnabled: Bool = true
    @Published var prayerTimesEnabled: Bool = false
    
    // Arabic letters for tracking
    static let arabicLetters = ["ا", "ب", "ت", "ث", "ج", "ح", "خ", "د", "ذ", "ر", "ز", "س", "ش", "ص", "ض", "ط", "ظ", "ع", "غ", "ف", "ق", "ك", "ل", "م", "ن", "ه", "و", "ي"]
    
    var currentArabicLetter: String {
        let index = learningProgress.currentArabicLetter
        guard index < Self.arabicLetters.count else { return Self.arabicLetters[0] }
        return Self.arabicLetters[index]
    }
    
    var arabicLetterProgress: Double {
        Double(learningProgress.arabicLettersLearned) / Double(Self.arabicLetters.count)
    }
    
    var pillarsProgress: Double {
        Double(learningProgress.pillarsCompleted) / 5.0
    }
    
    init() {
        loadAllData()
        initializeBadges()
    }
    
    private func loadAllData() {
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
        self.totalStars = UserDefaults.standard.integer(forKey: "totalStars")
        
        // Load learning progress
        if let data = UserDefaults.standard.data(forKey: "learningProgress"),
           let progress = try? JSONDecoder().decode(LearningProgress.self, from: data) {
            self.learningProgress = progress
        }
        
        // Load daily goal
        if let data = UserDefaults.standard.data(forKey: "dailyGoal"),
           let goal = try? JSONDecoder().decode(DailyGoal.self, from: data) {
            self.dailyGoal = goal
        }
        
        // Load badges
        if let data = UserDefaults.standard.data(forKey: "badges"),
           let savedBadges = try? JSONDecoder().decode([Badge].self, from: data) {
            self.badges = savedBadges
        }
        
        self.remindersEnabled = UserDefaults.standard.bool(forKey: "remindersEnabled")
        self.prayerTimesEnabled = UserDefaults.standard.bool(forKey: "prayerTimesEnabled")
    }
    
    private func initializeBadges() {
        if badges.isEmpty {
            badges = [
                Badge(id: "first_step", title: "First Step", icon: "figure.walk", earnedDate: nil),
                Badge(id: "quran_starter", title: "Quran Starter", icon: "book.fill", earnedDate: nil),
                Badge(id: "salah_learner", title: "Salah Learner", icon: "person.fill", earnedDate: nil),
                Badge(id: "arabic_explorer", title: "Arabic Explorer", icon: "character.textbox", earnedDate: nil),
                Badge(id: "streak_master", title: "7-Day Streak", icon: "flame.fill", earnedDate: nil),
                Badge(id: "star_collector", title: "Star Collector", icon: "star.fill", earnedDate: nil),
                Badge(id: "pillar_champion", title: "Pillar Champion", icon: "building.columns.fill", earnedDate: nil),
                Badge(id: "dedication", title: "Dedicated Learner", icon: "heart.fill", earnedDate: nil)
            ]
        }
    }
    
    func completeLesson(_ lessonId: String, points: Int = 10) {
        completedLessons.insert(lessonId)
        totalPoints += points
        totalStars += 1
        
        // Update last lesson
        learningProgress.lastLessonId = lessonId
        
        saveProgress()
        checkBadges()
    }
    
    func updateSalahProgress(_ progress: Double) {
        learningProgress.salahMastery = min(1.0, progress)
        saveProgress()
    }
    
    func updateQuranProgress(_ progress: Double) {
        learningProgress.quranMemorization = min(1.0, progress)
        saveProgress()
    }
    
    func learnArabicLetter() {
        if learningProgress.arabicLettersLearned < Self.arabicLetters.count {
            learningProgress.arabicLettersLearned += 1
            learningProgress.currentArabicLetter = learningProgress.arabicLettersLearned
            totalStars += 1
            saveProgress()
            checkBadges()
        }
    }
    
    func completePillar() {
        if learningProgress.pillarsCompleted < 5 {
            learningProgress.pillarsCompleted += 1
            totalPoints += 50
            saveProgress()
            checkBadges()
        }
    }
    
    func incrementStreak() {
        currentStreak += 1
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        checkBadges()
    }
    
    private func saveProgress() {
        UserDefaults.standard.set(Array(completedLessons), forKey: "completedLessons")
        UserDefaults.standard.set(totalPoints, forKey: "totalPoints")
        UserDefaults.standard.set(totalStars, forKey: "totalStars")
        
        if let data = try? JSONEncoder().encode(learningProgress) {
            UserDefaults.standard.set(data, forKey: "learningProgress")
        }
        
        if let data = try? JSONEncoder().encode(dailyGoal) {
            UserDefaults.standard.set(data, forKey: "dailyGoal")
        }
    }
    
    private func checkBadges() {
        var updated = false
        
        for i in 0..<badges.count {
            if badges[i].earnedDate == nil {
                var earned = false
                
                switch badges[i].id {
                case "first_step":
                    earned = completedLessons.count >= 1
                case "quran_starter":
                    earned = learningProgress.quranMemorization > 0
                case "salah_learner":
                    earned = learningProgress.salahMastery >= 0.25
                case "arabic_explorer":
                    earned = learningProgress.arabicLettersLearned >= 7
                case "streak_master":
                    earned = currentStreak >= 7
                case "star_collector":
                    earned = totalStars >= 50
                case "pillar_champion":
                    earned = learningProgress.pillarsCompleted >= 5
                case "dedication":
                    earned = completedLessons.count >= 20
                default:
                    break
                }
                
                if earned {
                    badges[i] = Badge(id: badges[i].id, title: badges[i].title, icon: badges[i].icon, earnedDate: Date())
                    updated = true
                }
            }
        }
        
        if updated {
            if let data = try? JSONEncoder().encode(badges) {
                UserDefaults.standard.set(data, forKey: "badges")
            }
        }
    }
    
    func resetProgress() {
        completedLessons.removeAll()
        currentStreak = 0
        totalPoints = 0
        totalStars = 0
        learningProgress = LearningProgress()
        dailyGoal = DailyGoal()
        initializeBadges()
        
        UserDefaults.standard.removeObject(forKey: "completedLessons")
        UserDefaults.standard.set(0, forKey: "currentStreak")
        UserDefaults.standard.set(0, forKey: "totalPoints")
        UserDefaults.standard.set(0, forKey: "totalStars")
        UserDefaults.standard.removeObject(forKey: "learningProgress")
        UserDefaults.standard.removeObject(forKey: "dailyGoal")
        UserDefaults.standard.removeObject(forKey: "badges")
    }
    
    func switchMode() {
        userMode = nil
        UserDefaults.standard.removeObject(forKey: "userMode")
    }
}
