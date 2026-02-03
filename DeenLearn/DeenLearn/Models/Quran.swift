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
                QuranWord(id: "1:1:1", arabic: "بِسْمِ", transliteration: "bismi", translation: "In the name", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:1:2", arabic: "اللَّهِ", transliteration: "Allahi", translation: "of Allah", tajweedRules: [TajweedRule.lafzatullahFull], audioFileName: nil),
                QuranWord(id: "1:1:3", arabic: "الرَّحْمَٰنِ", transliteration: "ar-Rahmani", translation: "the Most Gracious", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:1:4", arabic: "الرَّحِيمِ", transliteration: "ar-Raheem", translation: "the Most Merciful", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
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
                QuranWord(id: "1:2:1", arabic: "الْحَمْدُ", transliteration: "alhamdu", translation: "All praise", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:2:2", arabic: "لِلَّهِ", transliteration: "lillahi", translation: "is due to Allah", tajweedRules: [TajweedRule.lafzatullahFull], audioFileName: nil),
                QuranWord(id: "1:2:3", arabic: "رَبِّ", transliteration: "Rabbi", translation: "Lord", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:2:4", arabic: "الْعَالَمِينَ", transliteration: "al-'aalameen", translation: "of the worlds", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
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
                QuranWord(id: "1:3:1", arabic: "الرَّحْمَٰنِ", transliteration: "ar-Rahmani", translation: "The Most Gracious", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:3:2", arabic: "الرَّحِيمِ", transliteration: "ar-Raheem", translation: "the Most Merciful", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
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
                QuranWord(id: "1:4:1", arabic: "مَالِكِ", transliteration: "Maliki", translation: "Master", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:4:2", arabic: "يَوْمِ", transliteration: "yawmi", translation: "of the Day", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:4:3", arabic: "الدِّينِ", transliteration: "ad-Deen", translation: "of Judgment", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
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
                QuranWord(id: "1:5:1", arabic: "إِيَّاكَ", transliteration: "Iyyaka", translation: "You alone", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:5:2", arabic: "نَعْبُدُ", transliteration: "na'budu", translation: "we worship", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:5:3", arabic: "وَإِيَّاكَ", transliteration: "wa iyyaka", translation: "and You alone", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:5:4", arabic: "نَسْتَعِينُ", transliteration: "nasta'een", translation: "we ask for help", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
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
                QuranWord(id: "1:6:1", arabic: "اهْدِنَا", transliteration: "Ihdina", translation: "Guide us", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:6:2", arabic: "الصِّرَاطَ", transliteration: "as-Sirata", translation: "to the path", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:6:3", arabic: "الْمُسْتَقِيمَ", transliteration: "al-Mustaqeem", translation: "the straight", tajweedRules: [TajweedRule.madd2], audioFileName: nil)
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
                QuranWord(id: "1:7:1", arabic: "صِرَاطَ", transliteration: "Sirata", translation: "The path", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:2", arabic: "الَّذِينَ", transliteration: "alladhina", translation: "of those who", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:3", arabic: "أَنْعَمْتَ", transliteration: "an'amta", translation: "You have bestowed favor", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:4", arabic: "عَلَيْهِمْ", transliteration: "'alayhim", translation: "upon them", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:5", arabic: "غَيْرِ", transliteration: "ghayri", translation: "not", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:6", arabic: "الْمَغْضُوبِ", transliteration: "al-maghdubi", translation: "those who earned anger", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:7", arabic: "عَلَيْهِمْ", transliteration: "'alayhim", translation: "upon them", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:8", arabic: "وَلَا", transliteration: "wa la", translation: "and not", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "1:7:9", arabic: "الضَّالِّينَ", transliteration: "ad-dalleen", translation: "those who are astray", tajweedRules: [TajweedRule.madd6], audioFileName: nil)
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
                QuranWord(id: "112:1:1", arabic: "قُلْ", transliteration: "Qul", translation: "Say", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil),
                QuranWord(id: "112:1:2", arabic: "هُوَ", transliteration: "Huwa", translation: "He is", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:1:3", arabic: "اللَّهُ", transliteration: "Allahu", translation: "Allah", tajweedRules: [TajweedRule.lafzatullahFull], audioFileName: nil),
                QuranWord(id: "112:1:4", arabic: "أَحَدٌ", transliteration: "Ahad", translation: "the One", tajweedRules: [TajweedRule.ghunnah], audioFileName: nil)
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
                QuranWord(id: "112:2:1", arabic: "اللَّهُ", transliteration: "Allahu", translation: "Allah", tajweedRules: [TajweedRule.lafzatullahFull], audioFileName: nil),
                QuranWord(id: "112:2:2", arabic: "الصَّمَدُ", transliteration: "as-Samad", translation: "the Eternal Refuge", tajweedRules: [], audioFileName: nil)
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
                QuranWord(id: "112:3:1", arabic: "لَمْ", transliteration: "Lam", translation: "Not", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:3:2", arabic: "يَلِدْ", transliteration: "yalid", translation: "He begets", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil),
                QuranWord(id: "112:3:3", arabic: "وَلَمْ", transliteration: "wa lam", translation: "and not", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:3:4", arabic: "يُولَدْ", transliteration: "yulad", translation: "is He born", tajweedRules: [TajweedRule.qalqalah], audioFileName: nil)
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
                QuranWord(id: "112:4:1", arabic: "وَلَمْ", transliteration: "Wa lam", translation: "And not", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:4:2", arabic: "يَكُن", transliteration: "yakun", translation: "is there", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:4:3", arabic: "لَّهُ", transliteration: "lahu", translation: "to Him", tajweedRules: [], audioFileName: nil),
                QuranWord(id: "112:4:4", arabic: "كُفُوًا", transliteration: "kufuwan", translation: "equivalent", tajweedRules: [TajweedRule.ghunnah], audioFileName: nil),
                QuranWord(id: "112:4:5", arabic: "أَحَدٌ", transliteration: "ahad", translation: "anyone", tajweedRules: [TajweedRule.ghunnah], audioFileName: nil)
            ],
            sajdahType: nil,
            juz: 30,
            page: 604,
            audioFileName: nil
        )
    ]
    
    static func getAyahs(forSurah surahId: Int) -> [Ayah] {
        switch surahId {
        case 1: return alFatiha
        case 112: return alIkhlas
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
