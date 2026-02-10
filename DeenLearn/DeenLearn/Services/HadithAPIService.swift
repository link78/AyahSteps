//
//  HadithAPIService.swift
//  DeenLearn
//
//  Hadith API service using Islamic Network Hadith API (api.hadith.gading.dev)
//  Provides hadith collections from Bukhari, Muslim, Tirmidzi, Abu Daud, Nasai,
//  Ibnu Majah, Ahmad, Darimi, and Malik
//  No API key required - free and open
//

import Foundation

// MARK: - Hadith API Response Models

struct HadithBooksResponse: Codable {
    let code: Int
    let message: String
    let data: [HadithBook]
}

struct HadithBook: Codable, Identifiable {
    let name: String
    let id: String
    let available: Int
}

struct HadithDetailResponse: Codable {
    let code: Int
    let message: String
    let data: HadithData
}

struct HadithRangeResponse: Codable {
    let code: Int
    let message: String
    let data: HadithRangeData
}

struct HadithRangeData: Codable {
    let name: String
    let id: String
    let available: Int
    let requested: Int
    let hadiths: [HadithContent]
}

struct HadithData: Codable {
    let name: String
    let id: String
    let available: Int
    let requested: Int
    let hadiths: [HadithContent]
}

struct HadithContent: Codable, Identifiable {
    let number: Int
    let arab: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case number, arab, id
    }
}

// MARK: - Hadith API Service

@MainActor
final class HadithAPIService: ObservableObject {
    static let shared = HadithAPIService()
    
    private let baseURL = "https://api.hadith.gading.dev"
    
    @Published var isLoading = false
    @Published var apiError: String?
    @Published var isUsingAPI = false
    
    // Cache for API responses
    private var hadithCache: [String: HadithContent] = [:]
    private var booksCache: [HadithBook]?
    
    private init() {}
    
    // MARK: - Available Collections
    
    enum Collection: String, CaseIterable {
        case bukhari
        case muslim
        case tirmidzi = "tirmidhi"
        case nasai
        case abuDaud = "abu-daud"
        case ibnuMajah = "ibnu-majah"
        case ahmad
        case darimi
        case malik
        
        var displayName: String {
            switch self {
            case .bukhari: return "Sahih al-Bukhari"
            case .muslim: return "Sahih Muslim"
            case .tirmidzi: return "Jami' at-Tirmidhi"
            case .nasai: return "Sunan an-Nasa'i"
            case .abuDaud: return "Sunan Abu Dawud"
            case .ibnuMajah: return "Sunan Ibn Majah"
            case .ahmad: return "Musnad Ahmad"
            case .darimi: return "Sunan ad-Darimi"
            case .malik: return "Muwatta Malik"
            }
        }
    }
    
    // MARK: - Fetch Available Books
    
    func fetchBooks() async -> [HadithBook]? {
        if let cached = booksCache {
            return cached
        }
        
        guard let url = URL(string: "\(baseURL)/books") else {
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
            
            let decoded = try JSONDecoder().decode(HadithBooksResponse.self, from: data)
            booksCache = decoded.data
            isUsingAPI = true
            apiError = nil
            return decoded.data
            
        } catch {
            isLoading = false
            apiError = error.localizedDescription
            return nil
        }
    }
    
    // MARK: - Fetch Specific Hadith
    
    /// Fetch a specific hadith by collection and number
    func fetchHadith(collection: String, number: Int) async -> HadithContent? {
        let cacheKey = "\(collection)-\(number)"
        if let cached = hadithCache[cacheKey] {
            return cached
        }
        
        guard let url = URL(string: "\(baseURL)/books/\(collection)/\(number)") else {
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
            
            let decoded = try JSONDecoder().decode(HadithDetailResponse.self, from: data)
            if let hadith = decoded.data.hadiths.first {
                hadithCache[cacheKey] = hadith
                isUsingAPI = true
                apiError = nil
                return hadith
            }
            return nil
            
        } catch {
            isLoading = false
            apiError = error.localizedDescription
            return nil
        }
    }
    
    // MARK: - Fetch Hadith Range
    
    /// Fetch a range of hadiths from a collection
    func fetchHadithRange(collection: String, from: Int, to: Int) async -> [HadithContent]? {
        guard to - from <= 300 else {
            apiError = "Max range is 300 hadiths"
            return nil
        }
        
        guard let url = URL(string: "\(baseURL)/books/\(collection)?range=\(from)-\(to)") else {
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
            
            let decoded = try JSONDecoder().decode(HadithRangeResponse.self, from: data)
            // Cache each hadith
            for hadith in decoded.data.hadiths {
                hadithCache["\(collection)-\(hadith.number)"] = hadith
            }
            isUsingAPI = true
            apiError = nil
            return decoded.data.hadiths
            
        } catch {
            isLoading = false
            apiError = error.localizedDescription
            return nil
        }
    }
    
    /// Clear all cached data
    func clearCache() {
        hadithCache.removeAll()
        booksCache = nil
    }
}
