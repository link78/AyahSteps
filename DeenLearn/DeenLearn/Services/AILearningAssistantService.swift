import Foundation

// MARK: - AI Learning Assistant Service
/// Provides personalized learning recommendations based on user progress
class AILearningAssistantService: ObservableObject {
    static let shared = AILearningAssistantService()
    
    @Published var dailyRecommendations: [LearningRecommendation] = []
    @Published var weakAreas: [WeakArea] = []
    @Published var streak: Int = 0
    
    private init() {
        generateInitialRecommendations()
    }
    
    // MARK: - Models
    struct LearningRecommendation: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let category: Category
        let priority: Priority
        let estimatedTime: Int // in minutes
        let icon: String
    }
    
    struct WeakArea: Identifiable {
        let id = UUID()
        let topic: String
        let category: Category
        let score: Int // 0-100
        let suggestion: String
    }
    
    enum Category: String, CaseIterable {
        case pillars = "Pillars"
        case salah = "Salah"
        case quran = "Qur'an"
        case arabic = "Arabic"
        case general = "General"
        
        var color: String {
            switch self {
            case .pillars: return "green"
            case .salah: return "blue"
            case .quran: return "purple"
            case .arabic: return "orange"
            case .general: return "gray"
            }
        }
    }
    
    enum Priority: String {
        case high = "High"
        case medium = "Medium"
        case low = "Low"
    }
    
    // MARK: - Progress Data
    struct UserProgress {
        var pillarsProgress: Int = 0
        var salahProgress: Int = 0
        var quranProgress: Int = 0
        var arabicProgress: Int = 0
        var lastActiveDate: Date = Date()
        var totalMinutesLearned: Int = 0
        var completedLessons: Int = 0
    }
    
    // MARK: - Generate Recommendations
    func generateRecommendations(for progress: UserProgress, isKidsMode: Bool) -> [LearningRecommendation] {
        var recommendations: [LearningRecommendation] = []
        
        // Analyze weak areas and generate targeted recommendations
        if progress.pillarsProgress < 50 {
            recommendations.append(LearningRecommendation(
                title: isKidsMode ? "🏝️ Explore Shahada Island!" : "Review: Five Pillars of Islam",
                description: isKidsMode 
                    ? "Join Captain Iman on an adventure to learn about the Shahada!"
                    : "Strengthen your understanding of the foundational pillars",
                category: .pillars,
                priority: .high,
                estimatedTime: 10,
                icon: "star.fill"
            ))
        }
        
        if progress.salahProgress < 60 {
            recommendations.append(LearningRecommendation(
                title: isKidsMode ? "🕌 Prayer Time with Mayor Salim!" : "Salah Improvement",
                description: isKidsMode 
                    ? "Learn the fun prayer moves and sounds!"
                    : "Review prayer positions and recitations",
                category: .salah,
                priority: .high,
                estimatedTime: 15,
                icon: "hands.sparkles.fill"
            ))
        }
        
        if progress.quranProgress < 40 {
            recommendations.append(LearningRecommendation(
                title: isKidsMode ? "📖 Story Time: Surah Al-Fatihah!" : "Qur'an Memorization",
                description: isKidsMode 
                    ? "Listen to the beautiful opening chapter!"
                    : "Continue memorizing Juz Amma with tajweed",
                category: .quran,
                priority: .medium,
                estimatedTime: 20,
                icon: "book.fill"
            ))
        }
        
        if progress.arabicProgress < 30 {
            recommendations.append(LearningRecommendation(
                title: isKidsMode ? "🔤 Letter Adventure!" : "Arabic Letters Practice",
                description: isKidsMode 
                    ? "Meet the Arabic letters and learn their sounds!"
                    : "Review letter forms and pronunciation",
                category: .arabic,
                priority: .medium,
                estimatedTime: 10,
                icon: "textformat.abc"
            ))
        }
        
        // Add daily review recommendation
        recommendations.append(LearningRecommendation(
            title: isKidsMode ? "⭐ Daily Star Challenge!" : "Daily Review",
            description: isKidsMode 
                ? "Answer fun questions to earn your daily stars!"
                : "Quick review of yesterday's content",
            category: .general,
            priority: .low,
            estimatedTime: 5,
            icon: "sparkles"
        ))
        
        return recommendations.sorted { $0.priority == .high && $1.priority != .high }
    }
    
    // MARK: - Analyze Weak Areas
    func analyzeWeakAreas(progress: UserProgress) -> [WeakArea] {
        var areas: [WeakArea] = []
        
        if progress.pillarsProgress < 50 {
            areas.append(WeakArea(
                topic: "Pillars of Islam",
                category: .pillars,
                score: progress.pillarsProgress,
                suggestion: "Focus on understanding each pillar through stories and interactive activities"
            ))
        }
        
        if progress.salahProgress < 50 {
            areas.append(WeakArea(
                topic: "Prayer Movements",
                category: .salah,
                score: progress.salahProgress,
                suggestion: "Practice the physical movements with the step-by-step guide"
            ))
        }
        
        if progress.quranProgress < 40 {
            areas.append(WeakArea(
                topic: "Qur'an Recitation",
                category: .quran,
                score: progress.quranProgress,
                suggestion: "Listen more frequently and practice with the AI Quran Coach"
            ))
        }
        
        if progress.arabicProgress < 30 {
            areas.append(WeakArea(
                topic: "Arabic Alphabet",
                category: .arabic,
                score: progress.arabicProgress,
                suggestion: "Spend 10 minutes daily on letter recognition games"
            ))
        }
        
        return areas.sorted { $0.score < $1.score }
    }
    
    // MARK: - Get Motivational Message
    func getMotivationalMessage(streak: Int, isKidsMode: Bool) -> String {
        if isKidsMode {
            switch streak {
            case 0:
                return "🌟 Welcome back! Let's start a new learning adventure today!"
            case 1...3:
                return "🔥 \(streak) day streak! You're doing great! Keep it up!"
            case 4...7:
                return "⭐ Wow! \(streak) days in a row! You're a superstar learner!"
            case 8...14:
                return "🏆 Amazing! \(streak) day streak! You're becoming a champion!"
            case 15...30:
                return "🎉 \(streak) days! MashaAllah! You're unstoppable!"
            default:
                return "👑 \(streak) day streak! You're a true Islamic knowledge master!"
            }
        } else {
            switch streak {
            case 0:
                return "Welcome back. Consistency is key to learning. Let's begin today's session."
            case 1...3:
                return "\(streak)-day streak. Good start. The Prophet ﷺ said: 'The most beloved deeds to Allah are those done consistently.'"
            case 4...7:
                return "\(streak) consecutive days of learning. Excellent commitment to seeking knowledge."
            case 8...14:
                return "Impressive \(streak)-day streak. 'Whoever treads a path seeking knowledge, Allah will make easy for him the path to Paradise.'"
            case 15...30:
                return "\(streak) days! Your dedication to Islamic knowledge is admirable. May Allah bless your efforts."
            default:
                return "MashaAllah! \(streak)-day streak. You exemplify the pursuit of knowledge in Islam."
            }
        }
    }
    
    // MARK: - Generate Initial Recommendations
    private func generateInitialRecommendations() {
        let defaultProgress = UserProgress(
            pillarsProgress: 30,
            salahProgress: 40,
            quranProgress: 25,
            arabicProgress: 20
        )
        dailyRecommendations = generateRecommendations(for: defaultProgress, isKidsMode: true)
        weakAreas = analyzeWeakAreas(progress: defaultProgress)
    }
    
    // MARK: - Get Study Plan
    func generateStudyPlan(totalMinutes: Int, isKidsMode: Bool) -> [String] {
        if isKidsMode {
            if totalMinutes <= 15 {
                return [
                    "🌟 5 min: Watch a story video",
                    "🎮 5 min: Play a matching game",
                    "⭐ 5 min: Earn your daily stars!"
                ]
            } else if totalMinutes <= 30 {
                return [
                    "🏝️ 10 min: Explore a Pillar World",
                    "📖 10 min: Listen to Qur'an",
                    "🔤 5 min: Letter practice",
                    "⭐ 5 min: Quiz time!"
                ]
            } else {
                return [
                    "🏝️ 15 min: Complete a world adventure",
                    "🕌 10 min: Prayer practice",
                    "📖 10 min: Qur'an listening",
                    "🔤 10 min: Arabic games",
                    "⭐ 5 min: Review and stars!"
                ]
            }
        } else {
            if totalMinutes <= 15 {
                return [
                    "5 min: Review yesterday's content",
                    "10 min: Focus on weakest area"
                ]
            } else if totalMinutes <= 30 {
                return [
                    "10 min: Qur'an recitation with tajweed",
                    "10 min: Study lesson content",
                    "10 min: Practice quiz"
                ]
            } else {
                return [
                    "15 min: Qur'an memorization/review",
                    "15 min: Deep study of current topic",
                    "10 min: Arabic vocabulary",
                    "10 min: Assessment and review"
                ]
            }
        }
    }
}
