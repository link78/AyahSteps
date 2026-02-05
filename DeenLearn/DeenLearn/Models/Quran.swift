//
//  Quran.swift
//  DeenLearn
//
//  Data models for Quran learning - Reading, Recitation, Memorization
//

import SwiftUI

// MARK: - Surah Model

struct Surah: Identifiable, Codable {
    let id: Int
    let name: String
    let nameArabic: String
    let englishMeaning: String
    let revelationType: RevelationType
    let verseCount: Int
    let juz: [Int]
    let page: Int
    let rukus: Int
    
    // For kids
    var kidsEmoji: String {
        switch id {
        case 1: return "📖" // Al-Fatiha
        case 112: return "☝️" // Al-Ikhlas
        case 113: return "🌅" // Al-Falaq
        case 114: return "👥" // An-Nas
        case 108: return "💧" // Al-Kawthar
        case 110: return "🏆" // An-Nasr
        case 111: return "🔥" // Al-Masad
        case 109: return "🚫" // Al-Kafirun
        case 107: return "🤲" // Al-Ma'un
        case 105: return "🐘" // Al-Fil
        case 106: return "❄️" // Quraysh
        case 103: return "⏰" // Al-Asr
        case 102: return "💰" // At-Takathur
        case 101: return "⚖️" // Al-Qari'a
        case 100: return "🐎" // Al-Adiyat
        default: return "📜"
        }
    }
}

enum RevelationType: String, Codable {
    case meccan = "Meccan"
    case medinan = "Medinan"
}

// MARK: - Ayah Model

struct Ayah: Identifiable, Codable {
    let id: String
    let surahId: Int
    let ayahNumber: Int
    let arabic: String
    let transliteration: String
    let translation: String
    let words: [QuranWord]
    let sajdahType: SajdahType?
    let juz: Int
    let page: Int
    let audioFileName: String?
}

enum SajdahType: String, Codable {
    case recommended = "Recommended"
    case obligatory = "Obligatory"
}

// MARK: - Quran Word Model

struct QuranWord: Identifiable, Codable {
    let id: String
    let arabic: String
    let transliteration: String
    let translation: String
    let rootWord: String? // Arabic root word (e.g., ح-م-د for الحمد)
    let rootMeaning: String? // Root meaning in English
    let tajweedRules: [TajweedRule]
    let audioFileName: String?
}

// MARK: - Tajweed Rule Model

struct TajweedRule: Identifiable, Codable {
    let id: String
    let name: String
    let nameArabic: String
    let color: String // Hex color
    let description: String
    let example: String
    let audioFileName: String?
}

// MARK: - Memorization Progress

struct MemorizationProgress: Identifiable, Codable {
    let id: String
    let surahId: Int
    let totalAyahs: Int
    var ayahsMemorized: Set<Int>
    var lastPracticed: Date
    var strength: Double // 0-1, based on recall accuracy
    var totalReviews: Int
    
    var percentComplete: Double {
        guard totalAyahs > 0 else { return 0.0 }
        return Double(ayahsMemorized.count) / Double(totalAyahs)
    }
}

// MARK: - Bookmark

struct QuranBookmark: Identifiable, Codable {
    let id: String
    let surahId: Int
    let ayahNumber: Int
    let createdAt: Date
    var note: String?
    var color: String
}

// MARK: - Juz Amma Adventure (Kids)

struct JuzAmmaAdventure: Identifiable {
    let id: Int // Surah number
    let surahName: String
    let surahNameArabic: String
    let emoji: String
    let storyTheme: String
    let difficulty: DifficultyLevel
    let reward: String
    var isUnlocked: Bool
    var isCompleted: Bool
    var starsEarned: Int // 0-3
}

enum DifficultyLevel: String {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

// MARK: - Sample Data

extension Surah {
    static let juzAmma: [Surah] = [
        Surah(id: 78, name: "An-Naba", nameArabic: "النبأ", englishMeaning: "The Tidings", revelationType: .meccan, verseCount: 40, juz: [30], page: 582, rukus: 2),
        Surah(id: 79, name: "An-Nazi'at", nameArabic: "النازعات", englishMeaning: "Those Who Pull Out", revelationType: .meccan, verseCount: 46, juz: [30], page: 583, rukus: 2),
        Surah(id: 80, name: "Abasa", nameArabic: "عبس", englishMeaning: "He Frowned", revelationType: .meccan, verseCount: 42, juz: [30], page: 585, rukus: 1),
        Surah(id: 81, name: "At-Takwir", nameArabic: "التكوير", englishMeaning: "The Overthrowing", revelationType: .meccan, verseCount: 29, juz: [30], page: 586, rukus: 1),
        Surah(id: 82, name: "Al-Infitar", nameArabic: "الإنفطار", englishMeaning: "The Cleaving", revelationType: .meccan, verseCount: 19, juz: [30], page: 587, rukus: 1),
        Surah(id: 83, name: "Al-Mutaffifin", nameArabic: "المطففين", englishMeaning: "The Defrauders", revelationType: .meccan, verseCount: 36, juz: [30], page: 587, rukus: 1),
        Surah(id: 84, name: "Al-Inshiqaq", nameArabic: "الإنشقاق", englishMeaning: "The Splitting Open", revelationType: .meccan, verseCount: 25, juz: [30], page: 589, rukus: 1),
        Surah(id: 85, name: "Al-Buruj", nameArabic: "البروج", englishMeaning: "The Mansions of the Stars", revelationType: .meccan, verseCount: 22, juz: [30], page: 590, rukus: 1),
        Surah(id: 86, name: "At-Tariq", nameArabic: "الطارق", englishMeaning: "The Nightcomer", revelationType: .meccan, verseCount: 17, juz: [30], page: 591, rukus: 1),
        Surah(id: 87, name: "Al-A'la", nameArabic: "الأعلى", englishMeaning: "The Most High", revelationType: .meccan, verseCount: 19, juz: [30], page: 591, rukus: 1),
        Surah(id: 88, name: "Al-Ghashiyah", nameArabic: "الغاشية", englishMeaning: "The Overwhelming", revelationType: .meccan, verseCount: 26, juz: [30], page: 592, rukus: 1),
        Surah(id: 89, name: "Al-Fajr", nameArabic: "الفجر", englishMeaning: "The Dawn", revelationType: .meccan, verseCount: 30, juz: [30], page: 593, rukus: 1),
        Surah(id: 90, name: "Al-Balad", nameArabic: "البلد", englishMeaning: "The City", revelationType: .meccan, verseCount: 20, juz: [30], page: 594, rukus: 1),
        Surah(id: 91, name: "Ash-Shams", nameArabic: "الشمس", englishMeaning: "The Sun", revelationType: .meccan, verseCount: 15, juz: [30], page: 595, rukus: 1),
        Surah(id: 92, name: "Al-Layl", nameArabic: "الليل", englishMeaning: "The Night", revelationType: .meccan, verseCount: 21, juz: [30], page: 595, rukus: 1),
        Surah(id: 93, name: "Ad-Dhuha", nameArabic: "الضحى", englishMeaning: "The Morning Hours", revelationType: .meccan, verseCount: 11, juz: [30], page: 596, rukus: 1),
        Surah(id: 94, name: "Ash-Sharh", nameArabic: "الشرح", englishMeaning: "The Relief", revelationType: .meccan, verseCount: 8, juz: [30], page: 596, rukus: 1),
        Surah(id: 95, name: "At-Tin", nameArabic: "التين", englishMeaning: "The Fig", revelationType: .meccan, verseCount: 8, juz: [30], page: 597, rukus: 1),
        Surah(id: 96, name: "Al-Alaq", nameArabic: "العلق", englishMeaning: "The Clot", revelationType: .meccan, verseCount: 19, juz: [30], page: 597, rukus: 1),
        Surah(id: 97, name: "Al-Qadr", nameArabic: "القدر", englishMeaning: "The Power", revelationType: .meccan, verseCount: 5, juz: [30], page: 598, rukus: 1),
        Surah(id: 98, name: "Al-Bayyinah", nameArabic: "البينة", englishMeaning: "The Clear Proof", revelationType: .medinan, verseCount: 8, juz: [30], page: 598, rukus: 1),
        Surah(id: 99, name: "Az-Zalzalah", nameArabic: "الزلزلة", englishMeaning: "The Earthquake", revelationType: .medinan, verseCount: 8, juz: [30], page: 599, rukus: 1),
        Surah(id: 100, name: "Al-Adiyat", nameArabic: "العاديات", englishMeaning: "The Courser", revelationType: .meccan, verseCount: 11, juz: [30], page: 599, rukus: 1),
        Surah(id: 101, name: "Al-Qari'ah", nameArabic: "القارعة", englishMeaning: "The Calamity", revelationType: .meccan, verseCount: 11, juz: [30], page: 600, rukus: 1),
        Surah(id: 102, name: "At-Takathur", nameArabic: "التكاثر", englishMeaning: "The Rivalry in Worldly Increase", revelationType: .meccan, verseCount: 8, juz: [30], page: 600, rukus: 1),
        Surah(id: 103, name: "Al-Asr", nameArabic: "العصر", englishMeaning: "The Declining Day", revelationType: .meccan, verseCount: 3, juz: [30], page: 601, rukus: 1),
        Surah(id: 104, name: "Al-Humazah", nameArabic: "الهمزة", englishMeaning: "The Traducer", revelationType: .meccan, verseCount: 9, juz: [30], page: 601, rukus: 1),
        Surah(id: 105, name: "Al-Fil", nameArabic: "الفيل", englishMeaning: "The Elephant", revelationType: .meccan, verseCount: 5, juz: [30], page: 601, rukus: 1),
        Surah(id: 106, name: "Quraysh", nameArabic: "قريش", englishMeaning: "Quraysh", revelationType: .meccan, verseCount: 4, juz: [30], page: 602, rukus: 1),
        Surah(id: 107, name: "Al-Ma'un", nameArabic: "الماعون", englishMeaning: "The Small Kindnesses", revelationType: .meccan, verseCount: 7, juz: [30], page: 602, rukus: 1),
        Surah(id: 108, name: "Al-Kawthar", nameArabic: "الكوثر", englishMeaning: "The Abundance", revelationType: .meccan, verseCount: 3, juz: [30], page: 602, rukus: 1),
        Surah(id: 109, name: "Al-Kafirun", nameArabic: "الكافرون", englishMeaning: "The Disbelievers", revelationType: .meccan, verseCount: 6, juz: [30], page: 603, rukus: 1),
        Surah(id: 110, name: "An-Nasr", nameArabic: "النصر", englishMeaning: "The Divine Support", revelationType: .medinan, verseCount: 3, juz: [30], page: 603, rukus: 1),
        Surah(id: 111, name: "Al-Masad", nameArabic: "المسد", englishMeaning: "The Palm Fiber", revelationType: .meccan, verseCount: 5, juz: [30], page: 603, rukus: 1),
        Surah(id: 112, name: "Al-Ikhlas", nameArabic: "الإخلاص", englishMeaning: "The Sincerity", revelationType: .meccan, verseCount: 4, juz: [30], page: 604, rukus: 1),
        Surah(id: 113, name: "Al-Falaq", nameArabic: "الفلق", englishMeaning: "The Daybreak", revelationType: .meccan, verseCount: 5, juz: [30], page: 604, rukus: 1),
        Surah(id: 114, name: "An-Nas", nameArabic: "الناس", englishMeaning: "Mankind", revelationType: .meccan, verseCount: 6, juz: [30], page: 604, rukus: 1),
        // Al-Fatiha (always included for prayers)
        Surah(id: 1, name: "Al-Fatiha", nameArabic: "الفاتحة", englishMeaning: "The Opening", revelationType: .meccan, verseCount: 7, juz: [1], page: 1, rukus: 1)
    ]
    
    static func getSurah(id: Int) -> Surah? {
        juzAmma.first { $0.id == id }
    }
}

extension Ayah {
    // Sample ayahs for Al-Fatiha
    static let alFatiha: [Ayah] = [
        Ayah(
            id: "1:1",
            surahId: 1,
            ayahNumber: 1,
            arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
            transliteration: "Bismillahir Rahmanir Raheem",
            translation: "In the name of Allah, the Most Gracious, the Most Merciful",
            words: [
                QuranWord(id: "1:1:1", arabic: "بِسْمِ", transliteration: "bismi", translation: "In the name", rootWord: "س-م-و", rootMeaning: "name, to name", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:1:2", arabic: "اللَّهِ", transliteration: "Allahi", translation: "of Allah", rootWord: "إ-ل-ه", rootMeaning: "God, deity", tajweedRules: [TajweedRule.lafzatullahFull], audioFileName: nil),
                QuranWord(id: "1:1:3", arabic: "الرَّحْمَٰنِ", transliteration: "ar-Rahmani", translation: "the Most Gracious", rootWord: "ر-ح-م", rootMeaning: "mercy, compassion", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:1:4", arabic: "الرَّحِيمِ", transliteration: "ar-Raheem", translation: "the Most Merciful", rootWord: "ر-ح-م", rootMeaning: "mercy, compassion", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 1,
            page: 1,
            audioFileName: nil
        ),
        Ayah(
            id: "1:2",
            surahId: 1,
            ayahNumber: 2,
            arabic: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
            transliteration: "Alhamdu lillahi Rabbil 'aalameen",
            translation: "All praise is due to Allah, Lord of the worlds",
            words: [
                QuranWord(id: "1:2:1", arabic: "الْحَمْدُ", transliteration: "alhamdu", translation: "All praise", rootWord: "ح-م-د", rootMeaning: "praise, thankfulness", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:2:2", arabic: "لِلَّهِ", transliteration: "lillahi", translation: "is due to Allah", rootWord: "إ-ل-ه", rootMeaning: "God, deity", tajweedRules: [TajweedRule.lafzatullahFull], audioFileName: nil),
                QuranWord(id: "1:2:3", arabic: "رَبِّ", transliteration: "Rabbi", translation: "Lord", rootWord: "ر-ب-ب", rootMeaning: "Lord, master, nurturer", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:2:4", arabic: "الْعَالَمِينَ", transliteration: "al-'aalameen", translation: "of the worlds", rootWord: "ع-ل-م", rootMeaning: "to know, worlds", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 1,
            page: 1,
            audioFileName: nil
        ),
        Ayah(
            id: "1:3",
            surahId: 1,
            ayahNumber: 3,
            arabic: "الرَّحْمَٰنِ الرَّحِيمِ",
            transliteration: "Ar-Rahmanir-Raheem",
            translation: "The Most Gracious, the Most Merciful",
            words: [
                QuranWord(id: "1:3:1", arabic: "الرَّحْمَٰنِ", transliteration: "ar-Rahmani", translation: "The Most Gracious", rootWord: "ر-ح-م", rootMeaning: "mercy, compassion", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:3:2", arabic: "الرَّحِيمِ", transliteration: "ar-Raheem", translation: "the Most Merciful", rootWord: "ر-ح-م", rootMeaning: "mercy, compassion", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 1,
            page: 1,
            audioFileName: nil
        ),
        Ayah(
            id: "1:4",
            surahId: 1,
            ayahNumber: 4,
            arabic: "مَالِكِ يَوْمِ الدِّينِ",
            transliteration: "Maliki yawmid-Deen",
            translation: "Master of the Day of Judgment",
            words: [
                QuranWord(id: "1:4:1", arabic: "مَالِكِ", transliteration: "Maliki", translation: "Master", rootWord: "م-ل-ك", rootMeaning: "to own, possess, rule", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:4:2", arabic: "يَوْمِ", transliteration: "yawmi", translation: "of the Day", rootWord: "ي-و-م", rootMeaning: "day", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:4:3", arabic: "الدِّينِ", transliteration: "ad-Deen", translation: "of Judgment", rootWord: "د-ي-ن", rootMeaning: "religion, recompense", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 1,
            page: 1,
            audioFileName: nil
        ),
        Ayah(
            id: "1:5",
            surahId: 1,
            ayahNumber: 5,
            arabic: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
            transliteration: "Iyyaka na'budu wa iyyaka nasta'een",
            translation: "You alone we worship, and You alone we ask for help",
            words: [
                QuranWord(id: "1:5:1", arabic: "إِيَّاكَ", transliteration: "Iyyaka", translation: "You alone", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:5:2", arabic: "نَعْبُدُ", transliteration: "na'budu", translation: "we worship", rootWord: "ع-ب-د", rootMeaning: "to worship, serve", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:5:3", arabic: "وَإِيَّاكَ", transliteration: "wa iyyaka", translation: "and You alone", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:5:4", arabic: "نَسْتَعِينُ", transliteration: "nasta'een", translation: "we ask for help", rootWord: "ع-و-ن", rootMeaning: "help, assistance", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 1,
            page: 1,
            audioFileName: nil
        ),
        Ayah(
            id: "1:6",
            surahId: 1,
            ayahNumber: 6,
            arabic: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ",
            transliteration: "Ihdinas-Siratal-Mustaqeem",
            translation: "Guide us to the straight path",
            words: [
                QuranWord(id: "1:6:1", arabic: "اهْدِنَا", transliteration: "Ihdina", translation: "Guide us", rootWord: "ه-د-ي", rootMeaning: "guidance", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:6:2", arabic: "الصِّرَاطَ", transliteration: "as-Sirata", translation: "to the path", rootWord: "ص-ر-ط", rootMeaning: "path, way", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:6:3", arabic: "الْمُسْتَقِيمَ", transliteration: "al-Mustaqeem", translation: "the straight", rootWord: "ق-و-م", rootMeaning: "straight, upright", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 1,
            page: 1,
            audioFileName: nil
        ),
        Ayah(
            id: "1:7",
            surahId: 1,
            ayahNumber: 7,
            arabic: "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ",
            transliteration: "Siratal-ladhina an'amta 'alayhim ghayril-maghdubi 'alayhim wa lad-dalleen",
            translation: "The path of those upon whom You have bestowed favor, not of those who have earned anger or of those who are astray",
            words: [
                QuranWord(id: "1:7:1", arabic: "صِرَاطَ", transliteration: "Sirata", translation: "The path", rootWord: "ص-ر-ط", rootMeaning: "path, way", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:2", arabic: "الَّذِينَ", transliteration: "alladhina", translation: "of those who", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:3", arabic: "أَنْعَمْتَ", transliteration: "an'amta", translation: "You have bestowed favor", rootWord: "ن-ع-م", rootMeaning: "blessing, favor", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:4", arabic: "عَلَيْهِمْ", transliteration: "'alayhim", translation: "upon them", rootWord: "ع-ل-و", rootMeaning: "upon, over", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:5", arabic: "غَيْرِ", transliteration: "ghayri", translation: "not", rootWord: "غ-ي-ر", rootMeaning: "other than", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:6", arabic: "الْمَغْضُوبِ", transliteration: "al-maghdubi", translation: "those who earned anger", rootWord: "غ-ض-ب", rootMeaning: "anger", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:7", arabic: "عَلَيْهِمْ", transliteration: "'alayhim", translation: "upon them", rootWord: "ع-ل-و", rootMeaning: "upon, over", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:8", arabic: "وَلَا", transliteration: "wa la", translation: "and not", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:9", arabic: "الضَّالِّينَ", transliteration: "ad-dalleen", translation: "those who are astray", rootWord: "ض-ل-ل", rootMeaning: "to go astray", tajweedRules: [TajweedRule.madd6], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 1,
            page: 1,
            audioFileName: nil
        )
    ]
    
    // Sample ayahs for Al-Ikhlas
    static let alIkhlas: [Ayah] = [
        Ayah(
            id: "112:1",
            surahId: 112,
            ayahNumber: 1,
            arabic: "قُلْ هُوَ اللَّهُ أَحَدٌ",
            transliteration: "Qul Huwa Allahu Ahad",
            translation: "Say, He is Allah, the One",
            words: [
                QuranWord(id: "112:1:1", arabic: "قُلْ", transliteration: "Qul", translation: "Say", rootWord: "ق-و-ل", rootMeaning: "to say, speak", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil),
                QuranWord(id: "112:1:2", arabic: "هُوَ", transliteration: "Huwa", translation: "He is", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:1:3", arabic: "اللَّهُ", transliteration: "Allahu", translation: "Allah", rootWord: "إ-ل-ه", rootMeaning: "God, deity", tajweedRules: [TajweedRule.lafzatullahFull], audioFileName: nil),
                QuranWord(id: "112:1:4", arabic: "أَحَدٌ", transliteration: "Ahad", translation: "the One", rootWord: "و-ح-د", rootMeaning: "one, unique", tajweedRules: [TajweedRule.ghunnah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "112:2",
            surahId: 112,
            ayahNumber: 2,
            arabic: "اللَّهُ الصَّمَدُ",
            transliteration: "Allahus-Samad",
            translation: "Allah, the Eternal Refuge",
            words: [
                QuranWord(id: "112:2:1", arabic: "اللَّهُ", transliteration: "Allahu", translation: "Allah", rootWord: "إ-ل-ه", rootMeaning: "God, deity", tajweedRules: [TajweedRule.lafzatullahFull], audioFileName: nil),
                QuranWord(id: "112:2:2", arabic: "الصَّمَدُ", transliteration: "as-Samad", translation: "the Eternal Refuge", rootWord: "ص-م-د", rootMeaning: "eternal, independent", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "112:3",
            surahId: 112,
            ayahNumber: 3,
            arabic: "لَمْ يَلِدْ وَلَمْ يُولَدْ",
            transliteration: "Lam yalid wa lam yulad",
            translation: "He neither begets nor is born",
            words: [
                QuranWord(id: "112:3:1", arabic: "لَمْ", transliteration: "Lam", translation: "Not", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:3:2", arabic: "يَلِدْ", transliteration: "yalid", translation: "He begets", rootWord: "و-ل-د", rootMeaning: "to give birth", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil),
                QuranWord(id: "112:3:3", arabic: "وَلَمْ", transliteration: "wa lam", translation: "and not", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:3:4", arabic: "يُولَدْ", transliteration: "yulad", translation: "is He born", rootWord: "و-ل-د", rootMeaning: "to be born", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "112:4",
            surahId: 112,
            ayahNumber: 4,
            arabic: "وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ",
            transliteration: "Wa lam yakun lahu kufuwan ahad",
            translation: "Nor is there to Him any equivalent",
            words: [
                QuranWord(id: "112:4:1", arabic: "وَلَمْ", transliteration: "Wa lam", translation: "And not", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:4:2", arabic: "يَكُن", transliteration: "yakun", translation: "is there", rootWord: "ك-و-ن", rootMeaning: "to be", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:4:3", arabic: "لَّهُ", transliteration: "lahu", translation: "to Him", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:4:4", arabic: "كُفُوًا", transliteration: "kufuwan", translation: "equivalent", rootWord: "ك-ف-أ", rootMeaning: "equal, equivalent", tajweedRules: [TajweedRule.ghunnah], audioFileName: nil),
                QuranWord(id: "112:4:5", arabic: "أَحَدٌ", transliteration: "ahad", translation: "anyone", rootWord: "و-ح-د", rootMeaning: "one, unique", tajweedRules: [TajweedRule.ghunnah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        )
    ]
    
    // Sample ayahs for An-Nas (114)
    static let anNas: [Ayah] = [
        Ayah(
            id: "114:1",
            surahId: 114,
            ayahNumber: 1,
            arabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
            transliteration: "Qul a'udhu bi Rabbin-nas",
            translation: "Say, I seek refuge in the Lord of mankind",
            words: [
                QuranWord(id: "114:1:1", arabic: "قُلْ", transliteration: "Qul", translation: "Say", rootWord: "ق-و-ل", rootMeaning: "to say", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil),
                QuranWord(id: "114:1:2", arabic: "أَعُوذُ", transliteration: "a'udhu", translation: "I seek refuge", rootWord: "ع-و-ذ", rootMeaning: "refuge, protection", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:1:3", arabic: "بِرَبِّ", transliteration: "bi Rabbi", translation: "in the Lord", rootWord: "ر-ب-ب", rootMeaning: "Lord, master", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:1:4", arabic: "النَّاسِ", transliteration: "an-nas", translation: "of mankind", rootWord: "ن-و-س", rootMeaning: "people, mankind", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "114:2",
            surahId: 114,
            ayahNumber: 2,
            arabic: "مَلِكِ النَّاسِ",
            transliteration: "Malikin-nas",
            translation: "The Sovereign of mankind",
            words: [
                QuranWord(id: "114:2:1", arabic: "مَلِكِ", transliteration: "Maliki", translation: "The Sovereign", rootWord: "م-ل-ك", rootMeaning: "to own, rule", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:2:2", arabic: "النَّاسِ", transliteration: "an-nas", translation: "of mankind", rootWord: "ن-و-س", rootMeaning: "people", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "114:3",
            surahId: 114,
            ayahNumber: 3,
            arabic: "إِلَٰهِ النَّاسِ",
            transliteration: "Ilahin-nas",
            translation: "The God of mankind",
            words: [
                QuranWord(id: "114:3:1", arabic: "إِلَٰهِ", transliteration: "Ilahi", translation: "The God", rootWord: "إ-ل-ه", rootMeaning: "God, deity", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:3:2", arabic: "النَّاسِ", transliteration: "an-nas", translation: "of mankind", rootWord: "ن-و-س", rootMeaning: "people", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "114:4",
            surahId: 114,
            ayahNumber: 4,
            arabic: "مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ",
            transliteration: "Min sharril-waswasil-khannas",
            translation: "From the evil of the retreating whisperer",
            words: [
                QuranWord(id: "114:4:1", arabic: "مِن", transliteration: "Min", translation: "From", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:4:2", arabic: "شَرِّ", transliteration: "sharri", translation: "the evil", rootWord: "ش-ر-ر", rootMeaning: "evil", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:4:3", arabic: "الْوَسْوَاسِ", transliteration: "al-waswas", translation: "the whisperer", rootWord: "و-س-و-س", rootMeaning: "whisper", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:4:4", arabic: "الْخَنَّاسِ", transliteration: "al-khannas", translation: "who retreats", rootWord: "خ-ن-س", rootMeaning: "to retreat", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "114:5",
            surahId: 114,
            ayahNumber: 5,
            arabic: "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ",
            transliteration: "Alladhi yuwaswisu fi sudurin-nas",
            translation: "Who whispers in the breasts of mankind",
            words: [
                QuranWord(id: "114:5:1", arabic: "الَّذِي", transliteration: "Alladhi", translation: "Who", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:5:2", arabic: "يُوَسْوِسُ", transliteration: "yuwaswisu", translation: "whispers", rootWord: "و-س-و-س", rootMeaning: "whisper", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:5:3", arabic: "فِي", transliteration: "fi", translation: "in", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:5:4", arabic: "صُدُورِ", transliteration: "suduri", translation: "the breasts", rootWord: "ص-د-ر", rootMeaning: "chest, breast", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:5:5", arabic: "النَّاسِ", transliteration: "an-nas", translation: "of mankind", rootWord: "ن-و-س", rootMeaning: "people", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "114:6",
            surahId: 114,
            ayahNumber: 6,
            arabic: "مِنَ الْجِنَّةِ وَالنَّاسِ",
            transliteration: "Minal-jinnati wan-nas",
            translation: "From among the jinn and mankind",
            words: [
                QuranWord(id: "114:6:1", arabic: "مِنَ", transliteration: "Mina", translation: "From", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:6:2", arabic: "الْجِنَّةِ", transliteration: "al-jinnati", translation: "the jinn", rootWord: "ج-ن-ن", rootMeaning: "hidden beings", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "114:6:3", arabic: "وَالنَّاسِ", transliteration: "wan-nas", translation: "and mankind", rootWord: "ن-و-س", rootMeaning: "people", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        )
    ]
    
    // Sample ayahs for Al-Falaq (113)
    static let alFalaq: [Ayah] = [
        Ayah(
            id: "113:1",
            surahId: 113,
            ayahNumber: 1,
            arabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ",
            transliteration: "Qul a'udhu bi Rabbil-falaq",
            translation: "Say, I seek refuge in the Lord of daybreak",
            words: [
                QuranWord(id: "113:1:1", arabic: "قُلْ", transliteration: "Qul", translation: "Say", rootWord: "ق-و-ل", rootMeaning: "to say", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil),
                QuranWord(id: "113:1:2", arabic: "أَعُوذُ", transliteration: "a'udhu", translation: "I seek refuge", rootWord: "ع-و-ذ", rootMeaning: "refuge", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:1:3", arabic: "بِرَبِّ", transliteration: "bi Rabbi", translation: "in the Lord", rootWord: "ر-ب-ب", rootMeaning: "Lord", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:1:4", arabic: "الْفَلَقِ", transliteration: "al-falaq", translation: "of daybreak", rootWord: "ف-ل-ق", rootMeaning: "to split, dawn", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "113:2",
            surahId: 113,
            ayahNumber: 2,
            arabic: "مِن شَرِّ مَا خَلَقَ",
            transliteration: "Min sharri ma khalaq",
            translation: "From the evil of that which He created",
            words: [
                QuranWord(id: "113:2:1", arabic: "مِن", transliteration: "Min", translation: "From", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:2:2", arabic: "شَرِّ", transliteration: "sharri", translation: "the evil", rootWord: "ش-ر-ر", rootMeaning: "evil", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:2:3", arabic: "مَا", transliteration: "ma", translation: "of what", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:2:4", arabic: "خَلَقَ", transliteration: "khalaq", translation: "He created", rootWord: "خ-ل-ق", rootMeaning: "to create", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "113:3",
            surahId: 113,
            ayahNumber: 3,
            arabic: "وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ",
            transliteration: "Wa min sharri ghasiqin idha waqab",
            translation: "And from the evil of darkness when it settles",
            words: [
                QuranWord(id: "113:3:1", arabic: "وَمِن", transliteration: "Wa min", translation: "And from", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:3:2", arabic: "شَرِّ", transliteration: "sharri", translation: "the evil", rootWord: "ش-ر-ر", rootMeaning: "evil", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:3:3", arabic: "غَاسِقٍ", transliteration: "ghasiqin", translation: "of darkness", rootWord: "غ-س-ق", rootMeaning: "darkness", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:3:4", arabic: "إِذَا", transliteration: "idha", translation: "when", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:3:5", arabic: "وَقَبَ", transliteration: "waqab", translation: "it settles", rootWord: "و-ق-ب", rootMeaning: "to enter", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "113:4",
            surahId: 113,
            ayahNumber: 4,
            arabic: "وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ",
            transliteration: "Wa min sharrin-naffathati fil-'uqad",
            translation: "And from the evil of the blowers in knots",
            words: [
                QuranWord(id: "113:4:1", arabic: "وَمِن", transliteration: "Wa min", translation: "And from", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:4:2", arabic: "شَرِّ", transliteration: "sharri", translation: "the evil", rootWord: "ش-ر-ر", rootMeaning: "evil", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:4:3", arabic: "النَّفَّاثَاتِ", transliteration: "an-naffathat", translation: "the blowers", rootWord: "ن-ف-ث", rootMeaning: "to blow", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:4:4", arabic: "فِي", transliteration: "fi", translation: "in", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:4:5", arabic: "الْعُقَدِ", transliteration: "al-'uqad", translation: "the knots", rootWord: "ع-ق-د", rootMeaning: "knot", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        ),
        Ayah(
            id: "113:5",
            surahId: 113,
            ayahNumber: 5,
            arabic: "وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ",
            transliteration: "Wa min sharri hasidin idha hasad",
            translation: "And from the evil of an envier when he envies",
            words: [
                QuranWord(id: "113:5:1", arabic: "وَمِن", transliteration: "Wa min", translation: "And from", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:5:2", arabic: "شَرِّ", transliteration: "sharri", translation: "the evil", rootWord: "ش-ر-ر", rootMeaning: "evil", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:5:3", arabic: "حَاسِدٍ", transliteration: "hasidin", translation: "of an envier", rootWord: "ح-س-د", rootMeaning: "envy", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:5:4", arabic: "إِذَا", transliteration: "idha", translation: "when", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "113:5:5", arabic: "حَسَدَ", transliteration: "hasad", translation: "he envies", rootWord: "ح-س-د", rootMeaning: "to envy", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        )
    ]
    
    // Sample ayahs for Al-Kawthar (108)
    static let alKawthar: [Ayah] = [
        Ayah(
            id: "108:1",
            surahId: 108,
            ayahNumber: 1,
            arabic: "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ",
            transliteration: "Inna a'tayna kal-kawthar",
            translation: "Indeed, We have granted you al-Kawthar (the abundance)",
            words: [
                QuranWord(id: "108:1:1", arabic: "إِنَّا", transliteration: "Inna", translation: "Indeed, We", rootWord: nil, rootMeaning: nil, tajweedRules: [TajweedRule.ghunnah], audioFileName: nil),
                QuranWord(id: "108:1:2", arabic: "أَعْطَيْنَاكَ", transliteration: "a'taynaka", translation: "have granted you", rootWord: "ع-ط-و", rootMeaning: "to give", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "108:1:3", arabic: "الْكَوْثَرَ", transliteration: "al-kawthar", translation: "the abundance", rootWord: "ك-ث-ر", rootMeaning: "abundance", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 602,
            audioFileName: nil
        ),
        Ayah(
            id: "108:2",
            surahId: 108,
            ayahNumber: 2,
            arabic: "فَصَلِّ لِرَبِّكَ وَانْحَرْ",
            transliteration: "Fasalli li Rabbika wanhar",
            translation: "So pray to your Lord and sacrifice",
            words: [
                QuranWord(id: "108:2:1", arabic: "فَصَلِّ", transliteration: "Fasalli", translation: "So pray", rootWord: "ص-ل-و", rootMeaning: "prayer", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "108:2:2", arabic: "لِرَبِّكَ", transliteration: "li Rabbika", translation: "to your Lord", rootWord: "ر-ب-ب", rootMeaning: "Lord", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "108:2:3", arabic: "وَانْحَرْ", transliteration: "wanhar", translation: "and sacrifice", rootWord: "ن-ح-ر", rootMeaning: "to sacrifice", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 602,
            audioFileName: nil
        ),
        Ayah(
            id: "108:3",
            surahId: 108,
            ayahNumber: 3,
            arabic: "إِنَّ شَانِئَكَ هُوَ الْأَبْتَرُ",
            transliteration: "Inna shani'aka huwal-abtar",
            translation: "Indeed, your enemy is the one cut off",
            words: [
                QuranWord(id: "108:3:1", arabic: "إِنَّ", transliteration: "Inna", translation: "Indeed", rootWord: nil, rootMeaning: nil, tajweedRules: [TajweedRule.ghunnah], audioFileName: nil),
                QuranWord(id: "108:3:2", arabic: "شَانِئَكَ", transliteration: "shani'aka", translation: "your enemy", rootWord: "ش-ن-أ", rootMeaning: "to hate", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "108:3:3", arabic: "هُوَ", transliteration: "huwa", translation: "he is", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "108:3:4", arabic: "الْأَبْتَرُ", transliteration: "al-abtar", translation: "the one cut off", rootWord: "ب-ت-ر", rootMeaning: "to cut", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 602,
            audioFileName: nil
        )
    ]
    
    // Sample ayahs for Al-Asr (103)
    static let alAsr: [Ayah] = [
        Ayah(
            id: "103:1",
            surahId: 103,
            ayahNumber: 1,
            arabic: "وَالْعَصْرِ",
            transliteration: "Wal-'asr",
            translation: "By time",
            words: [
                QuranWord(id: "103:1:1", arabic: "وَالْعَصْرِ", transliteration: "Wal-'asr", translation: "By time", rootWord: "ع-ص-ر", rootMeaning: "time, era", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 601,
            audioFileName: nil
        ),
        Ayah(
            id: "103:2",
            surahId: 103,
            ayahNumber: 2,
            arabic: "إِنَّ الْإِنسَانَ لَفِي خُسْرٍ",
            transliteration: "Innal-insana lafi khusr",
            translation: "Indeed, mankind is in loss",
            words: [
                QuranWord(id: "103:2:1", arabic: "إِنَّ", transliteration: "Inna", translation: "Indeed", rootWord: nil, rootMeaning: nil, tajweedRules: [TajweedRule.ghunnah], audioFileName: nil),
                QuranWord(id: "103:2:2", arabic: "الْإِنسَانَ", transliteration: "al-insan", translation: "mankind", rootWord: "ء-ن-س", rootMeaning: "human", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "103:2:3", arabic: "لَفِي", transliteration: "lafi", translation: "is surely in", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "103:2:4", arabic: "خُسْرٍ", transliteration: "khusr", translation: "loss", rootWord: "خ-س-ر", rootMeaning: "loss", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 601,
            audioFileName: nil
        ),
        Ayah(
            id: "103:3",
            surahId: 103,
            ayahNumber: 3,
            arabic: "إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ",
            transliteration: "Illalladhina amanu wa 'amilus-salihati wa tawasaw bil-haqqi wa tawasaw bis-sabr",
            translation: "Except for those who have believed and done righteous deeds and advised each other to truth and advised each other to patience",
            words: [
                QuranWord(id: "103:3:1", arabic: "إِلَّا", transliteration: "Illa", translation: "Except", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "103:3:2", arabic: "الَّذِينَ", transliteration: "alladhina", translation: "those who", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "103:3:3", arabic: "آمَنُوا", transliteration: "amanu", translation: "have believed", rootWord: "ء-م-ن", rootMeaning: "faith", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "103:3:4", arabic: "وَعَمِلُوا", transliteration: "wa 'amilu", translation: "and done", rootWord: "ع-م-ل", rootMeaning: "to do", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "103:3:5", arabic: "الصَّالِحَاتِ", transliteration: "as-salihat", translation: "righteous deeds", rootWord: "ص-ل-ح", rootMeaning: "righteousness", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "103:3:6", arabic: "وَتَوَاصَوْا", transliteration: "wa tawasaw", translation: "and advised each other", rootWord: "و-ص-ي", rootMeaning: "advise", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "103:3:7", arabic: "بِالْحَقِّ", transliteration: "bil-haqq", translation: "to truth", rootWord: "ح-ق-ق", rootMeaning: "truth", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "103:3:8", arabic: "وَتَوَاصَوْا", transliteration: "wa tawasaw", translation: "and advised each other", rootWord: "و-ص-ي", rootMeaning: "advise", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "103:3:9", arabic: "بِالصَّبْرِ", transliteration: "bis-sabr", translation: "to patience", rootWord: "ص-ب-ر", rootMeaning: "patience", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 601,
            audioFileName: nil
        )
    ]
    
    // Sample ayahs for An-Nasr (110)
    static let anNasr: [Ayah] = [
        Ayah(
            id: "110:1",
            surahId: 110,
            ayahNumber: 1,
            arabic: "إِذَا جَاءَ نَصْرُ اللَّهِ وَالْفَتْحُ",
            transliteration: "Idha ja'a nasrullahi wal-fath",
            translation: "When the victory of Allah has come and the conquest",
            words: [
                QuranWord(id: "110:1:1", arabic: "إِذَا", transliteration: "Idha", translation: "When", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:1:2", arabic: "جَاءَ", transliteration: "ja'a", translation: "has come", rootWord: "ج-ي-ء", rootMeaning: "to come", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:1:3", arabic: "نَصْرُ", transliteration: "nasru", translation: "the victory", rootWord: "ن-ص-ر", rootMeaning: "help, victory", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:1:4", arabic: "اللَّهِ", transliteration: "Allahi", translation: "of Allah", rootWord: "إ-ل-ه", rootMeaning: "God", tajweedRules: [TajweedRule.lafzatullahFull], audioFileName: nil),
                QuranWord(id: "110:1:5", arabic: "وَالْفَتْحُ", transliteration: "wal-fath", translation: "and the conquest", rootWord: "ف-ت-ح", rootMeaning: "to open, conquer", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "110:2",
            surahId: 110,
            ayahNumber: 2,
            arabic: "وَرَأَيْتَ النَّاسَ يَدْخُلُونَ فِي دِينِ اللَّهِ أَفْوَاجًا",
            transliteration: "Wa ra'aytan-nasa yadkhuluna fi dinil-lahi afwaja",
            translation: "And you see the people entering into the religion of Allah in multitudes",
            words: [
                QuranWord(id: "110:2:1", arabic: "وَرَأَيْتَ", transliteration: "Wa ra'ayta", translation: "And you see", rootWord: "ر-ء-ي", rootMeaning: "to see", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:2:2", arabic: "النَّاسَ", transliteration: "an-nasa", translation: "the people", rootWord: "ن-و-س", rootMeaning: "people", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:2:3", arabic: "يَدْخُلُونَ", transliteration: "yadkhuluna", translation: "entering", rootWord: "د-خ-ل", rootMeaning: "to enter", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:2:4", arabic: "فِي", transliteration: "fi", translation: "into", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:2:5", arabic: "دِينِ", transliteration: "dini", translation: "the religion", rootWord: "د-ي-ن", rootMeaning: "religion", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:2:6", arabic: "اللَّهِ", transliteration: "Allahi", translation: "of Allah", rootWord: "إ-ل-ه", rootMeaning: "God", tajweedRules: [TajweedRule.lafzatullahFull], audioFileName: nil),
                QuranWord(id: "110:2:7", arabic: "أَفْوَاجًا", transliteration: "afwaja", translation: "in multitudes", rootWord: "ف-و-ج", rootMeaning: "group, crowd", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "110:3",
            surahId: 110,
            ayahNumber: 3,
            arabic: "فَسَبِّحْ بِحَمْدِ رَبِّكَ وَاسْتَغْفِرْهُ ۚ إِنَّهُ كَانَ تَوَّابًا",
            transliteration: "Fasabbih bihamdi Rabbika wastaghfirh, innahu kana tawwaba",
            translation: "Then exalt Him with praise of your Lord and ask forgiveness of Him. Indeed, He is ever Accepting of repentance",
            words: [
                QuranWord(id: "110:3:1", arabic: "فَسَبِّحْ", transliteration: "Fasabbih", translation: "Then exalt", rootWord: "س-ب-ح", rootMeaning: "glorify", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:3:2", arabic: "بِحَمْدِ", transliteration: "bihamdi", translation: "with praise", rootWord: "ح-م-د", rootMeaning: "praise", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:3:3", arabic: "رَبِّكَ", transliteration: "Rabbika", translation: "of your Lord", rootWord: "ر-ب-ب", rootMeaning: "Lord", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:3:4", arabic: "وَاسْتَغْفِرْهُ", transliteration: "wastaghfirh", translation: "and ask forgiveness", rootWord: "غ-ف-ر", rootMeaning: "forgiveness", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:3:5", arabic: "إِنَّهُ", transliteration: "innahu", translation: "Indeed, He", rootWord: nil, rootMeaning: nil, tajweedRules: [TajweedRule.ghunnah], audioFileName: nil),
                QuranWord(id: "110:3:6", arabic: "كَانَ", transliteration: "kana", translation: "is ever", rootWord: "ك-و-ن", rootMeaning: "to be", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "110:3:7", arabic: "تَوَّابًا", transliteration: "tawwaba", translation: "Accepting of repentance", rootWord: "ت-و-ب", rootMeaning: "repentance", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        )
    ]
    
    // Sample ayahs for Al-Kafirun (109)
    static let alKafirun: [Ayah] = [
        Ayah(
            id: "109:1",
            surahId: 109,
            ayahNumber: 1,
            arabic: "قُلْ يَا أَيُّهَا الْكَافِرُونَ",
            transliteration: "Qul ya ayyuhal-kafirun",
            translation: "Say, O disbelievers",
            words: [
                QuranWord(id: "109:1:1", arabic: "قُلْ", transliteration: "Qul", translation: "Say", rootWord: "ق-و-ل", rootMeaning: "to say", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil),
                QuranWord(id: "109:1:2", arabic: "يَا", transliteration: "ya", translation: "O", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:1:3", arabic: "أَيُّهَا", transliteration: "ayyuha", translation: "you", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:1:4", arabic: "الْكَافِرُونَ", transliteration: "al-kafirun", translation: "disbelievers", rootWord: "ك-ف-ر", rootMeaning: "to disbelieve", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "109:2",
            surahId: 109,
            ayahNumber: 2,
            arabic: "لَا أَعْبُدُ مَا تَعْبُدُونَ",
            transliteration: "La a'budu ma ta'budun",
            translation: "I do not worship what you worship",
            words: [
                QuranWord(id: "109:2:1", arabic: "لَا", transliteration: "La", translation: "Not", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:2:2", arabic: "أَعْبُدُ", transliteration: "a'budu", translation: "I worship", rootWord: "ع-ب-د", rootMeaning: "worship", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:2:3", arabic: "مَا", transliteration: "ma", translation: "what", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:2:4", arabic: "تَعْبُدُونَ", transliteration: "ta'budun", translation: "you worship", rootWord: "ع-ب-د", rootMeaning: "worship", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "109:3",
            surahId: 109,
            ayahNumber: 3,
            arabic: "وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ",
            transliteration: "Wa la antum 'abiduna ma a'bud",
            translation: "Nor are you worshippers of what I worship",
            words: [
                QuranWord(id: "109:3:1", arabic: "وَلَا", transliteration: "Wa la", translation: "Nor", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:3:2", arabic: "أَنتُمْ", transliteration: "antum", translation: "are you", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:3:3", arabic: "عَابِدُونَ", transliteration: "'abiduna", translation: "worshippers", rootWord: "ع-ب-د", rootMeaning: "worship", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:3:4", arabic: "مَا", transliteration: "ma", translation: "of what", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:3:5", arabic: "أَعْبُدُ", transliteration: "a'bud", translation: "I worship", rootWord: "ع-ب-د", rootMeaning: "worship", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "109:4",
            surahId: 109,
            ayahNumber: 4,
            arabic: "وَلَا أَنَا عَابِدٌ مَّا عَبَدتُّمْ",
            transliteration: "Wa la ana 'abidum ma 'abadtum",
            translation: "Nor will I be a worshipper of what you worship",
            words: [
                QuranWord(id: "109:4:1", arabic: "وَلَا", transliteration: "Wa la", translation: "Nor will", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:4:2", arabic: "أَنَا", transliteration: "ana", translation: "I be", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:4:3", arabic: "عَابِدٌ", transliteration: "'abidun", translation: "a worshipper", rootWord: "ع-ب-د", rootMeaning: "worship", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:4:4", arabic: "مَّا", transliteration: "ma", translation: "of what", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:4:5", arabic: "عَبَدتُّمْ", transliteration: "'abadtum", translation: "you worship", rootWord: "ع-ب-د", rootMeaning: "worship", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "109:5",
            surahId: 109,
            ayahNumber: 5,
            arabic: "وَلَا أَنتُمْ عَابِدُونَ مَا أَعْبُدُ",
            transliteration: "Wa la antum 'abiduna ma a'bud",
            translation: "Nor will you be worshippers of what I worship",
            words: [
                QuranWord(id: "109:5:1", arabic: "وَلَا", transliteration: "Wa la", translation: "Nor will", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:5:2", arabic: "أَنتُمْ", transliteration: "antum", translation: "you be", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:5:3", arabic: "عَابِدُونَ", transliteration: "'abiduna", translation: "worshippers", rootWord: "ع-ب-د", rootMeaning: "worship", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:5:4", arabic: "مَا", transliteration: "ma", translation: "of what", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:5:5", arabic: "أَعْبُدُ", transliteration: "a'bud", translation: "I worship", rootWord: "ع-ب-د", rootMeaning: "worship", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "109:6",
            surahId: 109,
            ayahNumber: 6,
            arabic: "لَكُمْ دِينُكُمْ وَلِيَ دِينِ",
            transliteration: "Lakum dinukum wa liya din",
            translation: "For you is your religion, and for me is my religion",
            words: [
                QuranWord(id: "109:6:1", arabic: "لَكُمْ", transliteration: "Lakum", translation: "For you", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:6:2", arabic: "دِينُكُمْ", transliteration: "dinukum", translation: "is your religion", rootWord: "د-ي-ن", rootMeaning: "religion", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:6:3", arabic: "وَلِيَ", transliteration: "wa liya", translation: "and for me", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "109:6:4", arabic: "دِينِ", transliteration: "din", translation: "is my religion", rootWord: "د-ي-ن", rootMeaning: "religion", tajweedRules: [], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        )
    ]
    
    // Sample ayahs for Al-Masad (111)
    static let alMasad: [Ayah] = [
        Ayah(
            id: "111:1",
            surahId: 111,
            ayahNumber: 1,
            arabic: "تَبَّتْ يَدَا أَبِي لَهَبٍ وَتَبَّ",
            transliteration: "Tabbat yada abi Lahabiw wa tabb",
            translation: "May the hands of Abu Lahab be ruined, and ruined is he",
            words: [
                QuranWord(id: "111:1:1", arabic: "تَبَّتْ", transliteration: "Tabbat", translation: "May be ruined", rootWord: "ت-ب-ب", rootMeaning: "to perish", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:1:2", arabic: "يَدَا", transliteration: "yada", translation: "the hands", rootWord: "ي-د-ي", rootMeaning: "hand", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:1:3", arabic: "أَبِي", transliteration: "abi", translation: "of the father", rootWord: "أ-ب-و", rootMeaning: "father", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:1:4", arabic: "لَهَبٍ", transliteration: "Lahab", translation: "of Lahab (flame)", rootWord: "ل-ه-ب", rootMeaning: "flame", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil),
                QuranWord(id: "111:1:5", arabic: "وَتَبَّ", transliteration: "wa tabb", translation: "and ruined is he", rootWord: "ت-ب-ب", rootMeaning: "to perish", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "111:2",
            surahId: 111,
            ayahNumber: 2,
            arabic: "مَا أَغْنَىٰ عَنْهُ مَالُهُ وَمَا كَسَبَ",
            transliteration: "Ma aghna 'anhu maluhu wa ma kasab",
            translation: "His wealth will not avail him or that which he gained",
            words: [
                QuranWord(id: "111:2:1", arabic: "مَا", transliteration: "Ma", translation: "Not", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:2:2", arabic: "أَغْنَىٰ", transliteration: "aghna", translation: "will avail", rootWord: "غ-ن-ي", rootMeaning: "to enrich", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:2:3", arabic: "عَنْهُ", transliteration: "'anhu", translation: "him", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:2:4", arabic: "مَالُهُ", transliteration: "maluhu", translation: "his wealth", rootWord: "م-و-ل", rootMeaning: "wealth", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:2:5", arabic: "وَمَا", transliteration: "wa ma", translation: "or that which", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:2:6", arabic: "كَسَبَ", transliteration: "kasab", translation: "he gained", rootWord: "ك-س-ب", rootMeaning: "to earn", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "111:3",
            surahId: 111,
            ayahNumber: 3,
            arabic: "سَيَصْلَىٰ نَارًا ذَاتَ لَهَبٍ",
            transliteration: "Sayasla naran dhata lahab",
            translation: "He will burn in a Fire of blazing flame",
            words: [
                QuranWord(id: "111:3:1", arabic: "سَيَصْلَىٰ", transliteration: "Sayasla", translation: "He will burn", rootWord: "ص-ل-ي", rootMeaning: "to burn", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:3:2", arabic: "نَارًا", transliteration: "naran", translation: "in a Fire", rootWord: "ن-و-ر", rootMeaning: "fire", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:3:3", arabic: "ذَاتَ", transliteration: "dhata", translation: "of", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:3:4", arabic: "لَهَبٍ", transliteration: "lahab", translation: "blazing flame", rootWord: "ل-ه-ب", rootMeaning: "flame", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "111:4",
            surahId: 111,
            ayahNumber: 4,
            arabic: "وَامْرَأَتُهُ حَمَّالَةَ الْحَطَبِ",
            transliteration: "Wamra'atuhu hammalatal-hatab",
            translation: "And his wife, the carrier of firewood",
            words: [
                QuranWord(id: "111:4:1", arabic: "وَامْرَأَتُهُ", transliteration: "Wamra'atuhu", translation: "And his wife", rootWord: "م-ر-ء", rootMeaning: "woman", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:4:2", arabic: "حَمَّالَةَ", transliteration: "hammalata", translation: "the carrier", rootWord: "ح-م-ل", rootMeaning: "to carry", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:4:3", arabic: "الْحَطَبِ", transliteration: "al-hatab", translation: "of firewood", rootWord: "ح-ط-ب", rootMeaning: "firewood", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        ),
        Ayah(
            id: "111:5",
            surahId: 111,
            ayahNumber: 5,
            arabic: "فِي جِيدِهَا حَبْلٌ مِّن مَّسَدٍ",
            transliteration: "Fi jidiha hablum mim masad",
            translation: "Around her neck is a rope of palm fiber",
            words: [
                QuranWord(id: "111:5:1", arabic: "فِي", transliteration: "Fi", translation: "Around", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:5:2", arabic: "جِيدِهَا", transliteration: "jidiha", translation: "her neck", rootWord: "ج-ي-د", rootMeaning: "neck", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:5:3", arabic: "حَبْلٌ", transliteration: "hablun", translation: "is a rope", rootWord: "ح-ب-ل", rootMeaning: "rope", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:5:4", arabic: "مِّن", transliteration: "min", translation: "of", rootWord: nil, rootMeaning: nil, tajweedRules: [], audioFileName: nil),
                QuranWord(id: "111:5:5", arabic: "مَّسَدٍ", transliteration: "masad", translation: "palm fiber", rootWord: "م-س-د", rootMeaning: "twisted rope", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 603,
            audioFileName: nil
        )
    ]
    
    static func getAyahs(forSurah surahId: Int) -> [Ayah] {
        switch surahId {
        case 1: return alFatiha
        case 103: return alAsr
        case 108: return alKawthar
        case 109: return alKafirun
        case 110: return anNasr
        case 111: return alMasad
        case 112: return alIkhlas
        case 113: return alFalaq
        case 114: return anNas
        default: return []
        }
    }
}

extension TajweedRule {
    // Common Tajweed rules with colors
    static let ghunnah = TajweedRule(
        id: "ghunnah",
        name: "Ghunnah",
        nameArabic: "غُنَّة",
        color: "#4CAF50", // Green
        description: "A nasal sound produced when pronouncing Noon (ن) or Meem (م) with shaddah, or in idgham/ikhfa",
        example: "إِنَّ - inna",
        audioFileName: nil
    )
    
    static let qalqalah = TajweedRule(
        id: "qalqalah",
        name: "Qalqalah",
        nameArabic: "قَلْقَلَة",
        color: "#2196F3", // Blue
        description: "A slight bouncing sound when pronouncing ق ط ب ج د (Qutub Jid) with sukoon",
        example: "قُلْ - qul",
        audioFileName: nil
    )
    
    static let madd2 = TajweedRule(
        id: "madd-2",
        name: "Madd (2 counts)",
        nameArabic: "مَدّ طبيعي",
        color: "#FF9800", // Orange
        description: "Natural prolongation of vowel sounds for 2 counts",
        example: "الرَّحِيمِ - ar-Raheem",
        audioFileName: nil
    )
    
    static let madd4 = TajweedRule(
        id: "madd-4",
        name: "Madd (4 counts)",
        nameArabic: "مَدّ متصل",
        color: "#E91E63", // Pink
        description: "Connected prolongation for 4-5 counts when followed by hamza in same word",
        example: "السَّمَاءِ - as-sama'i",
        audioFileName: nil
    )
    
    static let madd6 = TajweedRule(
        id: "madd-6",
        name: "Madd (6 counts)",
        nameArabic: "مَدّ لازم",
        color: "#9C27B0", // Purple
        description: "Obligatory prolongation for 6 counts",
        example: "الضَّالِّينَ - ad-dalleen",
        audioFileName: nil
    )
    
    static let idgham = TajweedRule(
        id: "idgham",
        name: "Idgham",
        nameArabic: "إدغام",
        color: "#00BCD4", // Cyan
        description: "Merging of Noon Sakinah or Tanween into following letter (ي ن م و ل ر)",
        example: "مِن رَّبِّهِمْ - mir-rabbihim",
        audioFileName: nil
    )
    
    static let ikhfa = TajweedRule(
        id: "ikhfa",
        name: "Ikhfa",
        nameArabic: "إخفاء",
        color: "#795548", // Brown
        description: "Hiding Noon Sakinah or Tanween with a nasal sound before 15 letters",
        example: "مِنْ قَبْلُ - min qablu",
        audioFileName: nil
    )
    
    static let iqlab = TajweedRule(
        id: "iqlab",
        name: "Iqlab",
        nameArabic: "إقلاب",
        color: "#607D8B", // Blue Grey
        description: "Converting Noon Sakinah or Tanween into Meem when followed by Ba",
        example: "أَنبِئْهُم - ambihum",
        audioFileName: nil
    )
    
    static let lafzatullahFull = TajweedRule(
        id: "lafzatullah-full",
        name: "Lafzatullah (Full)",
        nameArabic: "لفظ الجلالة (تفخيم)",
        color: "#F44336", // Red
        description: "The word 'Allah' pronounced with full mouth (tafkheem) after fatha or damma",
        example: "اللَّهُ - Allahu",
        audioFileName: nil
    )
    
    static let allRules: [TajweedRule] = [
        ghunnah, qalqalah, madd2, madd4, madd6, idgham, ikhfa, iqlab, lafzatullahFull
    ]
}

extension JuzAmmaAdventure {
    static let adventures: [JuzAmmaAdventure] = [
        // Start with shortest/easiest surahs
        JuzAmmaAdventure(id: 114, surahName: "An-Nas", surahNameArabic: "الناس", emoji: "👥", storyTheme: "Protection from Whispers", difficulty: .beginner, reward: "Guardian Badge", isUnlocked: true, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 113, surahName: "Al-Falaq", surahNameArabic: "الفلق", emoji: "🌅", storyTheme: "Protection from Evil", difficulty: .beginner, reward: "Dawn Protector", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 112, surahName: "Al-Ikhlas", surahNameArabic: "الإخلاص", emoji: "☝️", storyTheme: "Allah is One", difficulty: .beginner, reward: "Tawheed Star", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 111, surahName: "Al-Masad", surahNameArabic: "المسد", emoji: "🔥", storyTheme: "Truth Prevails", difficulty: .beginner, reward: "Truth Seeker", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 110, surahName: "An-Nasr", surahNameArabic: "النصر", emoji: "🏆", storyTheme: "Victory from Allah", difficulty: .beginner, reward: "Victory Crown", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 109, surahName: "Al-Kafirun", surahNameArabic: "الكافرون", emoji: "🚫", storyTheme: "Staying on the Path", difficulty: .beginner, reward: "Steadfast Badge", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 108, surahName: "Al-Kawthar", surahNameArabic: "الكوثر", emoji: "💧", storyTheme: "The Blessed River", difficulty: .beginner, reward: "Kawthar Key", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 107, surahName: "Al-Ma'un", surahNameArabic: "الماعون", emoji: "🤲", storyTheme: "Kindness Matters", difficulty: .beginner, reward: "Kind Heart", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 106, surahName: "Quraysh", surahNameArabic: "قريش", emoji: "❄️", storyTheme: "Safety & Provision", difficulty: .beginner, reward: "Caravan Badge", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 105, surahName: "Al-Fil", surahNameArabic: "الفيل", emoji: "🐘", storyTheme: "The Elephant Army", difficulty: .beginner, reward: "Elephant Defender", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 104, surahName: "Al-Humazah", surahNameArabic: "الهمزة", emoji: "🗣️", storyTheme: "Good Speech", difficulty: .intermediate, reward: "Kind Words", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 103, surahName: "Al-Asr", surahNameArabic: "العصر", emoji: "⏰", storyTheme: "Value of Time", difficulty: .beginner, reward: "Time Master", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 102, surahName: "At-Takathur", surahNameArabic: "التكاثر", emoji: "💰", storyTheme: "What Really Matters", difficulty: .intermediate, reward: "True Treasure", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 101, surahName: "Al-Qari'ah", surahNameArabic: "القارعة", emoji: "⚖️", storyTheme: "The Day of Judgment", difficulty: .intermediate, reward: "Balance Keeper", isUnlocked: false, isCompleted: false, starsEarned: 0),
        JuzAmmaAdventure(id: 100, surahName: "Al-Adiyat", surahNameArabic: "العاديات", emoji: "🐎", storyTheme: "The Charging Horses", difficulty: .intermediate, reward: "Swift Runner", isUnlocked: false, isCompleted: false, starsEarned: 0),
        // Al-Fatiha is special - always available
        JuzAmmaAdventure(id: 1, surahName: "Al-Fatiha", surahNameArabic: "الفاتحة", emoji: "📖", storyTheme: "The Opening", difficulty: .beginner, reward: "Prayer Key", isUnlocked: true, isCompleted: false, starsEarned: 0)
    ]
}
