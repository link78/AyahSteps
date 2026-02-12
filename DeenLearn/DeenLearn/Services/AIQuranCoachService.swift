import Foundation
import AVFoundation

// MARK: - AI Quran Coach Service
/// Provides AI-powered Quran recitation analysis and feedback
class AIQuranCoachService: ObservableObject {
    static let shared = AIQuranCoachService()
    
    @Published var isAnalyzing = false
    @Published var lastFeedback: RecitationFeedback?
    
    private init() {}
    
    // MARK: - Recitation Feedback Model
    struct RecitationFeedback: Identifiable {
        let id = UUID()
        let overallScore: Int // 0-100
        let pronunciationScore: Int
        let tajweedScore: Int
        let fluencyScore: Int
        let feedback: [FeedbackItem]
        let encouragement: String
        let practiceRecommendations: [String]
    }
    
    struct FeedbackItem: Identifiable {
        let id = UUID()
        let type: FeedbackType
        let word: String
        let issue: String
        let correction: String
    }
    
    enum FeedbackType: String {
        case tajweed = "Tajweed"
        case pronunciation = "Pronunciation"
        case timing = "Timing"
        case melody = "Melody"
    }
    
    // MARK: - Tajweed Rules
    enum TajweedRule: String, CaseIterable {
        case ghunnah = "Ghunnah"
        case ikhfa = "Ikhfa"
        case idgham = "Idgham"
        case iqlab = "Iqlab"
        case izhar = "Izhar"
        case qalqalah = "Qalqalah"
        case madd = "Madd"
        
        var description: String {
            switch self {
            case .ghunnah: return "Nasal sound held for 2 counts"
            case .ikhfa: return "Hiding the noon sound"
            case .idgham: return "Merging two letters"
            case .iqlab: return "Changing noon to meem"
            case .izhar: return "Clear pronunciation"
            case .qalqalah: return "Echo sound on specific letters"
            case .madd: return "Elongation of vowel sounds"
            }
        }
        
        var letters: String {
            switch self {
            case .ghunnah: return "ن، م"
            case .ikhfa: return "ت، ث، ج، د، ذ، ز، س، ش، ص، ض، ط، ظ، ف، ق، ك"
            case .idgham: return "ي، ر، م، ل، و، ن"
            case .iqlab: return "ب"
            case .izhar: return "ء، ه، ع، ح، غ، خ"
            case .qalqalah: return "ق، ط، ب، ج، د"
            case .madd: return "ا، و، ي"
            }
        }
    }
    
    // MARK: - Analyze Recitation
    func analyzeRecitation(surah: String, ayah: Int, isKidsMode: Bool) async -> RecitationFeedback {
        await MainActor.run {
            isAnalyzing = true
        }
        
        // Simulate AI analysis delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let feedback = generateFeedback(surah: surah, ayah: ayah, isKidsMode: isKidsMode)
        
        await MainActor.run {
            lastFeedback = feedback
            isAnalyzing = false
        }
        
        return feedback
    }
    
    // MARK: - Generate Feedback
    private func generateFeedback(surah: String, ayah: Int, isKidsMode: Bool) -> RecitationFeedback {
        // Simulate varying scores
        let pronunciationScore = Int.random(in: 70...95)
        let tajweedScore = Int.random(in: 65...90)
        let fluencyScore = Int.random(in: 75...95)
        let overallScore = (pronunciationScore + tajweedScore + fluencyScore) / 3
        
        var feedbackItems: [FeedbackItem] = []
        var encouragement: String
        var recommendations: [String] = []
        
        if isKidsMode {
            // Kids Mode feedback
            if tajweedScore < 80 {
                feedbackItems.append(FeedbackItem(
                    type: .tajweed,
                    word: "بِسْمِ",
                    issue: "Hold the 'meem' sound a little longer 🎵",
                    correction: "Try saying 'Bismiii' with a longer 'i' sound!"
                ))
            }
            
            if pronunciationScore < 85 {
                feedbackItems.append(FeedbackItem(
                    type: .pronunciation,
                    word: "الرَّحْمَٰنِ",
                    issue: "The 'ر' (ra) sound needs more strength 💪",
                    correction: "Roll your tongue for the 'R' sound - Ar-Rahman!"
                ))
            }
            
            encouragement = overallScore >= 80 
                ? "🌟 MashaAllah! You did amazing! Keep practicing and you'll be even better! 🎉"
                : "💪 Great effort! Practice makes perfect! You're getting better every day! ⭐"
            
            recommendations = [
                "🎧 Listen to the surah 3 times before bed",
                "🗣️ Practice saying each word slowly",
                "🔄 Try the 'repeat after me' game",
                "⭐ Collect stars by practicing every day!"
            ]
        } else {
            // Adult Mode feedback
            if tajweedScore < 80 {
                feedbackItems.append(FeedbackItem(
                    type: .tajweed,
                    word: "بِسْمِ",
                    issue: "Ghunnah duration insufficient on the meem",
                    correction: "Hold the nasal sound (ghunnah) for 2 counts (harakatayn)"
                ))
                
                feedbackItems.append(FeedbackItem(
                    type: .tajweed,
                    word: "مِنَ",
                    issue: "Ikhfa not properly applied before noon sakinah",
                    correction: "Hide the noon sound with a nasal quality before certain letters"
                ))
            }
            
            if pronunciationScore < 85 {
                feedbackItems.append(FeedbackItem(
                    type: .pronunciation,
                    word: "الرَّحْمَٰنِ",
                    issue: "Ra (ر) articulation point needs attention",
                    correction: "Ensure the tongue tip touches the gum ridge with appropriate tafkheem"
                ))
            }
            
            if fluencyScore < 80 {
                feedbackItems.append(FeedbackItem(
                    type: .timing,
                    word: "General",
                    issue: "Pacing inconsistent between verses",
                    correction: "Maintain steady rhythm; pause at proper waqf marks"
                ))
            }
            
            encouragement = overallScore >= 80 
                ? "Excellent recitation! Your tajweed application shows good understanding. Continue refining the finer points."
                : "Good effort. Focus on the specific tajweed rules mentioned above. Consistent practice with a qualified teacher is recommended."
            
            recommendations = [
                "Review tajweed rules for ghunnah and ikhfa",
                "Practice with audio of a renowned reciter (e.g., Mishary Rashid)",
                "Record yourself and compare with the original",
                "Focus on makhaarij (articulation points) exercises",
                "Consider studying with a certified Qur'an teacher"
            ]
        }
        
        return RecitationFeedback(
            overallScore: overallScore,
            pronunciationScore: pronunciationScore,
            tajweedScore: tajweedScore,
            fluencyScore: fluencyScore,
            feedback: feedbackItems,
            encouragement: encouragement,
            practiceRecommendations: recommendations
        )
    }
    
    // MARK: - Get Tajweed Rule Explanation
    func explainTajweedRule(_ rule: TajweedRule, isKidsMode: Bool) -> String {
        if isKidsMode {
            switch rule {
            case .ghunnah:
                return "🎵 Ghunnah is a humming sound! When you see certain letters, make a sound through your nose like 'mmm' or 'nnn'. Hold it for 2 seconds!"
            case .ikhfa:
                return "🤫 Ikhfa means 'hiding'! We hide the 'n' sound by making it softer and mixing it with the next letter. It's like whispering!"
            case .idgham:
                return "🤝 Idgham means 'merging'! Two letters become friends and join together to make one sound!"
            case .iqlab:
                return "🔄 Iqlab means 'changing'! The 'n' sound changes to an 'm' sound before the letter 'ba'. It's like magic!"
            case .izhar:
                return "📢 Izhar means 'clear'! We say the 'n' sound clearly and strongly before certain letters!"
            case .qalqalah:
                return "🔔 Qalqalah is an echo sound! Some letters bounce like a ball when they stop - ق ط ب ج د!"
            case .madd:
                return "➡️ Madd means 'stretching'! We stretch certain sounds longer, like singing a note! It can be 2, 4, or 6 counts!"
            }
        } else {
            return """
            \(rule.rawValue) (تجويد)
            
            Definition: \(rule.description)
            
            Applicable Letters: \(rule.letters)
            
            This rule is essential for proper Qur'anic recitation and helps preserve the original pronunciation as taught by Prophet Muhammad ﷺ.
            """
        }
    }
}
