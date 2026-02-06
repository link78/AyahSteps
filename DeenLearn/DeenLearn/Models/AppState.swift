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

// MARK: - Age Group System

enum AgeGroup: String, Codable, CaseIterable {
    case earlyChildhood = "Early Childhood"  // 4-6 years
    case children = "Children"               // 7-9 years
    case tweens = "Tweens"                   // 10-12 years
    case teens = "Teens"                     // 13-17 years
    case adults = "Adults"                   // 18+ years
    
    var ageRange: String {
        switch self {
        case .earlyChildhood: return "4-6"
        case .children: return "7-9"
        case .tweens: return "10-12"
        case .teens: return "13-17"
        case .adults: return "18+"
        }
    }
    
    var minAge: Int {
        switch self {
        case .earlyChildhood: return 4
        case .children: return 7
        case .tweens: return 10
        case .teens: return 13
        case .adults: return 18
        }
    }
    
    var maxAge: Int {
        switch self {
        case .earlyChildhood: return 6
        case .children: return 9
        case .tweens: return 12
        case .teens: return 17
        case .adults: return 99
        }
    }
    
    // Reading and comprehension level
    var readingLevel: String {
        switch self {
        case .earlyChildhood: return "Simple"
        case .children: return "Easy"
        case .tweens: return "Moderate"
        case .teens: return "Advanced"
        case .adults: return "Scholarly"
        }
    }
    
    // Vocabulary complexity (1-5 scale)
    var vocabularyLevel: Int {
        switch self {
        case .earlyChildhood: return 1
        case .children: return 2
        case .tweens: return 3
        case .teens: return 4
        case .adults: return 5
        }
    }
    
    // Recommended session length in minutes
    var recommendedSessionLength: Int {
        switch self {
        case .earlyChildhood: return 5
        case .children: return 10
        case .tweens: return 15
        case .teens: return 20
        case .adults: return 30
        }
    }
    
    // Memorization chunk size (words per session)
    var memorizationChunkSize: Int {
        switch self {
        case .earlyChildhood: return 3
        case .children: return 5
        case .tweens: return 7
        case .teens: return 10
        case .adults: return 15
        }
    }
    
    // Font size multiplier for readability
    var fontSizeMultiplier: CGFloat {
        switch self {
        case .earlyChildhood: return 1.4
        case .children: return 1.2
        case .tweens: return 1.1
        case .teens: return 1.0
        case .adults: return 1.0
        }
    }
    
    // Whether to show scholarly/fiqh content
    var showScholarlyContent: Bool {
        switch self {
        case .earlyChildhood, .children: return false
        case .tweens: return false
        case .teens, .adults: return true
        }
    }
    
    // Greeting based on age
    var greeting: String {
        switch self {
        case .earlyChildhood: return "Little Explorer"
        case .children: return "Young Learner"
        case .tweens: return "Star Student"
        case .teens: return "Knowledge Seeker"
        case .adults: return "Dear Learner"
        }
    }
    
    // Daily goal description complexity
    func dailyGoalText(for activity: String) -> String {
        switch self {
        case .earlyChildhood:
            switch activity {
            case "quran": return "Listen to Quran! 📖"
            case "salah": return "Learn to pray! 🙏"
            case "arabic": return "Fun letters! ✨"
            default: return "Let's learn!"
            }
        case .children:
            switch activity {
            case "quran": return "Read some Quran today"
            case "salah": return "Practice your salah"
            case "arabic": return "Learn a new letter"
            default: return "Keep learning!"
            }
        case .tweens:
            switch activity {
            case "quran": return "Continue your Quran lesson"
            case "salah": return "Practice salah steps"
            case "arabic": return "Learn Arabic vocabulary"
            default: return "Continue learning"
            }
        case .teens, .adults:
            switch activity {
            case "quran": return "Continue Quran memorization"
            case "salah": return "Review salah with tajweed"
            case "arabic": return "Study Arabic grammar"
            default: return "Resume your studies"
            }
        }
    }
    
    // Age-appropriate encouragement
    var encouragementMessage: String {
        switch self {
        case .earlyChildhood: return "You're doing amazing! ⭐🎉"
        case .children: return "Great job! Keep going! 🌟"
        case .tweens: return "Excellent progress! You're learning so much!"
        case .teens: return "MashAllah! Your dedication is inspiring."
        case .adults: return "May Allah bless your efforts in seeking knowledge."
        }
    }
    
    // Content guidelines for this age group
    var contentGuidelines: [String] {
        switch self {
        case .earlyChildhood:
            return [
                "Use simple 1-2 syllable words",
                "Lots of pictures and animations",
                "Sessions under 5 minutes",
                "Repetition is key",
                "Heavy use of rewards and praise",
                "No complex concepts"
            ]
        case .children:
            return [
                "Simple sentences",
                "Interactive elements",
                "Sessions 10-15 minutes",
                "Basic Islamic concepts",
                "Star and badge rewards",
                "Stories and characters"
            ]
        case .tweens:
            return [
                "More detailed explanations",
                "Some Arabic terminology",
                "Sessions 15-20 minutes",
                "Basic reasoning and wisdom",
                "Achievement tracking",
                "Peer comparisons okay"
            ]
        case .teens:
            return [
                "Scholarly references acceptable",
                "Critical thinking encouraged",
                "Sessions 20-30 minutes",
                "Fiqh basics introduced",
                "Independent study support",
                "Real-world applications"
            ]
        case .adults:
            return [
                "Full scholarly content",
                "Detailed fiqh discussions",
                "Flexible session lengths",
                "Multiple scholarly opinions",
                "Self-directed learning",
                "Advanced tajweed"
            ]
        }
    }
}

// MARK: - Progress Tracking Models

struct LearningProgress: Codable {
    var salahMastery: Double = 0.0          // 0.0 to 1.0
    var quranMemorization: Double = 0.0     // 0.0 to 1.0
    var arabicLettersLearned: Int = 0       // out of 28
    var pillarsCompleted: Int = 0           // out of 5
    var starsEarned: Int = 0                // Total stars from activities
    var lastLessonId: String?
    var lastLessonTitle: String?
    var currentQuranSurah: Int = 1
    var currentQuranAyah: Int = 1
    var currentSalahStep: Int = 1
    var currentArabicLetter: Int = 0        // Index of current letter
}

struct DailyGoal: Codable {
    var quranSessionCompleted: Bool = false
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
    
    // Selected tab for navigation from Quick Actions
    @Published var selectedTab: Int = 0
    
    // Computed property for easy kids mode check
    var isKidsMode: Bool {
        userMode == .kids
    }
    
    // Theme color based on mode
    var themeColor: Color {
        isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "6B5B95")
    }
    
    // Toggle between kids and adult mode
    func toggleMode() {
        userMode = isKidsMode ? .adults : .kids
    }
    
    // Age-based content filtering
    @Published var userAge: Int = 10 {
        didSet {
            UserDefaults.standard.set(userAge, forKey: "userAge")
        }
    }
    
    var ageGroup: AgeGroup {
        switch userAge {
        case 0...6: return .earlyChildhood
        case 7...9: return .children
        case 10...12: return .tweens
        case 13...17: return .teens
        default: return .adults
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
        checkAndResetDailyGoals() // Reset daily goals if it's a new day
    }
    
    private func loadAllData() {
        // Load saved user mode
        if let savedMode = UserDefaults.standard.string(forKey: "userMode"),
           let mode = UserMode(rawValue: savedMode) {
            self.userMode = mode
        }
        
        // Load user age (default to 10 if not set)
        let savedAge = UserDefaults.standard.integer(forKey: "userAge")
        self.userAge = savedAge > 0 ? savedAge : 10
        
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
        
        // Load reminders setting (default to true if not set)
        if UserDefaults.standard.object(forKey: "remindersEnabled") != nil {
            self.remindersEnabled = UserDefaults.standard.bool(forKey: "remindersEnabled")
        } else {
            self.remindersEnabled = true // Default value
        }
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
    
    /// Updates streak when all daily goals are completed
    func updateStreakIfAllGoalsComplete() {
        // Check if all goals are complete
        if dailyGoal.quranSessionCompleted && 
           dailyGoal.salahPractice && 
           dailyGoal.arabicPractice {
            
            // Check if we haven't already updated today
            let calendar = Calendar.current
            let lastUpdate = dailyGoal.lastUpdated
            let today = Date()
            
            if !calendar.isDate(lastUpdate, inSameDayAs: today) {
                // Increment streak
                currentStreak += 1
                UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
                
                // Award bonus points for completing all goals
                totalPoints += 50
                UserDefaults.standard.set(totalPoints, forKey: "totalPoints")
                
                // Award stars
                totalStars += 3
                UserDefaults.standard.set(totalStars, forKey: "totalStars")
                
                // Update last updated date
                dailyGoal.lastUpdated = today
                
                // Check for streak badges
                checkBadges()
            }
        }
        
        // Save daily goal state
        saveProgress()
    }
    
    /// Resets daily goals at the start of a new day
    func checkAndResetDailyGoals() {
        let calendar = Calendar.current
        let lastUpdate = dailyGoal.lastUpdated
        let today = Date()
        
        // If it's a new day, reset the goals (but keep the streak if they were completed)
        if !calendar.isDate(lastUpdate, inSameDayAs: today) {
            // Check if yesterday's goals were not all completed - break streak
            if !(dailyGoal.quranSessionCompleted && dailyGoal.salahPractice && dailyGoal.arabicPractice) {
                // Only break streak if it's been more than a day
                if let daysDiff = calendar.dateComponents([.day], from: lastUpdate, to: today).day, daysDiff > 1 {
                    currentStreak = 0
                    UserDefaults.standard.set(0, forKey: "currentStreak")
                }
            }
            
            // Reset goals for new day
            dailyGoal.quranSessionCompleted = false
            dailyGoal.salahPractice = false
            dailyGoal.arabicPractice = false
            dailyGoal.lastUpdated = today
            
            saveProgress()
        }
    }
    
    func switchMode() {
        userMode = nil
        UserDefaults.standard.removeObject(forKey: "userMode")
    }
    
    // MARK: - Age-Appropriate Content Helpers
    
    /// Returns age-appropriate greeting for the current user
    var ageAppropriateGreeting: String {
        ageGroup.greeting
    }
    
    /// Returns the recommended font size for text based on age
    func fontSize(base: CGFloat) -> CGFloat {
        base * ageGroup.fontSizeMultiplier
    }
    
    /// Returns age-appropriate text for daily goals
    func dailyGoalText(for activity: String) -> String {
        ageGroup.dailyGoalText(for: activity)
    }
    
    /// Whether to show scholarly/detailed content
    var shouldShowScholarlyContent: Bool {
        ageGroup.showScholarlyContent
    }
    
    /// Returns the appropriate encouragement message
    var encouragementMessage: String {
        ageGroup.encouragementMessage
    }
    
    /// Recommended session length for this user's age
    var recommendedSessionMinutes: Int {
        ageGroup.recommendedSessionLength
    }
    
    /// Number of words to memorize per session based on age
    var memorizationChunkSize: Int {
        ageGroup.memorizationChunkSize
    }
    
    /// Simplifies text based on age group - returns appropriate version
    func ageAppropriateText(simple: String, standard: String, detailed: String) -> String {
        switch ageGroup {
        case .earlyChildhood, .children:
            return simple
        case .tweens:
            return standard
        case .teens, .adults:
            return detailed
        }
    }
    
    /// Returns content appropriate for the user's age
    func isContentAppropriate(minAge: Int) -> Bool {
        return userAge >= minAge
    }
    
    // MARK: - Journal Entries
    
    @Published var journalEntries: [JournalEntryData] = []
    
    func saveJournalEntry(_ entry: JournalEntryData) {
        journalEntries.append(entry)
        
        // Save to UserDefaults
        if let data = try? JSONEncoder().encode(journalEntries) {
            UserDefaults.standard.set(data, forKey: "journalEntries")
        }
    }
    
    func loadJournalEntries() {
        if let data = UserDefaults.standard.data(forKey: "journalEntries"),
           let entries = try? JSONDecoder().decode([JournalEntryData].self, from: data) {
            self.journalEntries = entries
        }
    }
}

// MARK: - Journal Entry Data Model

struct JournalEntryData: Identifiable, Codable {
    let id: String
    let pillarId: String
    let promptId: String?
    let content: String
    let date: Date
}
