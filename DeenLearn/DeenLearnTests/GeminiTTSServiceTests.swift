import XCTest
@testable import DeenLearn

final class GeminiTTSServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        GeminiTTSService.shared.configure(apiKey: "")
    }

    override func tearDown() {
        GeminiTTSService.shared.configure(apiKey: "")
        super.tearDown()
    }

    // MARK: - Configuration Tests

    func testServiceNotConfiguredWithEmptyKey() {
        GeminiTTSService.shared.configure(apiKey: "")
        XCTAssertFalse(GeminiTTSService.shared.isConfigured, "Service should not be configured with empty API key")
    }

    func testConfigureWithValidKey() {
        GeminiTTSService.shared.configure(apiKey: "test-api-key-123")
        XCTAssertTrue(GeminiTTSService.shared.isConfigured, "Service should be configured after setting a valid API key")
    }

    func testConfigureWithEmptyKey() {
        GeminiTTSService.shared.configure(apiKey: "")
        XCTAssertFalse(GeminiTTSService.shared.isConfigured, "Service should not be configured with empty key")
    }

    // MARK: - Error Handling Tests

    func testSynthesizeSpeechThrowsWhenNotConfigured() async {
        do {
            _ = try await GeminiTTSService.shared.synthesizeSpeech(text: "Hello")
            XCTFail("Should throw notConfigured error")
        } catch let error as GeminiTTSService.TTSError {
            switch error {
            case .notConfigured:
                // Expected
                break
            default:
                XCTFail("Expected notConfigured error, got \(error)")
            }
        } catch {
            XCTFail("Expected TTSError, got \(error)")
        }
    }

    func testSynthesizeSpeechWithArabicThrowsWhenNotConfigured() async {
        do {
            _ = try await GeminiTTSService.shared.synthesizeSpeech(text: "بسم الله", language: "ar-SA")
            XCTFail("Should throw notConfigured error")
        } catch let error as GeminiTTSService.TTSError {
            switch error {
            case .notConfigured:
                // Expected
                break
            default:
                XCTFail("Expected notConfigured error, got \(error)")
            }
        } catch {
            XCTFail("Expected TTSError, got \(error)")
        }
    }

    // MARK: - Error Description Tests

    func testErrorDescriptions() {
        let errors: [(GeminiTTSService.TTSError, String)] = [
            (.notConfigured, "Gemini TTS is not configured. API key is missing."),
            (.invalidURL, "Invalid TTS API URL."),
            (.httpError(500), "TTS server returned error code: 500"),
            (.apiError("Rate limit exceeded"), "TTS API error: Rate limit exceeded"),
            (.noAudioData, "No audio data in response.")
        ]

        for (error, expectedDescription) in errors {
            XCTAssertEqual(
                error.errorDescription, expectedDescription,
                "Error description mismatch for \(error)"
            )
        }
    }
}
