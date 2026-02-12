//
//  SubscriptionService.swift
//  DeenLearn
//
//  Created by DeenLearn Team
//

import Foundation
import StoreKit
import Combine

// MARK: - Subscription Plans

/// DeenLearn subscription tiers
enum SubscriptionPlan: String, CaseIterable, Identifiable {
    case free = "free"
    case monthly = "com.deenlearn.plus.monthly"
    case yearly = "com.deenlearn.plus.yearly"
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .free: return "DeenLearn Basic"
        case .monthly: return "DeenLearn Plus"
        case .yearly: return "DeenLearn Plus"
        }
    }
    
    var displayName: String {
        switch self {
        case .free: return "Basic (Free)"
        case .monthly: return "Plus Monthly"
        case .yearly: return "Plus Yearly"
        }
    }
    
    var price: String {
        switch self {
        case .free: return "Free"
        case .monthly: return "$4.99/month"
        case .yearly: return "$39.99/year"
        }
    }
    
    var priceValue: Decimal {
        switch self {
        case .free: return 0
        case .monthly: return 4.99
        case .yearly: return 39.99
        }
    }
    
    var isPremium: Bool {
        return self != .free
    }
    
    var isBestValue: Bool {
        return self == .yearly
    }
    
    var savingsPercentage: Int? {
        switch self {
        case .yearly: return 33 // ~$3.33/month vs $4.99/month
        default: return nil
        }
    }
}

// MARK: - Premium Features

/// Features available to premium subscribers
enum PremiumFeature: String, CaseIterable {
    case fullSalahTrainer = "full_salah_trainer"
    case fullPillarsLessons = "full_pillars_lessons"
    case quranAudioWordByWord = "quran_audio_word_by_word"
    case tajwidColorOverlay = "tajwid_color_overlay"
    case memorizationMode = "memorization_mode"
    case fullArabicAlphabet = "full_arabic_alphabet"
    case alphabetTracing = "alphabet_tracing"
    case vocabularyPacks = "vocabulary_packs"
    case miniGames = "mini_games"
    case unlimitedChildProfiles = "unlimited_child_profiles"
    case parentControls = "parent_controls"
    case offlineMode = "offline_mode"
    case familyAchievements = "family_achievements"
    
    var displayName: String {
        switch self {
        case .fullSalahTrainer: return "Full Salah Trainer"
        case .fullPillarsLessons: return "Full Pillars Lessons"
        case .quranAudioWordByWord: return "Word-by-Word Audio"
        case .tajwidColorOverlay: return "Tajwīd Colors"
        case .memorizationMode: return "Memorization Mode"
        case .fullArabicAlphabet: return "Full Arabic Alphabet"
        case .alphabetTracing: return "Letter Tracing"
        case .vocabularyPacks: return "Vocabulary Packs"
        case .miniGames: return "Mini Games"
        case .unlimitedChildProfiles: return "Unlimited Profiles"
        case .parentControls: return "Parent Controls"
        case .offlineMode: return "Offline Mode"
        case .familyAchievements: return "Family Achievements"
        }
    }
    
    var description: String {
        switch self {
        case .fullSalahTrainer: return "Learn all 5 daily prayers with step-by-step guidance"
        case .fullPillarsLessons: return "Complete lessons on all 5 Pillars for kids and adults"
        case .quranAudioWordByWord: return "Hear each word of the Quran with pronunciation"
        case .tajwidColorOverlay: return "Color-coded Tajwīd rules for better recitation"
        case .memorizationMode: return "Looping and call-response for memorization"
        case .fullArabicAlphabet: return "All 28 Arabic letters with proper pronunciation"
        case .alphabetTracing: return "Practice writing Arabic letters"
        case .vocabularyPacks: return "Expand your Arabic vocabulary"
        case .miniGames: return "Fun learning games for all ages"
        case .unlimitedChildProfiles: return "Create profiles for all your children"
        case .parentControls: return "Set screen time limits and learning goals"
        case .offlineMode: return "Access content without internet"
        case .familyAchievements: return "Track family progress together"
        }
    }
    
    var icon: String {
        switch self {
        case .fullSalahTrainer: return "figure.prayer"
        case .fullPillarsLessons: return "building.columns"
        case .quranAudioWordByWord: return "speaker.wave.3"
        case .tajwidColorOverlay: return "paintpalette"
        case .memorizationMode: return "repeat"
        case .fullArabicAlphabet: return "textformat.size.ar"
        case .alphabetTracing: return "pencil.and.outline"
        case .vocabularyPacks: return "book.closed"
        case .miniGames: return "gamecontroller"
        case .unlimitedChildProfiles: return "person.3"
        case .parentControls: return "shield.checkered"
        case .offlineMode: return "arrow.down.circle"
        case .familyAchievements: return "star.circle"
        }
    }
}

// MARK: - Subscription Service

/// Manages subscription state and StoreKit integration
@MainActor
class SubscriptionService: ObservableObject {
    
    // MARK: - Singleton
    static let shared = SubscriptionService()
    
    // MARK: - Published Properties
    @Published var currentPlan: SubscriptionPlan = .free
    @Published var isSubscribed: Bool = false
    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private var productIDs: Set<String> = [
        SubscriptionPlan.monthly.rawValue,
        SubscriptionPlan.yearly.rawValue
    ]
    private var transactionListener: Task<Void, Error>?
    
    // MARK: - Constants
    private let freeLetterLimit = 8
    private let freeSurahLimit = 37 // Juz Amma: Surahs 78-114
    private let freeChildProfileLimit = 1
    private let freeWorldsLimit = 1 // Shahada Island only
    
    // MARK: - Initialization
    
    private init() {
        // Start listening for transactions
        transactionListener = listenForTransactions()
        
        // Load saved subscription state
        loadSubscriptionState()
        
        // Fetch products
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    // MARK: - Product Loading
    
    /// Load available products from App Store
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            products = try await Product.products(for: productIDs)
            products.sort { $0.price < $1.price }
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            print("Error loading products: \(error)")
        }
    }
    
    // MARK: - Purchase
    
    /// Purchase a subscription
    func purchase(_ plan: SubscriptionPlan) async throws -> Bool {
        guard plan.isPremium else { return false }
        
        guard let product = products.first(where: { $0.id == plan.rawValue }) else {
            throw SubscriptionError.productNotFound
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateSubscriptionStatus()
            return true
            
        case .userCancelled:
            return false
            
        case .pending:
            return false
            
        @unknown default:
            return false
        }
    }
    
    /// Restore previous purchases
    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
        } catch {
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Subscription Status
    
    /// Update current subscription status
    func updateSubscriptionStatus() async {
        var hasActiveSubscription = false
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if productIDs.contains(transaction.productID) {
                    hasActiveSubscription = true
                    
                    if transaction.productID == SubscriptionPlan.yearly.rawValue {
                        currentPlan = .yearly
                    } else if transaction.productID == SubscriptionPlan.monthly.rawValue {
                        currentPlan = .monthly
                    }
                    
                    purchasedProductIDs.insert(transaction.productID)
                }
            }
        }
        
        if !hasActiveSubscription {
            currentPlan = .free
            purchasedProductIDs.removeAll()
        }
        
        isSubscribed = hasActiveSubscription
        saveSubscriptionState()
    }
    
    // MARK: - Feature Access
    
    /// Check if a premium feature is available
    func hasAccess(to feature: PremiumFeature) -> Bool {
        return isSubscribed
    }
    
    /// Check if user has premium subscription
    var isPremium: Bool {
        return isSubscribed
    }
    
    // MARK: - Content Limits (Free Tier)
    
    /// Number of Arabic letters available for free users
    var availableLetterCount: Int {
        return isPremium ? 28 : freeLetterLimit
    }
    
    /// Check if a letter is available (by index)
    func isLetterAvailable(index: Int) -> Bool {
        return isPremium || index < freeLetterLimit
    }
    
    /// Check if a surah is available (by number)
    func isSurahAvailable(number: Int) -> Bool {
        // Free users only get Juz Amma (Surahs 78-114)
        return isPremium || number >= 78
    }
    
    /// Check if a prayer is available
    func isPrayerAvailable(name: String) -> Bool {
        if isPremium { return true }
        // Free users only get Fajr
        return name.lowercased() == "fajr"
    }
    
    /// Check if all 5 prayers are available
    var hasFullSalahAccess: Bool {
        return isPremium
    }
    
    /// Number of available pillar worlds for free users
    var availableWorldCount: Int {
        return isPremium ? 5 : freeWorldsLimit
    }
    
    /// Check if a pillar world is available (by index)
    func isWorldAvailable(index: Int) -> Bool {
        // Free users only get Shahada Island (index 0)
        return isPremium || index < freeWorldsLimit
    }
    
    /// Number of child profiles allowed
    var childProfileLimit: Int {
        return isPremium ? Int.max : freeChildProfileLimit
    }
    
    // MARK: - Quran Features
    
    /// Check if word-by-word audio is available
    var hasWordByWordAudio: Bool {
        return isPremium
    }
    
    /// Check if Tajwid color overlay is available
    var hasTajwidColors: Bool {
        return isPremium
    }
    
    /// Check if memorization mode is available
    var hasMemorizationMode: Bool {
        return isPremium
    }
    
    // MARK: - Arabic Features
    
    /// Check if alphabet tracing is available
    var hasAlphabetTracing: Bool {
        return isPremium
    }
    
    /// Check if vocabulary packs are available
    var hasVocabularyPacks: Bool {
        return isPremium
    }
    
    // MARK: - Family Features
    
    /// Check if offline mode is available
    var hasOfflineMode: Bool {
        return isPremium
    }
    
    /// Check if parent controls are available
    var hasParentControls: Bool {
        return isPremium
    }
    
    /// Check if family achievements are available
    var hasFamilyAchievements: Bool {
        return isPremium
    }
    
    // MARK: - Private Helpers
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await self?.updateSubscriptionStatus()
                    await transaction.finish()
                }
            }
        }
    }
    
    // MARK: - Persistence
    
    private func saveSubscriptionState() {
        UserDefaults.standard.set(currentPlan.rawValue, forKey: "deenlearn_subscription_plan")
        UserDefaults.standard.set(isSubscribed, forKey: "deenlearn_is_subscribed")
    }
    
    private func loadSubscriptionState() {
        if let planString = UserDefaults.standard.string(forKey: "deenlearn_subscription_plan"),
           let plan = SubscriptionPlan(rawValue: planString) {
            currentPlan = plan
        }
        isSubscribed = UserDefaults.standard.bool(forKey: "deenlearn_is_subscribed")
    }
    
    // MARK: - Debug Helpers
    
    #if DEBUG
    /// Toggle premium for testing
    func togglePremiumForTesting() {
        isSubscribed.toggle()
        currentPlan = isSubscribed ? .yearly : .free
        saveSubscriptionState()
    }
    
    /// Set specific plan for testing
    func setPlanForTesting(_ plan: SubscriptionPlan) {
        currentPlan = plan
        isSubscribed = plan.isPremium
        saveSubscriptionState()
    }
    #endif
}

// MARK: - Errors

enum SubscriptionError: LocalizedError {
    case productNotFound
    case verificationFailed
    case purchaseFailed
    
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Product not found"
        case .verificationFailed:
            return "Purchase verification failed"
        case .purchaseFailed:
            return "Purchase failed"
        }
    }
}

// MARK: - Feature Comparison

/// Comparison of free vs premium features
struct FeatureComparison: Identifiable {
    let id = UUID()
    let feature: String
    let freeAccess: String
    let premiumAccess: String
    let icon: String
    
    static let allFeatures: [FeatureComparison] = [
        FeatureComparison(
            feature: "Wudu Trainer",
            freeAccess: "Full",
            premiumAccess: "Full",
            icon: "drop"
        ),
        FeatureComparison(
            feature: "Salah Trainer",
            freeAccess: "Fajr only",
            premiumAccess: "All 5 prayers",
            icon: "figure.prayer"
        ),
        FeatureComparison(
            feature: "Pillars of Islam",
            freeAccess: "Intro lessons",
            premiumAccess: "Full lessons",
            icon: "building.columns"
        ),
        FeatureComparison(
            feature: "Arabic Alphabet",
            freeAccess: "First 8 letters",
            premiumAccess: "All 28 letters + tracing",
            icon: "textformat.size.ar"
        ),
        FeatureComparison(
            feature: "Qur'an Reading",
            freeAccess: "Juz Amma text",
            premiumAccess: "Full Qur'an + audio",
            icon: "book"
        ),
        FeatureComparison(
            feature: "Tajwīd",
            freeAccess: "—",
            premiumAccess: "Color overlay",
            icon: "paintpalette"
        ),
        FeatureComparison(
            feature: "Memorization Mode",
            freeAccess: "—",
            premiumAccess: "Looping & call-response",
            icon: "repeat"
        ),
        FeatureComparison(
            feature: "Kids Mode",
            freeAccess: "1 world",
            premiumAccess: "All 5 worlds",
            icon: "star"
        ),
        FeatureComparison(
            feature: "Child Profiles",
            freeAccess: "1 profile",
            premiumAccess: "Unlimited",
            icon: "person.3"
        ),
        FeatureComparison(
            feature: "Parent Dashboard",
            freeAccess: "Basic",
            premiumAccess: "Full controls",
            icon: "shield.checkered"
        ),
        FeatureComparison(
            feature: "Daily Goals",
            freeAccess: "✓",
            premiumAccess: "✓ + family goals",
            icon: "target"
        ),
        FeatureComparison(
            feature: "Offline Mode",
            freeAccess: "—",
            premiumAccess: "✓",
            icon: "arrow.down.circle"
        ),
        FeatureComparison(
            feature: "Mini Games",
            freeAccess: "Limited",
            premiumAccess: "All games",
            icon: "gamecontroller"
        ),
        FeatureComparison(
            feature: "Vocabulary Packs",
            freeAccess: "—",
            premiumAccess: "All packs",
            icon: "book.closed"
        )
    ]
}
