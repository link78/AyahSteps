import XCTest
@testable import DeenLearn

final class ChildProfileTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Clear child profiles before each test
        UserDefaults.standard.removeObject(forKey: "childProfiles")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "childProfiles")
        super.tearDown()
    }

    // MARK: - Codable Tests

    func testChildProfileEncodeDecode() throws {
        let child = ChildProfile(
            id: UUID(),
            name: "Ahmad",
            avatarEmoji: "👦",
            age: 8,
            createdAt: Date(),
            totalLearningMinutes: 100,
            currentStreak: 5,
            longestStreak: 10,
            surahsMemorized: 3,
            arabicLettersLearned: 15,
            pillarsCompleted: 2,
            prayerStepsLearned: 8,
            dailyGoalMinutes: 20,
            weeklyGoalMinutes: 140,
            todayMinutes: 10,
            weekMinutes: 60,
            screenTimeLimit: 30,
            allowedCategories: [.quran, .arabic, .pillars, .prayer],
            parentalControlsEnabled: true,
            totalStars: 50,
            totalBadges: 3,
            achievements: []
        )

        let data = try JSONEncoder().encode(child)
        let decoded = try JSONDecoder().decode(ChildProfile.self, from: data)

        XCTAssertEqual(decoded.id, child.id)
        XCTAssertEqual(decoded.name, child.name)
        XCTAssertEqual(decoded.age, child.age)
        XCTAssertEqual(decoded.avatarEmoji, child.avatarEmoji)
        XCTAssertEqual(decoded.dailyGoalMinutes, child.dailyGoalMinutes)
        XCTAssertEqual(decoded.screenTimeLimit, child.screenTimeLimit)
        XCTAssertEqual(decoded.allowedCategories, child.allowedCategories)
        XCTAssertEqual(decoded.parentalControlsEnabled, child.parentalControlsEnabled)
    }

    func testChildProfileArrayEncodeDecode() throws {
        let children = ChildProfile.sampleChildren
        let data = try JSONEncoder().encode(children)
        let decoded = try JSONDecoder().decode([ChildProfile].self, from: data)

        XCTAssertEqual(decoded.count, children.count)
        XCTAssertEqual(decoded[0].name, children[0].name)
        XCTAssertEqual(decoded[1].name, children[1].name)
    }

    // MARK: - AppState Child Profile Management Tests

    func testAddChildProfile() {
        let appState = AppState()
        XCTAssertTrue(appState.childProfiles.isEmpty, "Should start with no child profiles")

        let child = ChildProfile(
            id: UUID(),
            name: "Test Child",
            avatarEmoji: "👧",
            age: 7,
            createdAt: Date(),
            totalLearningMinutes: 0,
            currentStreak: 0,
            longestStreak: 0,
            surahsMemorized: 0,
            arabicLettersLearned: 0,
            pillarsCompleted: 0,
            prayerStepsLearned: 0,
            dailyGoalMinutes: 15,
            weeklyGoalMinutes: 105,
            todayMinutes: 0,
            weekMinutes: 0,
            screenTimeLimit: 30,
            allowedCategories: [.quran, .arabic],
            parentalControlsEnabled: true,
            totalStars: 0,
            totalBadges: 0,
            achievements: []
        )

        appState.addChildProfile(child)
        XCTAssertEqual(appState.childProfiles.count, 1)
        XCTAssertEqual(appState.childProfiles[0].name, "Test Child")
    }

    func testRemoveChildProfileById() {
        let appState = AppState()
        let childId = UUID()

        let child = ChildProfile(
            id: childId,
            name: "To Remove",
            avatarEmoji: "👦",
            age: 6,
            createdAt: Date(),
            totalLearningMinutes: 0,
            currentStreak: 0,
            longestStreak: 0,
            surahsMemorized: 0,
            arabicLettersLearned: 0,
            pillarsCompleted: 0,
            prayerStepsLearned: 0,
            dailyGoalMinutes: 15,
            weeklyGoalMinutes: 105,
            todayMinutes: 0,
            weekMinutes: 0,
            screenTimeLimit: 30,
            allowedCategories: [.quran],
            parentalControlsEnabled: true,
            totalStars: 0,
            totalBadges: 0,
            achievements: []
        )

        appState.addChildProfile(child)
        XCTAssertEqual(appState.childProfiles.count, 1)

        appState.removeChildProfile(id: childId)
        XCTAssertTrue(appState.childProfiles.isEmpty, "Should be empty after removing the child")
    }

    func testRemoveChildProfileAtOffsets() {
        let appState = AppState()

        for i in 0..<3 {
            let child = ChildProfile(
                id: UUID(),
                name: "Child \(i)",
                avatarEmoji: "👦",
                age: 6 + i,
                createdAt: Date(),
                totalLearningMinutes: 0,
                currentStreak: 0,
                longestStreak: 0,
                surahsMemorized: 0,
                arabicLettersLearned: 0,
                pillarsCompleted: 0,
                prayerStepsLearned: 0,
                dailyGoalMinutes: 15,
                weeklyGoalMinutes: 105,
                todayMinutes: 0,
                weekMinutes: 0,
                screenTimeLimit: 30,
                allowedCategories: [.quran],
                parentalControlsEnabled: true,
                totalStars: 0,
                totalBadges: 0,
                achievements: []
            )
            appState.addChildProfile(child)
        }

        XCTAssertEqual(appState.childProfiles.count, 3)

        appState.removeChildProfile(at: IndexSet(integer: 1))
        XCTAssertEqual(appState.childProfiles.count, 2)
        XCTAssertEqual(appState.childProfiles[0].name, "Child 0")
        XCTAssertEqual(appState.childProfiles[1].name, "Child 2")
    }

    func testChildProfilePersistence() {
        let childId = UUID()

        // Create AppState and add a child
        let appState1 = AppState()
        let child = ChildProfile(
            id: childId,
            name: "Persistent Child",
            avatarEmoji: "👧",
            age: 9,
            createdAt: Date(),
            totalLearningMinutes: 0,
            currentStreak: 0,
            longestStreak: 0,
            surahsMemorized: 0,
            arabicLettersLearned: 0,
            pillarsCompleted: 0,
            prayerStepsLearned: 0,
            dailyGoalMinutes: 20,
            weeklyGoalMinutes: 140,
            todayMinutes: 0,
            weekMinutes: 0,
            screenTimeLimit: 30,
            allowedCategories: [.quran, .arabic, .pillars, .prayer],
            parentalControlsEnabled: true,
            totalStars: 0,
            totalBadges: 0,
            achievements: []
        )
        appState1.addChildProfile(child)

        // Create a new AppState which should load from UserDefaults
        let appState2 = AppState()
        XCTAssertEqual(appState2.childProfiles.count, 1, "Should load persisted child profile")
        XCTAssertEqual(appState2.childProfiles[0].name, "Persistent Child")
        XCTAssertEqual(appState2.childProfiles[0].id, childId)
    }

    // MARK: - ChildProfile Computed Properties Tests

    func testDailyGoalProgress() {
        let child = ChildProfile(
            id: UUID(),
            name: "Progress Test",
            avatarEmoji: "👦",
            age: 8,
            createdAt: Date(),
            totalLearningMinutes: 0,
            currentStreak: 0,
            longestStreak: 0,
            surahsMemorized: 0,
            arabicLettersLearned: 0,
            pillarsCompleted: 0,
            prayerStepsLearned: 0,
            dailyGoalMinutes: 20,
            weeklyGoalMinutes: 140,
            todayMinutes: 10,
            weekMinutes: 50,
            screenTimeLimit: 30,
            allowedCategories: [.quran],
            parentalControlsEnabled: true,
            totalStars: 0,
            totalBadges: 0,
            achievements: []
        )

        XCTAssertEqual(child.dailyGoalProgress, 0.5, accuracy: 0.01)
        XCTAssertEqual(child.weeklyGoalProgress, 50.0 / 140.0, accuracy: 0.01)
    }

    func testDailyGoalProgressCapsAtOne() {
        let child = ChildProfile(
            id: UUID(),
            name: "Cap Test",
            avatarEmoji: "👦",
            age: 8,
            createdAt: Date(),
            totalLearningMinutes: 0,
            currentStreak: 0,
            longestStreak: 0,
            surahsMemorized: 0,
            arabicLettersLearned: 0,
            pillarsCompleted: 0,
            prayerStepsLearned: 0,
            dailyGoalMinutes: 10,
            weeklyGoalMinutes: 70,
            todayMinutes: 30,
            weekMinutes: 100,
            screenTimeLimit: 30,
            allowedCategories: [.quran],
            parentalControlsEnabled: true,
            totalStars: 0,
            totalBadges: 0,
            achievements: []
        )

        XCTAssertEqual(child.dailyGoalProgress, 1.0, accuracy: 0.01)
        XCTAssertEqual(child.weeklyGoalProgress, 1.0, accuracy: 0.01)
    }
}
