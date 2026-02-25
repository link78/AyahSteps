//
//  Profile.swift
//  DeenLearn
//
//  Profile and Parent Dashboard data models
//

import Foundation
import SwiftUI

// MARK: - User Profile

struct UserProfile: Identifiable {
    let id: UUID
    var name: String
    var displayName: String
    var avatarEmoji: String
    var email: String?
    var isParent: Bool
    var preferredLanguage: AppLanguage
    var createdAt: Date
    var profileImagePath: String?
    
    // Learning preferences
    var showArabicScript: Bool
    var showTransliteration: Bool
    var showTranslation: Bool
    var preferredTranslation: String
    var dailyGoalMinutes: Int
    var reminderTime: Date?
    var remindersEnabled: Bool
    
    /// Load the saved profile image from documents directory
    var profileImage: UIImage? {
        guard let path = profileImagePath else { return nil }
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    /// Save a profile image and return the file name
    @discardableResult
    mutating func saveProfileImage(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        // Delete previous image if it exists
        removeProfileImage()
        let fileName = "profile_\(id.uuidString).jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        do {
            try data.write(to: url)
            profileImagePath = fileName
            return fileName
        } catch {
            return nil
        }
    }
    
    /// Remove the saved profile image file from disk
    mutating func removeProfileImage() {
        if let path = profileImagePath {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(path)
            try? FileManager.default.removeItem(at: url)
            profileImagePath = nil
        }
    }
    
    static let sampleAdult = UserProfile(
        id: UUID(),
        name: "Abdullah",
        displayName: "Abu Ahmad",
        avatarEmoji: "👨",
        email: "abdullah@example.com",
        isParent: true,
        preferredLanguage: .english,
        createdAt: Date().addingTimeInterval(-30 * 24 * 60 * 60),
        showArabicScript: true,
        showTransliteration: true,
        showTranslation: true,
        preferredTranslation: "Sahih International",
        dailyGoalMinutes: 30,
        reminderTime: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()),
        remindersEnabled: true
    )
}

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case arabic = "العربية"
    case urdu = "اردو"
    case french = "Français"
    case turkish = "Türkçe"
    case indonesian = "Bahasa Indonesia"
    case malay = "Bahasa Melayu"
    
    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .arabic: return "🇸🇦"
        case .urdu: return "🇵🇰"
        case .french: return "🇫🇷"
        case .turkish: return "🇹🇷"
        case .indonesian: return "🇮🇩"
        case .malay: return "🇲🇾"
        }
    }
}

// MARK: - Child Profile (for Parent Dashboard)

struct ChildProfile: Identifiable, Codable {
    let id: UUID
    var name: String
    var avatarEmoji: String
    var age: Int
    var createdAt: Date
    
    // Progress tracking
    var totalLearningMinutes: Int
    var currentStreak: Int
    var longestStreak: Int
    var surahsMemorized: Int
    var arabicLettersLearned: Int
    var pillarsCompleted: Int
    var prayerStepsLearned: Int
    
    // Goals
    var dailyGoalMinutes: Int
    var weeklyGoalMinutes: Int
    var todayMinutes: Int
    var weekMinutes: Int
    
    // Controls
    var screenTimeLimit: Int // minutes per day
    var allowedCategories: Set<ContentCategory>
    var parentalControlsEnabled: Bool
    
    // Rewards
    var totalStars: Int
    var totalBadges: Int
    var achievements: [Achievement]
    
    var dailyGoalProgress: Double {
        guard dailyGoalMinutes > 0 else { return 0 }
        return min(Double(todayMinutes) / Double(dailyGoalMinutes), 1.0)
    }
    
    var weeklyGoalProgress: Double {
        guard weeklyGoalMinutes > 0 else { return 0 }
        return min(Double(weekMinutes) / Double(weeklyGoalMinutes), 1.0)
    }
    
    static let sampleChildren: [ChildProfile] = [
        ChildProfile(
            id: UUID(),
            name: "Ahmad",
            avatarEmoji: "👦",
            age: 8,
            createdAt: Date().addingTimeInterval(-60 * 24 * 60 * 60),
            totalLearningMinutes: 1250,
            currentStreak: 12,
            longestStreak: 21,
            surahsMemorized: 5,
            arabicLettersLearned: 20,
            pillarsCompleted: 3,
            prayerStepsLearned: 15,
            dailyGoalMinutes: 20,
            weeklyGoalMinutes: 100,
            todayMinutes: 15,
            weekMinutes: 75,
            screenTimeLimit: 30,
            allowedCategories: [.quran, .arabic, .pillars, .prayer],
            parentalControlsEnabled: true,
            totalStars: 245,
            totalBadges: 8,
            achievements: Array(Achievement.sampleAchievements.prefix(8))
        ),
        ChildProfile(
            id: UUID(),
            name: "Fatima",
            avatarEmoji: "👧",
            age: 6,
            createdAt: Date().addingTimeInterval(-45 * 24 * 60 * 60),
            totalLearningMinutes: 680,
            currentStreak: 5,
            longestStreak: 14,
            surahsMemorized: 3,
            arabicLettersLearned: 15,
            pillarsCompleted: 2,
            prayerStepsLearned: 10,
            dailyGoalMinutes: 15,
            weeklyGoalMinutes: 70,
            todayMinutes: 15,
            weekMinutes: 50,
            screenTimeLimit: 20,
            allowedCategories: [.quran, .arabic, .pillars],
            parentalControlsEnabled: true,
            totalStars: 156,
            totalBadges: 5,
            achievements: Array(Achievement.sampleAchievements.prefix(5))
        )
    ]
}

enum ContentCategory: String, CaseIterable, Codable {
    case quran = "Qur'an"
    case arabic = "Arabic"
    case pillars = "Pillars"
    case prayer = "Prayer"
    case advanced = "Advanced Topics"
    
    var icon: String {
        switch self {
        case .quran: return "📖"
        case .arabic: return "أ"
        case .pillars: return "🕌"
        case .prayer: return "🤲"
        case .advanced: return "📚"
        }
    }
}

// MARK: - Learning Goals

struct LearningGoal: Identifiable {
    let id: UUID
    var title: String
    var category: GoalCategory
    var targetValue: Int
    var currentValue: Int
    var unit: String
    var deadline: Date?
    var isCompleted: Bool
    
    var progress: Double {
        guard targetValue > 0 else { return 0 }
        return min(Double(currentValue) / Double(targetValue), 1.0)
    }
    
    static let sampleGoals: [LearningGoal] = [
        LearningGoal(
            id: UUID(),
            title: "Memorize Juz Amma",
            category: .quran,
            targetValue: 37,
            currentValue: 12,
            unit: "surahs",
            deadline: Calendar.current.date(byAdding: .month, value: 6, to: Date()),
            isCompleted: false
        ),
        LearningGoal(
            id: UUID(),
            title: "Learn Arabic Alphabet",
            category: .arabic,
            targetValue: 28,
            currentValue: 20,
            unit: "letters",
            deadline: Calendar.current.date(byAdding: .month, value: 1, to: Date()),
            isCompleted: false
        ),
        LearningGoal(
            id: UUID(),
            title: "Master Prayer Steps",
            category: .prayer,
            targetValue: 20,
            currentValue: 15,
            unit: "steps",
            deadline: nil,
            isCompleted: false
        ),
        LearningGoal(
            id: UUID(),
            title: "Complete 5 Pillars Course",
            category: .pillars,
            targetValue: 5,
            currentValue: 3,
            unit: "pillars",
            deadline: nil,
            isCompleted: false
        )
    ]
}

enum GoalCategory: String, CaseIterable {
    case quran = "Qur'an"
    case arabic = "Arabic"
    case prayer = "Prayer"
    case pillars = "Pillars"
    case daily = "Daily Practice"
    
    var color: Color {
        switch self {
        case .quran: return .green
        case .arabic: return .blue
        case .prayer: return .purple
        case .pillars: return .orange
        case .daily: return .teal
        }
    }
    
    var icon: String {
        switch self {
        case .quran: return "book.fill"
        case .arabic: return "character.textbox"
        case .prayer: return "hands.sparkles.fill"
        case .pillars: return "building.columns.fill"
        case .daily: return "calendar"
        }
    }
}

// MARK: - Achievements

struct Achievement: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var icon: String
    var category: AchievementCategory
    var earnedAt: Date?
    var isEarned: Bool
    var requirement: String
    
    static let sampleAchievements: [Achievement] = [
        // Qur'an Achievements
        Achievement(
            id: UUID(),
            title: "First Surah",
            description: "Memorized your first surah",
            icon: "📖",
            category: .quran,
            earnedAt: Date().addingTimeInterval(-20 * 24 * 60 * 60),
            isEarned: true,
            requirement: "Memorize 1 surah"
        ),
        Achievement(
            id: UUID(),
            title: "Surah Champion",
            description: "Memorized 5 surahs",
            icon: "🏆",
            category: .quran,
            earnedAt: Date().addingTimeInterval(-5 * 24 * 60 * 60),
            isEarned: true,
            requirement: "Memorize 5 surahs"
        ),
        Achievement(
            id: UUID(),
            title: "Juz Amma Master",
            description: "Completed Juz Amma",
            icon: "👑",
            category: .quran,
            earnedAt: nil,
            isEarned: false,
            requirement: "Memorize all 37 surahs of Juz Amma"
        ),
        
        // Prayer Achievements
        Achievement(
            id: UUID(),
            title: "Wudu Learned",
            description: "Completed wudu training",
            icon: "💧",
            category: .prayer,
            earnedAt: Date().addingTimeInterval(-25 * 24 * 60 * 60),
            isEarned: true,
            requirement: "Complete all wudu steps"
        ),
        Achievement(
            id: UUID(),
            title: "Prayer Master",
            description: "Learned all prayer positions",
            icon: "🤲",
            category: .prayer,
            earnedAt: Date().addingTimeInterval(-10 * 24 * 60 * 60),
            isEarned: true,
            requirement: "Complete salah training"
        ),
        
        // Arabic Achievements
        Achievement(
            id: UUID(),
            title: "Alphabet Explorer",
            description: "Learned 10 Arabic letters",
            icon: "أ",
            category: .arabic,
            earnedAt: Date().addingTimeInterval(-15 * 24 * 60 * 60),
            isEarned: true,
            requirement: "Learn 10 Arabic letters"
        ),
        Achievement(
            id: UUID(),
            title: "Alphabet Master",
            description: "Learned all 28 Arabic letters",
            icon: "🔤",
            category: .arabic,
            earnedAt: nil,
            isEarned: false,
            requirement: "Learn all 28 letters"
        ),
        
        // Pillars Achievements
        Achievement(
            id: UUID(),
            title: "Pillar Explorer",
            description: "Completed first pillar lesson",
            icon: "🏛️",
            category: .pillars,
            earnedAt: Date().addingTimeInterval(-22 * 24 * 60 * 60),
            isEarned: true,
            requirement: "Complete 1 pillar lesson"
        ),
        Achievement(
            id: UUID(),
            title: "Foundation Builder",
            description: "Completed all 5 pillars",
            icon: "🕌",
            category: .pillars,
            earnedAt: nil,
            isEarned: false,
            requirement: "Complete all 5 pillar lessons"
        ),
        
        // Streak Achievements
        Achievement(
            id: UUID(),
            title: "Week Warrior",
            description: "7-day learning streak",
            icon: "🔥",
            category: .streak,
            earnedAt: Date().addingTimeInterval(-7 * 24 * 60 * 60),
            isEarned: true,
            requirement: "Learn for 7 days in a row"
        ),
        Achievement(
            id: UUID(),
            title: "Month Master",
            description: "30-day learning streak",
            icon: "⭐",
            category: .streak,
            earnedAt: nil,
            isEarned: false,
            requirement: "Learn for 30 days in a row"
        ),
        Achievement(
            id: UUID(),
            title: "Consistency King",
            description: "100-day learning streak",
            icon: "💎",
            category: .streak,
            earnedAt: nil,
            isEarned: false,
            requirement: "Learn for 100 days in a row"
        )
    ]
}

enum AchievementCategory: String, CaseIterable, Codable {
    case quran = "Qur'an"
    case prayer = "Prayer"
    case arabic = "Arabic"
    case pillars = "Pillars"
    case streak = "Streaks"
    
    var color: Color {
        switch self {
        case .quran: return .green
        case .prayer: return .purple
        case .arabic: return .blue
        case .pillars: return .orange
        case .streak: return .red
        }
    }
}

// MARK: - Bookmark

struct Bookmark: Identifiable {
    let id: UUID
    var title: String
    var subtitle: String
    var category: BookmarkCategory
    var reference: String
    var createdAt: Date
    var note: String?
    
    static let sampleBookmarks: [Bookmark] = [
        Bookmark(
            id: UUID(),
            title: "Al-Fatiha",
            subtitle: "The Opening",
            category: .surah,
            reference: "Surah 1",
            createdAt: Date().addingTimeInterval(-5 * 24 * 60 * 60),
            note: "Review daily for memorization"
        ),
        Bookmark(
            id: UUID(),
            title: "Ayatul Kursi",
            subtitle: "Verse of the Throne",
            category: .ayah,
            reference: "Al-Baqarah 2:255",
            createdAt: Date().addingTimeInterval(-3 * 24 * 60 * 60),
            note: "Recite before sleep"
        ),
        Bookmark(
            id: UUID(),
            title: "Ruku Position",
            subtitle: "Prayer Step",
            category: .lesson,
            reference: "Salah Training",
            createdAt: Date().addingTimeInterval(-1 * 24 * 60 * 60),
            note: nil
        )
    ]
}

enum BookmarkCategory: String, CaseIterable {
    case surah = "Surah"
    case ayah = "Ayah"
    case lesson = "Lesson"
    case dua = "Dua"
    
    var icon: String {
        switch self {
        case .surah: return "book.fill"
        case .ayah: return "text.quote"
        case .lesson: return "graduationcap.fill"
        case .dua: return "hands.sparkles.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .surah: return .green
        case .ayah: return .blue
        case .lesson: return .purple
        case .dua: return .orange
        }
    }
}

// MARK: - Progress Analytics

struct ProgressAnalytics {
    var totalMinutesThisWeek: Int
    var totalMinutesThisMonth: Int
    var averageMinutesPerDay: Double
    var currentStreak: Int
    var longestStreak: Int
    var lessonsCompleted: Int
    var quizzesPassed: Int
    
    // Daily breakdown for the past 7 days
    var dailyMinutes: [DailyProgress]
    
    // Category breakdown
    var categoryProgress: [CategoryProgress]
    
    static let sample = ProgressAnalytics(
        totalMinutesThisWeek: 145,
        totalMinutesThisMonth: 520,
        averageMinutesPerDay: 20.7,
        currentStreak: 12,
        longestStreak: 21,
        lessonsCompleted: 45,
        quizzesPassed: 18,
        dailyMinutes: DailyProgress.sampleWeek,
        categoryProgress: CategoryProgress.sample
    )
}

struct DailyProgress: Identifiable {
    let id = UUID()
    var day: String
    var minutes: Int
    var date: Date
    
    static let sampleWeek: [DailyProgress] = [
        DailyProgress(day: "Mon", minutes: 25, date: Date().addingTimeInterval(-6 * 24 * 60 * 60)),
        DailyProgress(day: "Tue", minutes: 30, date: Date().addingTimeInterval(-5 * 24 * 60 * 60)),
        DailyProgress(day: "Wed", minutes: 15, date: Date().addingTimeInterval(-4 * 24 * 60 * 60)),
        DailyProgress(day: "Thu", minutes: 20, date: Date().addingTimeInterval(-3 * 24 * 60 * 60)),
        DailyProgress(day: "Fri", minutes: 25, date: Date().addingTimeInterval(-2 * 24 * 60 * 60)),
        DailyProgress(day: "Sat", minutes: 10, date: Date().addingTimeInterval(-1 * 24 * 60 * 60)),
        DailyProgress(day: "Sun", minutes: 20, date: Date())
    ]
}

struct CategoryProgress: Identifiable {
    let id = UUID()
    var category: GoalCategory
    var percentComplete: Double
    var lessonsCompleted: Int
    var totalLessons: Int
    
    static let sample: [CategoryProgress] = [
        CategoryProgress(category: .quran, percentComplete: 0.35, lessonsCompleted: 12, totalLessons: 37),
        CategoryProgress(category: .arabic, percentComplete: 0.72, lessonsCompleted: 20, totalLessons: 28),
        CategoryProgress(category: .prayer, percentComplete: 0.80, lessonsCompleted: 16, totalLessons: 20),
        CategoryProgress(category: .pillars, percentComplete: 0.60, lessonsCompleted: 3, totalLessons: 5)
    ]
}
