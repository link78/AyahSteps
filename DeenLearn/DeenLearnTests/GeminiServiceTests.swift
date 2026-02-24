import XCTest
@testable import DeenLearn

final class GeminiServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Ensure clean state before each test
        UserDefaults.standard.removeObject(forKey: "geminiAPIKey")
        GeminiService.shared.configure(apiKey: "")
    }

    override func tearDown() {
        // Clean up after each test
        UserDefaults.standard.removeObject(forKey: "geminiAPIKey")
        GeminiService.shared.configure(apiKey: "")
        super.tearDown()
    }

    // MARK: - Configuration Tests

    func testServiceNotConfiguredWithEmptyKey() {
        GeminiService.shared.configure(apiKey: "")
        XCTAssertFalse(GeminiService.shared.isConfigured, "Service should not be configured with empty API key")
    }

    func testConfigureWithValidKey() {
        GeminiService.shared.configure(apiKey: "test-api-key-123")
        XCTAssertTrue(GeminiService.shared.isConfigured, "Service should be configured after setting a valid API key")
    }

    func testConfigureWithEmptyKey() {
        GeminiService.shared.configure(apiKey: "")
        XCTAssertFalse(GeminiService.shared.isConfigured, "Service should not be configured with empty key")
    }

    func testAPIKeySavedToUserDefaults() {
        let testKey = "test-key-for-persistence"
        GeminiService.shared.configure(apiKey: testKey)

        let savedKey = UserDefaults.standard.string(forKey: "geminiAPIKey")
        XCTAssertEqual(savedKey, testKey, "API key should be persisted to UserDefaults")
    }

    // MARK: - Error Handling Tests

    func testGenerateContentThrowsWhenNotConfigured() async {
        do {
            _ = try await GeminiService.shared.generateContent(prompt: "Test question")
            XCTFail("Should throw notConfigured error")
        } catch let error as GeminiService.GeminiError {
            switch error {
            case .notConfigured:
                // Expected
                break
            default:
                XCTFail("Expected notConfigured error, got \(error)")
            }
        } catch {
            XCTFail("Expected GeminiError, got \(error)")
        }
    }

    func testGenerateIslamicResponseThrowsWhenNotConfigured() async {
        do {
            _ = try await GeminiService.shared.generateIslamicResponse(
                question: "What are the pillars of Islam?",
                topic: "Pillars of Islam",
                isKidsMode: true
            )
            XCTFail("Should throw notConfigured error")
        } catch let error as GeminiService.GeminiError {
            switch error {
            case .notConfigured:
                // Expected
                break
            default:
                XCTFail("Expected notConfigured error, got \(error)")
            }
        } catch {
            XCTFail("Expected GeminiError, got \(error)")
        }
    }

    // MARK: - Error Description Tests

    func testErrorDescriptions() {
        let errors: [(GeminiService.GeminiError, String)] = [
            (.notConfigured, "Gemini API is not configured. Please add your API key in Settings."),
            (.invalidURL, "Invalid API URL."),
            (.invalidResponse, "Invalid response from server."),
            (.httpError(500), "Server returned error code: 500"),
            (.apiError("Rate limit exceeded"), "API error: Rate limit exceeded"),
            (.noContent, "No content in response.")
        ]

        for (error, expectedDescription) in errors {
            XCTAssertEqual(
                error.errorDescription, expectedDescription,
                "Error description mismatch for \(error)"
            )
        }
    }
}
