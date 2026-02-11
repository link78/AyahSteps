//
//  HadithKidsDataService.swift
//  DeenLearn
//
//  Manages kids hadith content with API-backed Arabic text and caching
//  Uses Islamic Network Hadith API via HadithAPIService
//

import Foundation

@MainActor
final class HadithKidsDataService: ObservableObject {
    static let shared = HadithKidsDataService()

    @Published var enrichedArabicTexts: [String: String] = [:]  // key: "{collection}-{number}"
    @Published var isLoading = false

    private var hasFetchedAll = false

    private init() {}

    /// Fetch Arabic text for a specific hadith from the API
    func fetchArabicText(collection: String, number: Int) async -> String? {
        let cacheKey = "\(collection)-\(number)"
        if let cached = enrichedArabicTexts[cacheKey] {
            return cached
        }

        let result = await HadithAPIService.shared.fetchHadith(
            collection: collection,
            number: number
        )
        if let content = result {
            enrichedArabicTexts[cacheKey] = content.arab
            return content.arab
        }
        return nil
    }

    /// Prefetch Arabic texts for all hadith stories in all zones
    func prefetchAllZoneHadiths() async {
        guard !hasFetchedAll else { return }
        isLoading = true

        let allHadiths = HadithWorldData.zones.flatMap { $0.hadiths.map { $0.hadith } }
        await withTaskGroup(of: Void.self) { group in
            for hadith in allHadiths {
                group.addTask {
                    _ = await self.fetchArabicText(
                        collection: hadith.collection,
                        number: hadith.hadithNumber
                    )
                }
            }
        }

        hasFetchedAll = true
        isLoading = false
    }

    /// Get the best Arabic text: API-fetched if available, otherwise local fallback
    func arabicText(for hadith: KidsHadith) -> String {
        let cacheKey = "\(hadith.collection)-\(hadith.hadithNumber)"
        return enrichedArabicTexts[cacheKey] ?? hadith.arabicText
    }

    /// Clear all cached data
    func clearCache() {
        enrichedArabicTexts.removeAll()
        hasFetchedAll = false
    }
}
