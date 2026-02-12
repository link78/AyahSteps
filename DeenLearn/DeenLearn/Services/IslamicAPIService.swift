//
//  IslamicAPIService.swift
//  DeenLearn
//
//  Islamic data API service using Aladhan API
//  Provides prayer times, Qibla direction, and Hijri date
//  No API key required - free and open
//

import Foundation
import CoreLocation

// MARK: - API Response Models

struct AladhanTimingsResponse: Codable {
    let code: Int
    let status: String
    let data: AladhanTimingsData
}

struct AladhanTimingsData: Codable {
    let timings: AladhanTimings
    let date: AladhanDate
    let meta: AladhanMeta
}

struct AladhanTimings: Codable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}

struct AladhanDate: Codable {
    let readable: String
    let hijri: AladhanHijriDate
    let gregorian: AladhanGregorianDate
}

struct AladhanHijriDate: Codable {
    let date: String
    let day: String
    let month: AladhanMonth
    let year: String
    let designation: AladhanDesignation
    let weekday: AladhanWeekday
}

struct AladhanGregorianDate: Codable {
    let date: String
    let day: String
    let month: AladhanMonth
    let year: String
    let weekday: AladhanWeekday
}

struct AladhanMonth: Codable {
    let number: Int
    let en: String
    let ar: String?
}

struct AladhanDesignation: Codable {
    let abbreviated: String
    let expanded: String
}

struct AladhanWeekday: Codable {
    let en: String
    let ar: String?
}

struct AladhanMeta: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let method: AladhanMethod
    let school: String
}

struct AladhanMethod: Codable {
    let id: Int
    let name: String
}

struct AladhanQiblaResponse: Codable {
    let code: Int
    let status: String
    let data: AladhanQiblaData
}

struct AladhanQiblaData: Codable {
    let latitude: Double
    let longitude: Double
    let direction: Double
}

// MARK: - Islamic API Service

@MainActor
final class IslamicAPIService: ObservableObject {
    static let shared = IslamicAPIService()
    
    private let baseURL = "https://api.aladhan.com/v1"
    
    @Published var hijriDate: String = ""
    @Published var hijriMonth: String = ""
    @Published var hijriYear: String = ""
    @Published var qiblaDirection: Double?
    @Published var apiError: String?
    @Published var isUsingAPI: Bool = false
    
    private init() {}
    
    // MARK: - Prayer Times
    
    /// Fetch prayer times from API for given coordinates and date
    func fetchPrayerTimes(
        latitude: Double,
        longitude: Double,
        date: Date = Date(),
        method: Int = 2,
        school: Int = 0
    ) async -> AladhanTimingsData? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: date)
        
        let urlString = "\(baseURL)/timings/\(dateString)?latitude=\(latitude)&longitude=\(longitude)&method=\(method)&school=\(school)"
        
        guard let url = URL(string: urlString) else {
            apiError = "Invalid URL"
            return nil
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                apiError = "Server error"
                return nil
            }
            
            let decoded = try JSONDecoder().decode(AladhanTimingsResponse.self, from: data)
            
            // Update Hijri date
            let hijri = decoded.data.date.hijri
            hijriDate = "\(hijri.day) \(hijri.month.en) \(hijri.year)"
            hijriMonth = hijri.month.en
            hijriYear = hijri.year
            
            isUsingAPI = true
            apiError = nil
            return decoded.data
            
        } catch {
            apiError = error.localizedDescription
            isUsingAPI = false
            return nil
        }
    }
    
    // MARK: - Qibla Direction
    
    /// Fetch Qibla direction for given coordinates
    func fetchQiblaDirection(latitude: Double, longitude: Double) async {
        let urlString = "\(baseURL)/qibla/\(latitude)/\(longitude)"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { return }
            
            let decoded = try JSONDecoder().decode(AladhanQiblaResponse.self, from: data)
            qiblaDirection = decoded.data.direction
        } catch {
            print("Qibla fetch error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Hijri Date
    
    /// Fetch Hijri date for today
    func fetchHijriDate() async {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: Date())
        
        let urlString = "\(baseURL)/gToH/\(dateString)"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { return }
            
            struct HijriResponse: Codable {
                let code: Int
                let data: HijriData
                struct HijriData: Codable {
                    let hijri: AladhanHijriDate
                }
            }
            
            let decoded = try JSONDecoder().decode(HijriResponse.self, from: data)
            hijriDate = "\(decoded.data.hijri.day) \(decoded.data.hijri.month.en) \(decoded.data.hijri.year)"
            hijriMonth = decoded.data.hijri.month.en
            hijriYear = decoded.data.hijri.year
        } catch {
            print("Hijri date fetch error: \(error.localizedDescription)")
        }
    }
}
