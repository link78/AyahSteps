import XCTest
@testable import DeenLearn

final class ProfileManagementTests: XCTestCase {

    var appState: AppState!

    override func setUp() {
        super.setUp()
        // Clear any persisted child profiles before each test
        UserDefaults.standard.removeObject(forKey: "childProfiles")
        UserDefaults.standard.removeObject(forKey: "activeChildProfileId")
        appState = AppState()
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "childProfiles")
        UserDefaults.standard.removeObject(forKey: "activeChildProfileId")
        appState = nil
        super.tearDown()
    }

    // MARK: - Add Child Profile Tests

    func testAddChildProfile() {
        let child = makeChildProfile(name: "Ahmad", age: 8)
        appState.addChildProfile(child)

        XCTAssertEqual(appState.childProfiles.count, 1)
        XCTAssertEqual(appState.childProfiles.first?.name, "Ahmad")
        XCTAssertEqual(appState.childProfiles.first?.age, 8)
    }

    func testAddMultipleChildProfiles() {
        appState.addChildProfile(makeChildProfile(name: "Ahmad", age: 8))
        appState.addChildProfile(makeChildProfile(name: "Fatima", age: 6))

        XCTAssertEqual(appState.childProfiles.count, 2)
    }

    // MARK: - Remove Child Profile Tests

    func testRemoveChildProfile() {
        let child = makeChildProfile(name: "Ahmad", age: 8)
        appState.addChildProfile(child)

        appState.removeChildProfile(id: child.id)
        XCTAssertEqual(appState.childProfiles.count, 0)
    }

    func testRemoveActiveChildProfileResetsActiveId() {
        let child = makeChildProfile(name: "Ahmad", age: 8)
        appState.addChildProfile(child)
        appState.switchToChildProfile(id: child.id)

        XCTAssertNotNil(appState.activeChildProfileId)

        appState.removeChildProfile(id: child.id)
        XCTAssertNil(appState.activeChildProfileId)
        XCTAssertFalse(appState.isChildProfileActive)
    }

    // MARK: - Profile Switching Tests

    func testSwitchToChildProfile() {
        let child = makeChildProfile(name: "Ahmad", age: 8)
        appState.addChildProfile(child)

        appState.switchToChildProfile(id: child.id)

        XCTAssertEqual(appState.activeChildProfileId, child.id)
        XCTAssertTrue(appState.isChildProfileActive)
        XCTAssertEqual(appState.activeChildProfile?.name, "Ahmad")
    }

    func testSwitchToParentProfile() {
        let child = makeChildProfile(name: "Ahmad", age: 8)
        appState.addChildProfile(child)
        appState.switchToChildProfile(id: child.id)

        appState.switchToParentProfile()

        XCTAssertNil(appState.activeChildProfileId)
        XCTAssertFalse(appState.isChildProfileActive)
        XCTAssertNil(appState.activeChildProfile)
    }

    func testSwitchToNonExistentChildProfileDoesNothing() {
        let fakeId = UUID()
        appState.switchToChildProfile(id: fakeId)

        XCTAssertNil(appState.activeChildProfileId)
    }

    func testNoActiveChildProfileByDefault() {
        XCTAssertNil(appState.activeChildProfileId)
        XCTAssertNil(appState.activeChildProfile)
        XCTAssertFalse(appState.isChildProfileActive)
    }

    // MARK: - Persistence Tests

    func testChildProfilesPersistAcrossInstances() {
        let child = makeChildProfile(name: "Ahmad", age: 8)
        appState.addChildProfile(child)

        // Create a new AppState instance that should load from UserDefaults
        let newAppState = AppState()

        XCTAssertEqual(newAppState.childProfiles.count, 1)
        XCTAssertEqual(newAppState.childProfiles.first?.name, "Ahmad")
    }

    func testActiveChildProfileIdPersists() {
        let child = makeChildProfile(name: "Ahmad", age: 8)
        appState.addChildProfile(child)
        appState.switchToChildProfile(id: child.id)

        let newAppState = AppState()

        XCTAssertEqual(newAppState.activeChildProfileId, child.id)
    }

    // MARK: - Codable Tests

    func testChildProfileEncodeDecode() throws {
        let child = makeChildProfile(name: "Ahmad", age: 8)

        let data = try JSONEncoder().encode(child)
        let decoded = try JSONDecoder().decode(ChildProfile.self, from: data)

        XCTAssertEqual(decoded.id, child.id)
        XCTAssertEqual(decoded.name, child.name)
        XCTAssertEqual(decoded.age, child.age)
        XCTAssertEqual(decoded.avatarEmoji, child.avatarEmoji)
        XCTAssertEqual(decoded.dailyGoalMinutes, child.dailyGoalMinutes)
    }

    // MARK: - Helpers

    private func makeChildProfile(name: String, age: Int) -> ChildProfile {
        ChildProfile(
            id: UUID(),
            name: name,
            avatarEmoji: "👦",
            age: age,
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
            allowedCategories: [.quran, .arabic, .pillars, .prayer],
            parentalControlsEnabled: true,
            totalStars: 0,
            totalBadges: 0,
            achievements: []
        )
    }
}
