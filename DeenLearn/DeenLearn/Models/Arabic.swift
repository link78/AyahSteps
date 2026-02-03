//
//  Arabic.swift
//  DeenLearn
//
//  Arabic language learning data models
//

import Foundation
import SwiftUI

// MARK: - Arabic Letter Model

struct ArabicLetter: Identifiable {
    let id = UUID()
    let name: String
    let transliteration: String
    let isolated: String
    let initial: String
    let medial: String
    let final: String
    let pronunciation: String
    let exampleWord: String
    let exampleTranslation: String
    let exampleIcon: String
    var isLearned: Bool = false
    
    // Sample Arabic Alphabet (all 28 letters)
    static let alphabet: [ArabicLetter] = [
        ArabicLetter(name: "Alif", transliteration: "a", isolated: "ا", initial: "ا", medial: "ـا", final: "ـا", pronunciation: "Like 'a' in 'father'", exampleWord: "أَسَد", exampleTranslation: "Lion", exampleIcon: "🦁"),
        ArabicLetter(name: "Ba", transliteration: "b", isolated: "ب", initial: "بـ", medial: "ـبـ", final: "ـب", pronunciation: "Like 'b' in 'book'", exampleWord: "بَيْت", exampleTranslation: "House", exampleIcon: "🏠"),
        ArabicLetter(name: "Ta", transliteration: "t", isolated: "ت", initial: "تـ", medial: "ـتـ", final: "ـت", pronunciation: "Like 't' in 'table'", exampleWord: "تُفَّاحَة", exampleTranslation: "Apple", exampleIcon: "🍎"),
        ArabicLetter(name: "Tha", transliteration: "th", isolated: "ث", initial: "ثـ", medial: "ـثـ", final: "ـث", pronunciation: "Like 'th' in 'think'", exampleWord: "ثَعْلَب", exampleTranslation: "Fox", exampleIcon: "🦊"),
        ArabicLetter(name: "Jim", transliteration: "j", isolated: "ج", initial: "جـ", medial: "ـجـ", final: "ـج", pronunciation: "Like 'j' in 'jump'", exampleWord: "جَمَل", exampleTranslation: "Camel", exampleIcon: "🐪"),
        ArabicLetter(name: "Ha", transliteration: "ḥ", isolated: "ح", initial: "حـ", medial: "ـحـ", final: "ـح", pronunciation: "Breathy 'h' from throat", exampleWord: "حُوت", exampleTranslation: "Whale", exampleIcon: "🐋"),
        ArabicLetter(name: "Kha", transliteration: "kh", isolated: "خ", initial: "خـ", medial: "ـخـ", final: "ـخ", pronunciation: "Like 'ch' in Scottish 'loch'", exampleWord: "خُبْز", exampleTranslation: "Bread", exampleIcon: "🍞"),
        ArabicLetter(name: "Dal", transliteration: "d", isolated: "د", initial: "د", medial: "ـد", final: "ـد", pronunciation: "Like 'd' in 'door'", exampleWord: "دُب", exampleTranslation: "Bear", exampleIcon: "🐻"),
        ArabicLetter(name: "Dhal", transliteration: "dh", isolated: "ذ", initial: "ذ", medial: "ـذ", final: "ـذ", pronunciation: "Like 'th' in 'this'", exampleWord: "ذُبَابَة", exampleTranslation: "Fly", exampleIcon: "🪰"),
        ArabicLetter(name: "Ra", transliteration: "r", isolated: "ر", initial: "ر", medial: "ـر", final: "ـر", pronunciation: "Rolled 'r'", exampleWord: "رُمَّان", exampleTranslation: "Pomegranate", exampleIcon: "🍎"),
        ArabicLetter(name: "Zay", transliteration: "z", isolated: "ز", initial: "ز", medial: "ـز", final: "ـز", pronunciation: "Like 'z' in 'zoo'", exampleWord: "زَرَافَة", exampleTranslation: "Giraffe", exampleIcon: "🦒"),
        ArabicLetter(name: "Sin", transliteration: "s", isolated: "س", initial: "سـ", medial: "ـسـ", final: "ـس", pronunciation: "Like 's' in 'sun'", exampleWord: "سَمَكَة", exampleTranslation: "Fish", exampleIcon: "🐟"),
        ArabicLetter(name: "Shin", transliteration: "sh", isolated: "ش", initial: "شـ", medial: "ـشـ", final: "ـش", pronunciation: "Like 'sh' in 'ship'", exampleWord: "شَمْس", exampleTranslation: "Sun", exampleIcon: "☀️"),
        ArabicLetter(name: "Sad", transliteration: "ṣ", isolated: "ص", initial: "صـ", medial: "ـصـ", final: "ـص", pronunciation: "Emphatic 's'", exampleWord: "صَقْر", exampleTranslation: "Falcon", exampleIcon: "🦅"),
        ArabicLetter(name: "Dad", transliteration: "ḍ", isolated: "ض", initial: "ضـ", medial: "ـضـ", final: "ـض", pronunciation: "Emphatic 'd'", exampleWord: "ضِفْدَع", exampleTranslation: "Frog", exampleIcon: "🐸"),
        ArabicLetter(name: "Ta (emphatic)", transliteration: "ṭ", isolated: "ط", initial: "طـ", medial: "ـطـ", final: "ـط", pronunciation: "Emphatic 't'", exampleWord: "طَائِر", exampleTranslation: "Bird", exampleIcon: "🐦"),
        ArabicLetter(name: "Dha (emphatic)", transliteration: "ẓ", isolated: "ظ", initial: "ظـ", medial: "ـظـ", final: "ـظ", pronunciation: "Emphatic 'dh'", exampleWord: "ظَبْي", exampleTranslation: "Gazelle", exampleIcon: "🦌"),
        ArabicLetter(name: "Ayn", transliteration: "'", isolated: "ع", initial: "عـ", medial: "ـعـ", final: "ـع", pronunciation: "Deep throat sound", exampleWord: "عَيْن", exampleTranslation: "Eye", exampleIcon: "👁️"),
        ArabicLetter(name: "Ghayn", transliteration: "gh", isolated: "غ", initial: "غـ", medial: "ـغـ", final: "ـغ", pronunciation: "Like French 'r'", exampleWord: "غُرَاب", exampleTranslation: "Crow", exampleIcon: "🐦‍⬛"),
        ArabicLetter(name: "Fa", transliteration: "f", isolated: "ف", initial: "فـ", medial: "ـفـ", final: "ـف", pronunciation: "Like 'f' in 'fish'", exampleWord: "فِيل", exampleTranslation: "Elephant", exampleIcon: "🐘"),
        ArabicLetter(name: "Qaf", transliteration: "q", isolated: "ق", initial: "قـ", medial: "ـقـ", final: "ـق", pronunciation: "Deep 'k' from throat", exampleWord: "قَمَر", exampleTranslation: "Moon", exampleIcon: "🌙"),
        ArabicLetter(name: "Kaf", transliteration: "k", isolated: "ك", initial: "كـ", medial: "ـكـ", final: "ـك", pronunciation: "Like 'k' in 'king'", exampleWord: "كَلْب", exampleTranslation: "Dog", exampleIcon: "🐕"),
        ArabicLetter(name: "Lam", transliteration: "l", isolated: "ل", initial: "لـ", medial: "ـلـ", final: "ـل", pronunciation: "Like 'l' in 'lamp'", exampleWord: "لَيْمُون", exampleTranslation: "Lemon", exampleIcon: "🍋"),
        ArabicLetter(name: "Mim", transliteration: "m", isolated: "م", initial: "مـ", medial: "ـمـ", final: "ـم", pronunciation: "Like 'm' in 'moon'", exampleWord: "مَسْجِد", exampleTranslation: "Mosque", exampleIcon: "🕌"),
        ArabicLetter(name: "Nun", transliteration: "n", isolated: "ن", initial: "نـ", medial: "ـنـ", final: "ـن", pronunciation: "Like 'n' in 'noon'", exampleWord: "نَجْمَة", exampleTranslation: "Star", exampleIcon: "⭐"),
        ArabicLetter(name: "Ha", transliteration: "h", isolated: "ه", initial: "هـ", medial: "ـهـ", final: "ـه", pronunciation: "Like 'h' in 'house'", exampleWord: "هِلَال", exampleTranslation: "Crescent", exampleIcon: "🌙"),
        ArabicLetter(name: "Waw", transliteration: "w/ū", isolated: "و", initial: "و", medial: "ـو", final: "ـو", pronunciation: "Like 'w' in 'water' or 'oo' in 'moon'", exampleWord: "وَرْدَة", exampleTranslation: "Rose", exampleIcon: "🌹"),
        ArabicLetter(name: "Ya", transliteration: "y/ī", isolated: "ي", initial: "يـ", medial: "ـيـ", final: "ـي", pronunciation: "Like 'y' in 'yes' or 'ee' in 'see'", exampleWord: "يَد", exampleTranslation: "Hand", exampleIcon: "✋")
    ]
}

// MARK: - Vocabulary Word Model

struct VocabularyWord: Identifiable {
    let id = UUID()
    let arabic: String
    let transliteration: String
    let english: String
    let icon: String
    let category: VocabularyCategory
    var isLearned: Bool = false
}

enum VocabularyCategory: String, CaseIterable {
    case salahWords = "Salah Words"
    case masjidObjects = "Masjid Objects"
    case family = "Family"
    case animals = "Animals"
    case feelings = "Feelings"
    case nature = "Nature"
    
    var icon: String {
        switch self {
        case .salahWords: return "🕌"
        case .masjidObjects: return "📿"
        case .family: return "👨‍👩‍👧‍👦"
        case .animals: return "🐪"
        case .feelings: return "😊"
        case .nature: return "🌿"
        }
    }
    
    var color: Color {
        switch self {
        case .salahWords: return .green
        case .masjidObjects: return .purple
        case .family: return .orange
        case .animals: return .brown
        case .feelings: return .pink
        case .nature: return .teal
        }
    }
}

// Sample Vocabulary Data
extension VocabularyWord {
    static let salahWords: [VocabularyWord] = [
        VocabularyWord(arabic: "صَلَاة", transliteration: "Salah", english: "Prayer", icon: "🤲", category: .salahWords),
        VocabularyWord(arabic: "وُضُوء", transliteration: "Wudu", english: "Ablution", icon: "💧", category: .salahWords),
        VocabularyWord(arabic: "رُكُوع", transliteration: "Ruku'", english: "Bowing", icon: "🙇", category: .salahWords),
        VocabularyWord(arabic: "سُجُود", transliteration: "Sujud", english: "Prostration", icon: "🧎", category: .salahWords),
        VocabularyWord(arabic: "قِيَام", transliteration: "Qiyam", english: "Standing", icon: "🧍", category: .salahWords),
        VocabularyWord(arabic: "تَشَهُّد", transliteration: "Tashahhud", english: "Testimony", icon: "☝️", category: .salahWords),
        VocabularyWord(arabic: "سَلَام", transliteration: "Salam", english: "Peace greeting", icon: "👋", category: .salahWords)
    ]
    
    static let masjidObjects: [VocabularyWord] = [
        VocabularyWord(arabic: "مَسْجِد", transliteration: "Masjid", english: "Mosque", icon: "🕌", category: .masjidObjects),
        VocabularyWord(arabic: "مِحْرَاب", transliteration: "Mihrab", english: "Prayer niche", icon: "🚪", category: .masjidObjects),
        VocabularyWord(arabic: "مِنْبَر", transliteration: "Minbar", english: "Pulpit", icon: "🎤", category: .masjidObjects),
        VocabularyWord(arabic: "سَجَّادَة", transliteration: "Sajjadah", english: "Prayer mat", icon: "🧶", category: .masjidObjects),
        VocabularyWord(arabic: "مُصْحَف", transliteration: "Mushaf", english: "Quran copy", icon: "📖", category: .masjidObjects),
        VocabularyWord(arabic: "سُبْحَة", transliteration: "Subha", english: "Prayer beads", icon: "📿", category: .masjidObjects)
    ]
    
    static let familyWords: [VocabularyWord] = [
        VocabularyWord(arabic: "أَب", transliteration: "Ab", english: "Father", icon: "👨", category: .family),
        VocabularyWord(arabic: "أُم", transliteration: "Umm", english: "Mother", icon: "👩", category: .family),
        VocabularyWord(arabic: "أَخ", transliteration: "Akh", english: "Brother", icon: "👦", category: .family),
        VocabularyWord(arabic: "أُخْت", transliteration: "Ukht", english: "Sister", icon: "👧", category: .family),
        VocabularyWord(arabic: "جَد", transliteration: "Jadd", english: "Grandfather", icon: "👴", category: .family),
        VocabularyWord(arabic: "جَدَّة", transliteration: "Jaddah", english: "Grandmother", icon: "👵", category: .family),
        VocabularyWord(arabic: "عَائِلَة", transliteration: "'A'ilah", english: "Family", icon: "👨‍👩‍👧‍👦", category: .family)
    ]
    
    static let animalWords: [VocabularyWord] = [
        VocabularyWord(arabic: "جَمَل", transliteration: "Jamal", english: "Camel", icon: "🐪", category: .animals),
        VocabularyWord(arabic: "أَسَد", transliteration: "Asad", english: "Lion", icon: "🦁", category: .animals),
        VocabularyWord(arabic: "قِط", transliteration: "Qitt", english: "Cat", icon: "🐱", category: .animals),
        VocabularyWord(arabic: "كَلْب", transliteration: "Kalb", english: "Dog", icon: "🐕", category: .animals),
        VocabularyWord(arabic: "حِصَان", transliteration: "Hisan", english: "Horse", icon: "🐴", category: .animals),
        VocabularyWord(arabic: "طَائِر", transliteration: "Ta'ir", english: "Bird", icon: "🐦", category: .animals)
    ]
    
    static let feelingWords: [VocabularyWord] = [
        VocabularyWord(arabic: "سَعِيد", transliteration: "Sa'id", english: "Happy", icon: "😊", category: .feelings),
        VocabularyWord(arabic: "حَزِين", transliteration: "Hazin", english: "Sad", icon: "😢", category: .feelings),
        VocabularyWord(arabic: "شُكْر", transliteration: "Shukr", english: "Grateful", icon: "🙏", category: .feelings),
        VocabularyWord(arabic: "حُب", transliteration: "Hubb", english: "Love", icon: "❤️", category: .feelings),
        VocabularyWord(arabic: "صَبْر", transliteration: "Sabr", english: "Patience", icon: "🧘", category: .feelings)
    ]
    
    static let natureWords: [VocabularyWord] = [
        VocabularyWord(arabic: "شَمْس", transliteration: "Shams", english: "Sun", icon: "☀️", category: .nature),
        VocabularyWord(arabic: "قَمَر", transliteration: "Qamar", english: "Moon", icon: "🌙", category: .nature),
        VocabularyWord(arabic: "نَجْمَة", transliteration: "Najmah", english: "Star", icon: "⭐", category: .nature),
        VocabularyWord(arabic: "مَاء", transliteration: "Ma'", english: "Water", icon: "💧", category: .nature),
        VocabularyWord(arabic: "شَجَرَة", transliteration: "Shajarah", english: "Tree", icon: "🌳", category: .nature),
        VocabularyWord(arabic: "زَهْرَة", transliteration: "Zahrah", english: "Flower", icon: "🌸", category: .nature)
    ]
    
    static func words(for category: VocabularyCategory) -> [VocabularyWord] {
        switch category {
        case .salahWords: return salahWords
        case .masjidObjects: return masjidObjects
        case .family: return familyWords
        case .animals: return animalWords
        case .feelings: return feelingWords
        case .nature: return natureWords
        }
    }
}

// MARK: - Concept Map Model

struct ConceptMap: Identifiable {
    let id = UUID()
    let title: String
    let arabicTitle: String
    let icon: String
    let color: Color
    let nodes: [ConceptNode]
    let connections: [ConceptConnection]
}

struct ConceptNode: Identifiable {
    let id = UUID()
    let title: String
    let arabic: String
    let icon: String
    let description: String
    let position: CGPoint // Relative position (0-1)
}

struct ConceptConnection: Identifiable {
    let id = UUID()
    let fromNodeIndex: Int
    let toNodeIndex: Int
    let label: String
}

// Sample Concept Maps
extension ConceptMap {
    static let salahMap = ConceptMap(
        title: "Salah",
        arabicTitle: "صَلَاة",
        icon: "🕌",
        color: .green,
        nodes: [
            ConceptNode(title: "Intention", arabic: "نِيَّة", icon: "💭", description: "Make sincere intention", position: CGPoint(x: 0.5, y: 0.1)),
            ConceptNode(title: "Takbir", arabic: "تَكْبِير", icon: "🙌", description: "Raise hands, say Allahu Akbar", position: CGPoint(x: 0.5, y: 0.25)),
            ConceptNode(title: "Qiyam", arabic: "قِيَام", icon: "🧍", description: "Standing position", position: CGPoint(x: 0.5, y: 0.4)),
            ConceptNode(title: "Ruku", arabic: "رُكُوع", icon: "🙇", description: "Bowing position", position: CGPoint(x: 0.3, y: 0.55)),
            ConceptNode(title: "Sujud", arabic: "سُجُود", icon: "🧎", description: "Prostration", position: CGPoint(x: 0.7, y: 0.55)),
            ConceptNode(title: "Tashahhud", arabic: "تَشَهُّد", icon: "☝️", description: "Sitting testimony", position: CGPoint(x: 0.5, y: 0.7)),
            ConceptNode(title: "Salam", arabic: "سَلَام", icon: "👋", description: "Peace greeting to end", position: CGPoint(x: 0.5, y: 0.85))
        ],
        connections: [
            ConceptConnection(fromNodeIndex: 0, toNodeIndex: 1, label: "begin"),
            ConceptConnection(fromNodeIndex: 1, toNodeIndex: 2, label: "stand"),
            ConceptConnection(fromNodeIndex: 2, toNodeIndex: 3, label: "bow"),
            ConceptConnection(fromNodeIndex: 3, toNodeIndex: 4, label: "prostrate"),
            ConceptConnection(fromNodeIndex: 4, toNodeIndex: 5, label: "sit"),
            ConceptConnection(fromNodeIndex: 5, toNodeIndex: 6, label: "finish")
        ]
    )
    
    static let wuduMap = ConceptMap(
        title: "Wudu",
        arabicTitle: "وُضُوء",
        icon: "💧",
        color: .blue,
        nodes: [
            ConceptNode(title: "Intention", arabic: "نِيَّة", icon: "💭", description: "Intend to purify", position: CGPoint(x: 0.5, y: 0.1)),
            ConceptNode(title: "Hands", arabic: "يَدَيْن", icon: "🤲", description: "Wash hands 3x", position: CGPoint(x: 0.3, y: 0.25)),
            ConceptNode(title: "Mouth", arabic: "فَم", icon: "👄", description: "Rinse mouth 3x", position: CGPoint(x: 0.7, y: 0.25)),
            ConceptNode(title: "Nose", arabic: "أَنْف", icon: "👃", description: "Clean nose 3x", position: CGPoint(x: 0.3, y: 0.4)),
            ConceptNode(title: "Face", arabic: "وَجْه", icon: "😊", description: "Wash face 3x", position: CGPoint(x: 0.7, y: 0.4)),
            ConceptNode(title: "Arms", arabic: "ذِرَاع", icon: "💪", description: "Wash arms to elbows", position: CGPoint(x: 0.3, y: 0.55)),
            ConceptNode(title: "Head", arabic: "رَأْس", icon: "🧑", description: "Wipe head once", position: CGPoint(x: 0.7, y: 0.55)),
            ConceptNode(title: "Ears", arabic: "أُذُن", icon: "👂", description: "Wipe ears", position: CGPoint(x: 0.3, y: 0.7)),
            ConceptNode(title: "Feet", arabic: "قَدَم", icon: "🦶", description: "Wash feet to ankles", position: CGPoint(x: 0.7, y: 0.7)),
            ConceptNode(title: "Dua", arabic: "دُعَاء", icon: "🤲", description: "Supplication after", position: CGPoint(x: 0.5, y: 0.85))
        ],
        connections: [
            ConceptConnection(fromNodeIndex: 0, toNodeIndex: 1, label: "start"),
            ConceptConnection(fromNodeIndex: 1, toNodeIndex: 2, label: "then"),
            ConceptConnection(fromNodeIndex: 2, toNodeIndex: 3, label: "then"),
            ConceptConnection(fromNodeIndex: 3, toNodeIndex: 4, label: "then"),
            ConceptConnection(fromNodeIndex: 4, toNodeIndex: 5, label: "then"),
            ConceptConnection(fromNodeIndex: 5, toNodeIndex: 6, label: "then"),
            ConceptConnection(fromNodeIndex: 6, toNodeIndex: 7, label: "then"),
            ConceptConnection(fromNodeIndex: 7, toNodeIndex: 8, label: "then"),
            ConceptConnection(fromNodeIndex: 8, toNodeIndex: 9, label: "finish")
        ]
    )
    
    static let ramadanMap = ConceptMap(
        title: "Ramadan",
        arabicTitle: "رَمَضَان",
        icon: "🌙",
        color: .purple,
        nodes: [
            ConceptNode(title: "Suhoor", arabic: "سَحُور", icon: "🌅", description: "Pre-dawn meal", position: CGPoint(x: 0.2, y: 0.2)),
            ConceptNode(title: "Fajr", arabic: "فَجْر", icon: "🌄", description: "Dawn prayer, fasting begins", position: CGPoint(x: 0.5, y: 0.15)),
            ConceptNode(title: "Fasting", arabic: "صِيَام", icon: "🚫🍽️", description: "No food/drink", position: CGPoint(x: 0.5, y: 0.35)),
            ConceptNode(title: "Quran", arabic: "قُرْآن", icon: "📖", description: "Read Quran", position: CGPoint(x: 0.2, y: 0.45)),
            ConceptNode(title: "Dhikr", arabic: "ذِكْر", icon: "📿", description: "Remembrance", position: CGPoint(x: 0.8, y: 0.45)),
            ConceptNode(title: "Iftar", arabic: "إِفْطَار", icon: "🍽️", description: "Break fast at sunset", position: CGPoint(x: 0.5, y: 0.6)),
            ConceptNode(title: "Taraweeh", arabic: "تَرَاوِيح", icon: "🕌", description: "Night prayers", position: CGPoint(x: 0.5, y: 0.75)),
            ConceptNode(title: "Laylatul Qadr", arabic: "لَيْلَةُ القَدْر", icon: "✨", description: "Night of Power", position: CGPoint(x: 0.5, y: 0.9))
        ],
        connections: [
            ConceptConnection(fromNodeIndex: 0, toNodeIndex: 1, label: "before"),
            ConceptConnection(fromNodeIndex: 1, toNodeIndex: 2, label: "begins"),
            ConceptConnection(fromNodeIndex: 2, toNodeIndex: 3, label: "during"),
            ConceptConnection(fromNodeIndex: 2, toNodeIndex: 4, label: "during"),
            ConceptConnection(fromNodeIndex: 2, toNodeIndex: 5, label: "ends at"),
            ConceptConnection(fromNodeIndex: 5, toNodeIndex: 6, label: "then"),
            ConceptConnection(fromNodeIndex: 6, toNodeIndex: 7, label: "seek")
        ]
    )
    
    static let allMaps: [ConceptMap] = [salahMap, wuduMap, ramadanMap]
}

// MARK: - Mini Game Models

enum ArabicMiniGameType: String, CaseIterable {
    case matchIconToWord = "Match Icon → Word"
    case soundRecognition = "Sound Recognition"
    case buildSentence = "Build Sentence"
    
    var icon: String {
        switch self {
        case .matchIconToWord: return "🎯"
        case .soundRecognition: return "🔊"
        case .buildSentence: return "📝"
        }
    }
    
    var description: String {
        switch self {
        case .matchIconToWord: return "Match the picture to the correct Arabic word"
        case .soundRecognition: return "Listen and identify the Arabic letter or word"
        case .buildSentence: return "Arrange words to form a correct sentence"
        }
    }
}

struct MatchGameItem: Identifiable {
    let id = UUID()
    let icon: String
    let arabic: String
    let english: String
    var isMatched: Bool = false
}

struct SentenceBuildGame: Identifiable {
    let id = UUID()
    let correctSentence: [String] // Arabic words in correct order
    let translation: String
    let shuffledWords: [String]
    
    static let samples: [SentenceBuildGame] = [
        SentenceBuildGame(
            correctSentence: ["أَنَا", "مُسْلِم"],
            translation: "I am a Muslim",
            shuffledWords: ["مُسْلِم", "أَنَا"]
        ),
        SentenceBuildGame(
            correctSentence: ["الْحَمْدُ", "لِلَّهِ"],
            translation: "Praise be to Allah",
            shuffledWords: ["لِلَّهِ", "الْحَمْدُ"]
        ),
        SentenceBuildGame(
            correctSentence: ["بِسْمِ", "اللَّهِ", "الرَّحْمَٰنِ", "الرَّحِيمِ"],
            translation: "In the name of Allah, the Most Gracious, the Most Merciful",
            shuffledWords: ["الرَّحِيمِ", "بِسْمِ", "الرَّحْمَٰنِ", "اللَّهِ"]
        )
    ]
}
