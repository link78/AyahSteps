//
//  QuranDataService.swift
//  DeenLearn
//
//  Service for loading complete Quran data
//

import Foundation

// MARK: - QuranDataService

class QuranDataService {
    static let shared = QuranDataService()
    
    private var cachedSurahs: [QuranSurahData]?
    private var cachedAyahs: [Int: [QuranAyahData]] = [:]
    private var apiAyahsCache: [Int: [Ayah]] = [:]
    
    private init() {}
    
    // MARK: - Load All Surahs
    
    func loadAllSurahs() -> [Surah] {
        if let cached = cachedSurahs {
            return cached.map { $0.toSurah() }
        }
        
        // Load from JSON bundle
        guard let url = Bundle.main.url(forResource: "quran", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let quranData = try? JSONDecoder().decode(QuranJSONData.self, from: data) else {
            print("Failed to load quran.json - using fallback data")
            return getCompleteSurahList()
        }
        
        cachedSurahs = quranData.surahs
        return quranData.surahs.map { $0.toSurah() }
    }
    
    // MARK: - Load Ayahs for Surah (API-first with local fallback)
    
    /// Load ayahs from API cache if available, otherwise from local data
    func loadAyahs(forSurah surahId: Int) -> [Ayah] {
        // Check API cache first
        if let apiAyahs = apiAyahsCache[surahId], !apiAyahs.isEmpty {
            return apiAyahs
        }
        
        if let cached = cachedAyahs[surahId] {
            return cached.map { $0.toAyah() }
        }
        
        // Try to load from JSON
        guard let url = Bundle.main.url(forResource: "quran", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let quranData = try? JSONDecoder().decode(QuranJSONData.self, from: data),
              let surahData = quranData.surahs.first(where: { $0.number == surahId }) else {
            // Fallback to existing hardcoded data
            return Ayah.getAyahs(forSurah: surahId)
        }
        
        cachedAyahs[surahId] = surahData.ayahs
        return surahData.ayahs.map { $0.toAyah() }
    }
    
    // MARK: - Fetch Ayahs from API (async)
    
    /// Fetch ayahs from SutanLab API with audio URLs, caches result
    func fetchAyahsFromAPI(forSurah surahId: Int) async -> [Ayah]? {
        // Check cache first
        if let cached = apiAyahsCache[surahId], !cached.isEmpty {
            return cached
        }
        
        guard let surahDetail = await QuranAPIService.shared.fetchSurah(number: surahId) else {
            return nil
        }
        
        let ayahs = surahDetail.verses.map { verse in
            return Ayah(
                id: "\(surahId):\(verse.number.inSurah)",
                surahId: surahId,
                ayahNumber: verse.number.inSurah,
                arabic: verse.text.arab,
                transliteration: verse.text.transliteration.en,
                translation: verse.translation.en,
                words: [], // Word-level data not available from API; local data provides word-by-word details
                sajdahType: verse.meta.sajda.obligatory ? .obligatory : (verse.meta.sajda.recommended ? .recommended : nil),
                juz: verse.meta.juz,
                page: verse.meta.page,
                audioFileName: nil,
                audioURL: verse.audio.secondary.first ?? verse.audio.primary
            )
        }
        
        apiAyahsCache[surahId] = ayahs
        return ayahs
    }
    
    /// Clear API cache for a surah
    func clearAPICache(forSurah surahId: Int? = nil) {
        if let id = surahId {
            apiAyahsCache.removeValue(forKey: id)
        } else {
            apiAyahsCache.removeAll()
        }
    }
    
    // MARK: - Complete Surah List (Fallback)
    
    func getCompleteSurahList() -> [Surah] {
        return [
            Surah(id: 1, name: "Al-Fatihah", nameArabic: "الفاتحة", englishMeaning: "The Opening", revelationType: .meccan, verseCount: 7, juz: [1], page: 1, rukus: 1),
            Surah(id: 2, name: "Al-Baqarah", nameArabic: "البقرة", englishMeaning: "The Cow", revelationType: .medinan, verseCount: 286, juz: [1, 2, 3], page: 2, rukus: 40),
            Surah(id: 3, name: "Aali Imran", nameArabic: "آل عمران", englishMeaning: "The Family of Imran", revelationType: .medinan, verseCount: 200, juz: [3, 4], page: 50, rukus: 20),
            Surah(id: 4, name: "An-Nisa", nameArabic: "النساء", englishMeaning: "The Women", revelationType: .medinan, verseCount: 176, juz: [4, 5, 6], page: 77, rukus: 24),
            Surah(id: 5, name: "Al-Ma'idah", nameArabic: "المائدة", englishMeaning: "The Table Spread", revelationType: .medinan, verseCount: 120, juz: [6, 7], page: 106, rukus: 16),
            Surah(id: 6, name: "Al-An'am", nameArabic: "الأنعام", englishMeaning: "The Cattle", revelationType: .meccan, verseCount: 165, juz: [7, 8], page: 128, rukus: 20),
            Surah(id: 7, name: "Al-A'raf", nameArabic: "الأعراف", englishMeaning: "The Heights", revelationType: .meccan, verseCount: 206, juz: [8, 9], page: 151, rukus: 24),
            Surah(id: 8, name: "Al-Anfal", nameArabic: "الأنفال", englishMeaning: "The Spoils of War", revelationType: .medinan, verseCount: 75, juz: [9, 10], page: 177, rukus: 10),
            Surah(id: 9, name: "At-Tawbah", nameArabic: "التوبة", englishMeaning: "The Repentance", revelationType: .medinan, verseCount: 129, juz: [10, 11], page: 187, rukus: 16),
            Surah(id: 10, name: "Yunus", nameArabic: "يونس", englishMeaning: "Jonah", revelationType: .meccan, verseCount: 109, juz: [11], page: 208, rukus: 11),
            Surah(id: 11, name: "Hud", nameArabic: "هود", englishMeaning: "Hud", revelationType: .meccan, verseCount: 123, juz: [11, 12], page: 221, rukus: 10),
            Surah(id: 12, name: "Yusuf", nameArabic: "يوسف", englishMeaning: "Joseph", revelationType: .meccan, verseCount: 111, juz: [12, 13], page: 235, rukus: 12),
            Surah(id: 13, name: "Ar-Ra'd", nameArabic: "الرعد", englishMeaning: "The Thunder", revelationType: .medinan, verseCount: 43, juz: [13], page: 249, rukus: 6),
            Surah(id: 14, name: "Ibrahim", nameArabic: "إبراهيم", englishMeaning: "Abraham", revelationType: .meccan, verseCount: 52, juz: [13], page: 255, rukus: 7),
            Surah(id: 15, name: "Al-Hijr", nameArabic: "الحجر", englishMeaning: "The Rocky Tract", revelationType: .meccan, verseCount: 99, juz: [14], page: 262, rukus: 6),
            Surah(id: 16, name: "An-Nahl", nameArabic: "النحل", englishMeaning: "The Bee", revelationType: .meccan, verseCount: 128, juz: [14], page: 267, rukus: 16),
            Surah(id: 17, name: "Al-Isra", nameArabic: "الإسراء", englishMeaning: "The Night Journey", revelationType: .meccan, verseCount: 111, juz: [15], page: 282, rukus: 12),
            Surah(id: 18, name: "Al-Kahf", nameArabic: "الكهف", englishMeaning: "The Cave", revelationType: .meccan, verseCount: 110, juz: [15, 16], page: 293, rukus: 12),
            Surah(id: 19, name: "Maryam", nameArabic: "مريم", englishMeaning: "Mary", revelationType: .meccan, verseCount: 98, juz: [16], page: 305, rukus: 6),
            Surah(id: 20, name: "Ta-Ha", nameArabic: "طه", englishMeaning: "Ta-Ha", revelationType: .meccan, verseCount: 135, juz: [16], page: 312, rukus: 8),
            Surah(id: 21, name: "Al-Anbiya", nameArabic: "الأنبياء", englishMeaning: "The Prophets", revelationType: .meccan, verseCount: 112, juz: [17], page: 322, rukus: 7),
            Surah(id: 22, name: "Al-Hajj", nameArabic: "الحج", englishMeaning: "The Pilgrimage", revelationType: .medinan, verseCount: 78, juz: [17], page: 332, rukus: 10),
            Surah(id: 23, name: "Al-Mu'minun", nameArabic: "المؤمنون", englishMeaning: "The Believers", revelationType: .meccan, verseCount: 118, juz: [18], page: 342, rukus: 6),
            Surah(id: 24, name: "An-Nur", nameArabic: "النور", englishMeaning: "The Light", revelationType: .medinan, verseCount: 64, juz: [18], page: 350, rukus: 9),
            Surah(id: 25, name: "Al-Furqan", nameArabic: "الفرقان", englishMeaning: "The Criterion", revelationType: .meccan, verseCount: 77, juz: [18, 19], page: 359, rukus: 6),
            Surah(id: 26, name: "Ash-Shu'ara", nameArabic: "الشعراء", englishMeaning: "The Poets", revelationType: .meccan, verseCount: 227, juz: [19], page: 367, rukus: 11),
            Surah(id: 27, name: "An-Naml", nameArabic: "النمل", englishMeaning: "The Ant", revelationType: .meccan, verseCount: 93, juz: [19, 20], page: 377, rukus: 7),
            Surah(id: 28, name: "Al-Qasas", nameArabic: "القصص", englishMeaning: "The Stories", revelationType: .meccan, verseCount: 88, juz: [20], page: 385, rukus: 9),
            Surah(id: 29, name: "Al-Ankabut", nameArabic: "العنكبوت", englishMeaning: "The Spider", revelationType: .meccan, verseCount: 69, juz: [20, 21], page: 396, rukus: 7),
            Surah(id: 30, name: "Ar-Rum", nameArabic: "الروم", englishMeaning: "The Romans", revelationType: .meccan, verseCount: 60, juz: [21], page: 404, rukus: 6),
            Surah(id: 31, name: "Luqman", nameArabic: "لقمان", englishMeaning: "Luqman", revelationType: .meccan, verseCount: 34, juz: [21], page: 411, rukus: 4),
            Surah(id: 32, name: "As-Sajdah", nameArabic: "السجدة", englishMeaning: "The Prostration", revelationType: .meccan, verseCount: 30, juz: [21], page: 415, rukus: 3),
            Surah(id: 33, name: "Al-Ahzab", nameArabic: "الأحزاب", englishMeaning: "The Combined Forces", revelationType: .medinan, verseCount: 73, juz: [21, 22], page: 418, rukus: 9),
            Surah(id: 34, name: "Saba", nameArabic: "سبأ", englishMeaning: "Sheba", revelationType: .meccan, verseCount: 54, juz: [22], page: 428, rukus: 6),
            Surah(id: 35, name: "Fatir", nameArabic: "فاطر", englishMeaning: "Originator", revelationType: .meccan, verseCount: 45, juz: [22], page: 434, rukus: 5),
            Surah(id: 36, name: "Ya-Sin", nameArabic: "يس", englishMeaning: "Ya Sin", revelationType: .meccan, verseCount: 83, juz: [22, 23], page: 440, rukus: 5),
            Surah(id: 37, name: "As-Saffat", nameArabic: "الصافات", englishMeaning: "Those Ranged in Ranks", revelationType: .meccan, verseCount: 182, juz: [23], page: 446, rukus: 5),
            Surah(id: 38, name: "Sad", nameArabic: "ص", englishMeaning: "The Letter Sad", revelationType: .meccan, verseCount: 88, juz: [23], page: 453, rukus: 5),
            Surah(id: 39, name: "Az-Zumar", nameArabic: "الزمر", englishMeaning: "The Troops", revelationType: .meccan, verseCount: 75, juz: [23, 24], page: 458, rukus: 8),
            Surah(id: 40, name: "Ghafir", nameArabic: "غافر", englishMeaning: "The Forgiver", revelationType: .meccan, verseCount: 85, juz: [24], page: 467, rukus: 9),
            Surah(id: 41, name: "Fussilat", nameArabic: "فصلت", englishMeaning: "Explained in Detail", revelationType: .meccan, verseCount: 54, juz: [24, 25], page: 477, rukus: 6),
            Surah(id: 42, name: "Ash-Shura", nameArabic: "الشورى", englishMeaning: "The Consultation", revelationType: .meccan, verseCount: 53, juz: [25], page: 483, rukus: 5),
            Surah(id: 43, name: "Az-Zukhruf", nameArabic: "الزخرف", englishMeaning: "The Ornaments of Gold", revelationType: .meccan, verseCount: 89, juz: [25], page: 489, rukus: 7),
            Surah(id: 44, name: "Ad-Dukhan", nameArabic: "الدخان", englishMeaning: "The Smoke", revelationType: .meccan, verseCount: 59, juz: [25], page: 496, rukus: 3),
            Surah(id: 45, name: "Al-Jathiyah", nameArabic: "الجاثية", englishMeaning: "The Crouching", revelationType: .meccan, verseCount: 37, juz: [25], page: 499, rukus: 4),
            Surah(id: 46, name: "Al-Ahqaf", nameArabic: "الأحقاف", englishMeaning: "The Wind-Curved Sandhills", revelationType: .meccan, verseCount: 35, juz: [26], page: 502, rukus: 4),
            Surah(id: 47, name: "Muhammad", nameArabic: "محمد", englishMeaning: "Muhammad", revelationType: .medinan, verseCount: 38, juz: [26], page: 507, rukus: 4),
            Surah(id: 48, name: "Al-Fath", nameArabic: "الفتح", englishMeaning: "The Victory", revelationType: .medinan, verseCount: 29, juz: [26], page: 511, rukus: 4),
            Surah(id: 49, name: "Al-Hujurat", nameArabic: "الحجرات", englishMeaning: "The Rooms", revelationType: .medinan, verseCount: 18, juz: [26], page: 515, rukus: 2),
            Surah(id: 50, name: "Qaf", nameArabic: "ق", englishMeaning: "The Letter Qaf", revelationType: .meccan, verseCount: 45, juz: [26], page: 518, rukus: 3),
            Surah(id: 51, name: "Adh-Dhariyat", nameArabic: "الذاريات", englishMeaning: "The Winnowing Winds", revelationType: .meccan, verseCount: 60, juz: [26, 27], page: 520, rukus: 3),
            Surah(id: 52, name: "At-Tur", nameArabic: "الطور", englishMeaning: "The Mount", revelationType: .meccan, verseCount: 49, juz: [27], page: 523, rukus: 2),
            Surah(id: 53, name: "An-Najm", nameArabic: "النجم", englishMeaning: "The Star", revelationType: .meccan, verseCount: 62, juz: [27], page: 526, rukus: 3),
            Surah(id: 54, name: "Al-Qamar", nameArabic: "القمر", englishMeaning: "The Moon", revelationType: .meccan, verseCount: 55, juz: [27], page: 528, rukus: 3),
            Surah(id: 55, name: "Ar-Rahman", nameArabic: "الرحمن", englishMeaning: "The Beneficent", revelationType: .medinan, verseCount: 78, juz: [27], page: 531, rukus: 3),
            Surah(id: 56, name: "Al-Waqi'ah", nameArabic: "الواقعة", englishMeaning: "The Inevitable", revelationType: .meccan, verseCount: 96, juz: [27], page: 534, rukus: 3),
            Surah(id: 57, name: "Al-Hadid", nameArabic: "الحديد", englishMeaning: "The Iron", revelationType: .medinan, verseCount: 29, juz: [27], page: 537, rukus: 4),
            Surah(id: 58, name: "Al-Mujadila", nameArabic: "المجادلة", englishMeaning: "The Pleading Woman", revelationType: .medinan, verseCount: 22, juz: [28], page: 542, rukus: 3),
            Surah(id: 59, name: "Al-Hashr", nameArabic: "الحشر", englishMeaning: "The Exile", revelationType: .medinan, verseCount: 24, juz: [28], page: 545, rukus: 3),
            Surah(id: 60, name: "Al-Mumtahanah", nameArabic: "الممتحنة", englishMeaning: "She that is Examined", revelationType: .medinan, verseCount: 13, juz: [28], page: 549, rukus: 2),
            Surah(id: 61, name: "As-Saff", nameArabic: "الصف", englishMeaning: "The Ranks", revelationType: .medinan, verseCount: 14, juz: [28], page: 551, rukus: 2),
            Surah(id: 62, name: "Al-Jumu'ah", nameArabic: "الجمعة", englishMeaning: "The Congregation", revelationType: .medinan, verseCount: 11, juz: [28], page: 553, rukus: 2),
            Surah(id: 63, name: "Al-Munafiqun", nameArabic: "المنافقون", englishMeaning: "The Hypocrites", revelationType: .medinan, verseCount: 11, juz: [28], page: 554, rukus: 2),
            Surah(id: 64, name: "At-Taghabun", nameArabic: "التغابن", englishMeaning: "The Mutual Disillusion", revelationType: .medinan, verseCount: 18, juz: [28], page: 556, rukus: 2),
            Surah(id: 65, name: "At-Talaq", nameArabic: "الطلاق", englishMeaning: "The Divorce", revelationType: .medinan, verseCount: 12, juz: [28], page: 558, rukus: 2),
            Surah(id: 66, name: "At-Tahrim", nameArabic: "التحريم", englishMeaning: "The Prohibition", revelationType: .medinan, verseCount: 12, juz: [28], page: 560, rukus: 2),
            Surah(id: 67, name: "Al-Mulk", nameArabic: "الملك", englishMeaning: "The Sovereignty", revelationType: .meccan, verseCount: 30, juz: [29], page: 562, rukus: 2),
            Surah(id: 68, name: "Al-Qalam", nameArabic: "القلم", englishMeaning: "The Pen", revelationType: .meccan, verseCount: 52, juz: [29], page: 564, rukus: 2),
            Surah(id: 69, name: "Al-Haqqah", nameArabic: "الحاقة", englishMeaning: "The Reality", revelationType: .meccan, verseCount: 52, juz: [29], page: 566, rukus: 2),
            Surah(id: 70, name: "Al-Ma'arij", nameArabic: "المعارج", englishMeaning: "The Ascending Stairways", revelationType: .meccan, verseCount: 44, juz: [29], page: 568, rukus: 2),
            Surah(id: 71, name: "Nuh", nameArabic: "نوح", englishMeaning: "Noah", revelationType: .meccan, verseCount: 28, juz: [29], page: 570, rukus: 2),
            Surah(id: 72, name: "Al-Jinn", nameArabic: "الجن", englishMeaning: "The Jinn", revelationType: .meccan, verseCount: 28, juz: [29], page: 572, rukus: 2),
            Surah(id: 73, name: "Al-Muzzammil", nameArabic: "المزمل", englishMeaning: "The Enshrouded One", revelationType: .meccan, verseCount: 20, juz: [29], page: 574, rukus: 2),
            Surah(id: 74, name: "Al-Muddaththir", nameArabic: "المدثر", englishMeaning: "The Cloaked One", revelationType: .meccan, verseCount: 56, juz: [29], page: 575, rukus: 2),
            Surah(id: 75, name: "Al-Qiyamah", nameArabic: "القيامة", englishMeaning: "The Resurrection", revelationType: .meccan, verseCount: 40, juz: [29], page: 577, rukus: 2),
            Surah(id: 76, name: "Al-Insan", nameArabic: "الإنسان", englishMeaning: "The Human", revelationType: .medinan, verseCount: 31, juz: [29], page: 578, rukus: 2),
            Surah(id: 77, name: "Al-Mursalat", nameArabic: "المرسلات", englishMeaning: "The Emissaries", revelationType: .meccan, verseCount: 50, juz: [29], page: 580, rukus: 2),
            Surah(id: 78, name: "An-Naba", nameArabic: "النبأ", englishMeaning: "The Tidings", revelationType: .meccan, verseCount: 40, juz: [30], page: 582, rukus: 2),
            Surah(id: 79, name: "An-Nazi'at", nameArabic: "النازعات", englishMeaning: "Those Who Pull Out", revelationType: .meccan, verseCount: 46, juz: [30], page: 583, rukus: 2),
            Surah(id: 80, name: "'Abasa", nameArabic: "عبس", englishMeaning: "He Frowned", revelationType: .meccan, verseCount: 42, juz: [30], page: 585, rukus: 1),
            Surah(id: 81, name: "At-Takwir", nameArabic: "التكوير", englishMeaning: "The Overthrowing", revelationType: .meccan, verseCount: 29, juz: [30], page: 586, rukus: 1),
            Surah(id: 82, name: "Al-Infitar", nameArabic: "الانفطار", englishMeaning: "The Cleaving", revelationType: .meccan, verseCount: 19, juz: [30], page: 587, rukus: 1),
            Surah(id: 83, name: "Al-Mutaffifin", nameArabic: "المطففين", englishMeaning: "The Defrauding", revelationType: .meccan, verseCount: 36, juz: [30], page: 587, rukus: 1),
            Surah(id: 84, name: "Al-Inshiqaq", nameArabic: "الانشقاق", englishMeaning: "The Sundering", revelationType: .meccan, verseCount: 25, juz: [30], page: 589, rukus: 1),
            Surah(id: 85, name: "Al-Buruj", nameArabic: "البروج", englishMeaning: "The Mansions of the Stars", revelationType: .meccan, verseCount: 22, juz: [30], page: 590, rukus: 1),
            Surah(id: 86, name: "At-Tariq", nameArabic: "الطارق", englishMeaning: "The Morning Star", revelationType: .meccan, verseCount: 17, juz: [30], page: 591, rukus: 1),
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
            Surah(id: 102, name: "At-Takathur", nameArabic: "التكاثر", englishMeaning: "The Rivalry", revelationType: .meccan, verseCount: 8, juz: [30], page: 600, rukus: 1),
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
            Surah(id: 114, name: "An-Nas", nameArabic: "الناس", englishMeaning: "Mankind", revelationType: .meccan, verseCount: 6, juz: [30], page: 604, rukus: 1)
        ]
    }
}

// MARK: - JSON Data Models

struct QuranJSONData: Codable {
    let surahs: [QuranSurahData]
}

struct QuranSurahData: Codable {
    let number: Int
    let name: String
    let nameArabic: String
    let englishMeaning: String
    let revelationType: String
    let verseCount: Int
    let juz: [Int]
    let page: Int
    let rukus: Int
    let ayahs: [QuranAyahData]
    
    func toSurah() -> Surah {
        Surah(
            id: number,
            name: name,
            nameArabic: nameArabic,
            englishMeaning: englishMeaning,
            revelationType: revelationType.lowercased() == "meccan" ? .meccan : .medinan,
            verseCount: verseCount,
            juz: juz,
            page: page,
            rukus: rukus
        )
    }
}

struct QuranAyahData: Codable {
    let number: Int
    let arabic: String
    let transliteration: String
    let translation: String
    let juz: Int
    let page: Int
    
    func toAyah() -> Ayah {
        // Parse surah ID from the context
        let surahId = 1 // This will be set properly when loading
        return Ayah(
            id: "\(surahId):\(number)",
            surahId: surahId,
            ayahNumber: number,
            arabic: arabic,
            transliteration: transliteration,
            translation: translation,
            words: [], // Simplified - words can be added later
            sajdahType: nil,
            juz: juz,
            page: page,
            audioFileName: nil
        )
    }
}

// MARK: - Helper Extension for QuranAyahData with Surah context

extension QuranSurahData {
    func ayahsWithSurahContext() -> [Ayah] {
        return ayahs.map { ayahData in
            Ayah(
                id: "\(number):\(ayahData.number)",
                surahId: number,
                ayahNumber: ayahData.number,
                arabic: ayahData.arabic,
                transliteration: ayahData.transliteration,
                translation: ayahData.translation,
                words: [],
                sajdahType: nil,
                juz: ayahData.juz,
                page: ayahData.page,
                audioFileName: nil
            )
        }
    }
}

// MARK: - Updated Load Method

extension QuranDataService {
    func loadAyahsWithContext(forSurah surahId: Int) -> [Ayah] {
        // Try to load from JSON first
        if let url = Bundle.main.url(forResource: "quran", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let quranData = try? JSONDecoder().decode(QuranJSONData.self, from: data),
           let surahData = quranData.surahs.first(where: { $0.number == surahId }) {
            return surahData.ayahsWithSurahContext()
        }
        
        // No JSON file - generate basic ayahs from surah metadata
        // This ensures all 114 surahs can play audio via TTS
        return generateBasicAyahs(forSurah: surahId)
    }
    
    /// Generate basic ayah placeholders for surahs without detailed data
    /// This enables TTS audio playback for any surah
    private func generateBasicAyahs(forSurah surahId: Int) -> [Ayah] {
        // Get surah metadata from complete list
        let surahs = getCompleteSurahList()
        guard let surah = surahs.first(where: { $0.id == surahId }) else {
            return []
        }
        
        // Generate ayahs with Arabic placeholder text for TTS
        // Using the actual Arabic surah names and bismillah
        var ayahs: [Ayah] = []
        
        // Add Bismillah as first "ayah" for non-Fatiha surahs (Surah 9 has no Bismillah)
        let bismillah = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
        let bismillahTransliteration = "Bismillāhi r-raḥmāni r-raḥīm"
        let bismillahTranslation = "In the name of Allah, the Most Gracious, the Most Merciful"
        
        // Generate placeholder ayahs with Arabic numbers
        for ayahNum in 1...surah.verseCount {
            let arabicNumerals = convertToArabicNumerals(ayahNum)
            let arabicText: String
            let transliteration: String
            let translation: String
            
            if ayahNum == 1 && surahId != 1 && surahId != 9 {
                // First ayah includes bismillah for most surahs
                arabicText = "\(bismillah) ﴿\(arabicNumerals)﴾"
                transliteration = "\(bismillahTransliteration) - Verse \(ayahNum)"
                translation = "\(bismillahTranslation) - Verse \(ayahNum) of \(surah.name)"
            } else {
                // Use surah name in Arabic as placeholder for TTS
                arabicText = "\(surah.nameArabic) - الآية \(arabicNumerals)"
                transliteration = "\(surah.name) - Verse \(ayahNum)"
                translation = "Verse \(ayahNum) of \(surah.name) (\(surah.englishMeaning))"
            }
            
            let ayah = Ayah(
                id: "\(surahId):\(ayahNum)",
                surahId: surahId,
                ayahNumber: ayahNum,
                arabic: arabicText,
                transliteration: transliteration,
                translation: translation,
                words: [],
                sajdahType: nil,
                juz: surah.juz.first ?? 1,
                page: surah.page + (ayahNum / 15), // Approximate page
                audioFileName: nil
            )
            ayahs.append(ayah)
        }
        
        return ayahs
    }
    
    /// Convert integer to Arabic numerals for display
    private func convertToArabicNumerals(_ number: Int) -> String {
        let arabicDigits = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
        return String(number).map { arabicDigits[Int(String($0))!] }.joined()
    }
}
