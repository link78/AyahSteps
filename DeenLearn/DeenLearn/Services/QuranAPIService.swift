//
//  QuranAPIService.swift
//  DeenLearn
//
//  Quran API service using SutanLab/Quran API (api.quran.gading.dev)
//  Provides Quran text with Arabic, transliteration, English translation,
//  and audio recitation by Syekh Mishary Rashid Al-Afasy
//  No API key required - free and open
//

import Foundation

// MARK: - SutanLab API Response Models

struct SutanLabSurahListResponse: Codable {
    let code: Int
    let status: String
    let message: String
    let data: [SutanLabSurahSummary]
}

struct SutanLabSurahSummary: Codable {
    let number: Int
    let sequence: Int
    let numberOfVerses: Int
    let name: SutanLabName
    let revelation: SutanLabRevelation
    let tafsir: SutanLabTafsirSurah
}

struct SutanLabSurahResponse: Codable {
    let code: Int
    let status: String
    let message: String
    let data: SutanLabSurahDetail
}

struct SutanLabSurahDetail: Codable {
    let number: Int
    let sequence: Int
    let numberOfVerses: Int
    let name: SutanLabName
    let revelation: SutanLabRevelation
    let tafsir: SutanLabTafsirSurah
    let preBismillah: SutanLabPreBismillah?
    let verses: [SutanLabVerse]
}

struct SutanLabName: Codable {
    let short: String
    let long: String
    let transliteration: SutanLabTransliteration
    let translation: SutanLabTranslation
}

struct SutanLabTransliteration: Codable {
    let en: String
    let id: String?
}

struct SutanLabTranslation: Codable {
    let en: String
    let id: String?
}

struct SutanLabRevelation: Codable {
    let arab: String
    let en: String
    let id: String?
}

struct SutanLabTafsirSurah: Codable {
    let id: String?
}

struct SutanLabPreBismillah: Codable {
    let text: SutanLabVerseText?
    let translation: SutanLabTranslation?
    let audio: SutanLabAudio?
}

struct SutanLabVerse: Codable {
    let number: SutanLabVerseNumber
    let meta: SutanLabVerseMeta
    let text: SutanLabVerseText
    let translation: SutanLabTranslation
    let audio: SutanLabAudio
    let tafsir: SutanLabTafsirVerse?
}

struct SutanLabVerseNumber: Codable {
    let inQuran: Int
    let inSurah: Int
}

struct SutanLabVerseMeta: Codable {
    let juz: Int
    let page: Int
    let manzil: Int
    let ruku: Int
    let hizbQuarter: Int
    let sajda: SutanLabSajda
}

struct SutanLabSajda: Codable {
    let recommended: Bool
    let obligatory: Bool
}

struct SutanLabVerseText: Codable {
    let arab: String
    let transliteration: SutanLabTransliterationText
}

struct SutanLabTransliterationText: Codable {
    let en: String
}

struct SutanLabAudio: Codable {
    let primary: String
    let secondary: [String]
}

struct SutanLabTafsirVerse: Codable {
    let id: SutanLabTafsirContent?
}

struct SutanLabTafsirContent: Codable {
    let short: String?
    let long: String?
}

// MARK: - Quran API Service

@MainActor
final class QuranAPIService: ObservableObject {
    static let shared = QuranAPIService()
    
    private let baseURL = "https://api.quran.gading.dev"
    
    @Published var isLoading = false
    @Published var apiError: String?
    @Published var isUsingAPI = false
    
    // Cache for API responses
    private var surahCache: [Int: SutanLabSurahDetail] = [:]
    private var surahListCache: [SutanLabSurahSummary]?
    
    private init() {}
    
    // MARK: - Fetch All Surahs List
    
    /// Fetch list of all 114 surahs from API
    func fetchSurahList() async -> [SutanLabSurahSummary]? {
        if let cached = surahListCache {
            return cached
        }
        
        guard let url = URL(string: "\(baseURL)/surah") else {
            apiError = "Invalid URL"
            return nil
        }
        
        do {
            isLoading = true
            let (data, response) = try await URLSession.shared.data(from: url)
            isLoading = false
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                apiError = "Server error"
                return nil
            }
            
            let decoded = try JSONDecoder().decode(SutanLabSurahListResponse.self, from: data)
            surahListCache = decoded.data
            isUsingAPI = true
            apiError = nil
            return decoded.data
            
        } catch {
            isLoading = false
            apiError = error.localizedDescription
            return nil
        }
    }
    
    // MARK: - Fetch Surah Detail
    
    /// Fetch a specific surah with all verses, translations, and audio URLs
    func fetchSurah(number: Int) async -> SutanLabSurahDetail? {
        if let cached = surahCache[number] {
            return cached
        }
        
        guard let url = URL(string: "\(baseURL)/surah/\(number)") else {
            apiError = "Invalid URL"
            return nil
        }
        
        do {
            isLoading = true
            let (data, response) = try await URLSession.shared.data(from: url)
            isLoading = false
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                apiError = "Server error"
                return nil
            }
            
            let decoded = try JSONDecoder().decode(SutanLabSurahResponse.self, from: data)
            surahCache[number] = decoded.data
            isUsingAPI = true
            apiError = nil
            return decoded.data
            
        } catch {
            isLoading = false
            apiError = error.localizedDescription
            return nil
        }
    }
    
    // MARK: - Convert API Data to App Models
    
    /// Convert API surah summary to app Surah model
    func toSurah(_ summary: SutanLabSurahSummary) -> Surah {
        return Surah(
            id: summary.number,
            name: summary.name.transliteration.en,
            nameArabic: summary.name.short,
            englishMeaning: summary.name.translation.en,
            revelationType: summary.revelation.en.lowercased() == "meccan" ? .meccan : .medinan,
            verseCount: summary.numberOfVerses,
            juz: [],
            page: 0,
            rukus: 0
        )
    }
    
    /// Convert API verse to app Ayah model
    func toAyah(_ verse: SutanLabVerse, surahId: Int) -> Ayah {
        let sajdahType: SajdahType?
        if verse.meta.sajda.obligatory {
            sajdahType = .obligatory
        } else if verse.meta.sajda.recommended {
            sajdahType = .recommended
        } else {
            sajdahType = nil
        }
        
        // Use secondary audio URL (mp3) as primary, with fallback
        let audioURL = verse.audio.secondary.first ?? verse.audio.primary
        
        return Ayah(
            id: "\(surahId):\(verse.number.inSurah)",
            surahId: surahId,
            ayahNumber: verse.number.inSurah,
            arabic: verse.text.arab,
            transliteration: verse.text.transliteration.en,
            translation: verse.translation.en,
            words: [],
            sajdahType: sajdahType,
            juz: verse.meta.juz,
            page: verse.meta.page,
            audioFileName: nil,
            audioURL: audioURL
        )
    }
    
    /// Clear all cached data
    func clearCache() {
        surahCache.removeAll()
        surahListCache = nil
    }
}
