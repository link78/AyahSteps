import XCTest
@testable import DeenLearn

final class AITutorServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Ensure Gemini is not configured so fallback path is used by default
        GeminiService.shared.configure(apiKey: "")
        AITutorService.shared.clearConversation()
    }

    override func tearDown() {
        // Clean up shared state
        AITutorService.shared.clearConversation()
        GeminiService.shared.configure(apiKey: "")
        super.tearDown()
    }

    // MARK: - Conversation Management Tests

    func testClearConversation() {
        XCTAssertTrue(AITutorService.shared.conversationHistory.isEmpty, "Conversation history should be empty after clearing")
    }

    // MARK: - Topic Enumeration Tests

    func testAllTopicsExist() {
        let topics = AITutorService.Topic.allCases
        XCTAssertEqual(topics.count, 7, "Should have 7 topic categories")
        XCTAssertTrue(topics.contains(.pillars))
        XCTAssertTrue(topics.contains(.salah))
        XCTAssertTrue(topics.contains(.quran))
        XCTAssertTrue(topics.contains(.arabic))
        XCTAssertTrue(topics.contains(.prophets))
        XCTAssertTrue(topics.contains(.manners))
        XCTAssertTrue(topics.contains(.general))
    }

    func testTopicRawValues() {
        XCTAssertEqual(AITutorService.Topic.pillars.rawValue, "Pillars of Islam")
        XCTAssertEqual(AITutorService.Topic.salah.rawValue, "Prayer (Salah)")
        XCTAssertEqual(AITutorService.Topic.quran.rawValue, "Qur'an")
        XCTAssertEqual(AITutorService.Topic.arabic.rawValue, "Arabic Language")
        XCTAssertEqual(AITutorService.Topic.prophets.rawValue, "Prophets & Stories")
        XCTAssertEqual(AITutorService.Topic.manners.rawValue, "Islamic Manners")
        XCTAssertEqual(AITutorService.Topic.general.rawValue, "General")
    }

    // MARK: - Fallback Response Tests (when Gemini is not configured)

    func testFallbackResponseForKidsSalah() async {
        let response = await AITutorService.shared.getResponse(for: "Tell me about salah", topic: .salah, isKidsMode: true)

        XCTAssertFalse(response.isEmpty, "Response should not be empty")
        XCTAssertTrue(response.contains("🕌") || response.contains("Salah") || response.contains("prayer"),
                      "Kids salah response should mention prayer-related content")
    }

    func testFallbackResponseForAdultSalah() async {
        let response = await AITutorService.shared.getResponse(for: "Tell me about salah", topic: .salah, isKidsMode: false)

        XCTAssertFalse(response.isEmpty, "Response should not be empty")
        XCTAssertTrue(response.contains("Salah") || response.contains("prayer") || response.contains("rak"),
                      "Adult salah response should mention prayer-related content")
    }

    func testFallbackResponseForKidsPillars() async {
        let response = await AITutorService.shared.getResponse(for: "What is the shahada?", topic: .pillars, isKidsMode: true)

        XCTAssertFalse(response.isEmpty, "Response should not be empty")
        XCTAssertTrue(response.contains("Shahada") || response.contains("promise") || response.contains("Allah"),
                      "Kids shahada response should contain relevant content")
    }

    func testFallbackResponseForAdultPillars() async {
        let response = await AITutorService.shared.getResponse(for: "Explain the shahada", topic: .pillars, isKidsMode: false)

        XCTAssertFalse(response.isEmpty, "Response should not be empty")
        XCTAssertTrue(response.contains("Shahada") || response.contains("declaration") || response.contains("Tawhid"),
                      "Adult shahada response should contain scholarly content")
    }

    func testFallbackDefaultResponse() async {
        let response = await AITutorService.shared.getResponse(for: "Tell me something unique", topic: .general, isKidsMode: true)

        XCTAssertFalse(response.isEmpty, "Default response should not be empty")
    }

    // MARK: - Conversation History Tests

    func testConversationHistoryAddsMessages() async {
        _ = await AITutorService.shared.getResponse(for: "Test question", topic: .general, isKidsMode: true)

        // Should have both user message and AI response
        XCTAssertEqual(AITutorService.shared.conversationHistory.count, 2, "Should have user message and AI response")
        XCTAssertTrue(AITutorService.shared.conversationHistory[0].isUser, "First message should be from user")
        XCTAssertFalse(AITutorService.shared.conversationHistory[1].isUser, "Second message should be from AI")
        XCTAssertEqual(AITutorService.shared.conversationHistory[0].content, "Test question")
    }

    func testMultipleConversationMessages() async {
        _ = await AITutorService.shared.getResponse(for: "First question", topic: .general, isKidsMode: true)
        _ = await AITutorService.shared.getResponse(for: "Second question", topic: .pillars, isKidsMode: true)

        XCTAssertEqual(AITutorService.shared.conversationHistory.count, 4, "Should have 4 messages (2 Q&A pairs)")
    }

    // MARK: - Processing State Tests

    func testProcessingStateAfterResponse() async {
        _ = await AITutorService.shared.getResponse(for: "Test", topic: .general, isKidsMode: true)

        XCTAssertFalse(AITutorService.shared.isProcessing, "Should not be processing after response completes")
    }

    // MARK: - Gemini Integration Path Test

    func testGeminiPathIsUsedWhenConfigured() async {
        // Configure with an invalid key to test the Gemini path is attempted
        // and falls back gracefully
        GeminiService.shared.configure(apiKey: "invalid-test-key")

        let response = await AITutorService.shared.getResponse(for: "What is salah?", topic: .salah, isKidsMode: true)

        // Even with an invalid key, we should get a fallback response
        XCTAssertFalse(response.isEmpty, "Should get a fallback response when Gemini fails")
        XCTAssertEqual(AITutorService.shared.conversationHistory.count, 2, "Should still have Q&A pair")
    }
}
