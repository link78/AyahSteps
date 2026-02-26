import Foundation
import AVFoundation

// MARK: - Gemini TTS Service

/// Service that uses Google's Gemini AI to generate natural-sounding speech from text.
/// Uses the Gemini 2.5 Flash Preview TTS model for high-quality voice synthesis.
/// Falls back gracefully when the API key is not configured.
class GeminiTTSService {
    static let shared = GeminiTTSService()

    private let session: URLSession
    private var apiKey: String = ""
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-tts:generateContent"

    var isConfigured: Bool { !apiKey.isEmpty }

    /// The bundled API key, read from Info.plist under the "GeminiAPIKey" key.
    private static var bundledAPIKey: String {
        Bundle.main.object(forInfoDictionaryKey: "GeminiAPIKey") as? String ?? ""
    }

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: config)
        loadBundledKey()
    }

    /// Configure the service with a Gemini API key (used for testing)
    func configure(apiKey: String) {
        self.apiKey = apiKey
        // No isConfigured published property needed — computed from apiKey
    }

    private func loadBundledKey() {
        let key = GeminiTTSService.bundledAPIKey
        if !key.isEmpty {
            self.apiKey = key
        }
    }

    // MARK: - TTS Request/Response Models

    private struct TTSRequest: Encodable {
        let contents: [Content]
        let generationConfig: GenerationConfig

        struct Content: Encodable {
            let parts: [Part]
            let role: String
        }

        struct Part: Encodable {
            let text: String
        }

        struct GenerationConfig: Encodable {
            let responseModalities: [String]
            let speechConfig: SpeechConfig
        }

        struct SpeechConfig: Encodable {
            let voiceConfig: VoiceConfig
        }

        struct VoiceConfig: Encodable {
            let prebuiltVoiceConfig: PrebuiltVoiceConfig
        }

        struct PrebuiltVoiceConfig: Encodable {
            let voiceName: String
        }
    }

    private struct TTSResponse: Decodable {
        let candidates: [Candidate]?

        struct Candidate: Decodable {
            let content: Content?
        }

        struct Content: Decodable {
            let parts: [Part]?
        }

        struct Part: Decodable {
            let inlineData: InlineData?
        }

        struct InlineData: Decodable {
            let mimeType: String?
            let data: String? // base64 encoded audio
        }
    }

    // MARK: - Speech Synthesis

    /// Generate speech audio from text using Gemini AI
    /// - Parameters:
    ///   - text: The text to synthesize as speech
    ///   - language: Language code (e.g., "en-US", "ar-SA")
    /// - Returns: WAV audio data ready for playback
    func synthesizeSpeech(text: String, language: String = "en-US") async throws -> Data {
        guard isConfigured else {
            throw TTSError.notConfigured
        }

        // Select appropriate voice for the language
        let voiceName = language.hasPrefix("ar") ? "Orus" : "Kore"

        let request = TTSRequest(
            contents: [TTSRequest.Content(
                parts: [TTSRequest.Part(text: text)],
                role: "user"
            )],
            generationConfig: TTSRequest.GenerationConfig(
                responseModalities: ["AUDIO"],
                speechConfig: TTSRequest.SpeechConfig(
                    voiceConfig: TTSRequest.VoiceConfig(
                        prebuiltVoiceConfig: TTSRequest.PrebuiltVoiceConfig(
                            voiceName: voiceName
                        )
                    )
                )
            )
        )

        guard let url = URL(string: baseURL) else {
            throw TTSError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw TTSError.apiError("Invalid response")
        }

        guard httpResponse.statusCode == 200 else {
            throw TTSError.httpError(httpResponse.statusCode)
        }

        let ttsResponse = try JSONDecoder().decode(TTSResponse.self, from: data)

        guard let base64Audio = ttsResponse.candidates?.first?.content?.parts?.first?.inlineData?.data,
              let audioData = Data(base64Encoded: base64Audio) else {
            throw TTSError.noAudioData
        }

        // Convert raw PCM to WAV format for AVAudioPlayer
        return addWAVHeader(to: audioData, sampleRate: 24000, bitsPerSample: 16, channels: 1)
    }

    // MARK: - WAV Header

    /// Add a WAV header to raw PCM audio data so it can be played by AVAudioPlayer
    private func addWAVHeader(to pcmData: Data, sampleRate: Int, bitsPerSample: Int, channels: Int) -> Data {
        let byteRate = sampleRate * channels * (bitsPerSample / 8)
        let blockAlign = channels * (bitsPerSample / 8)
        let dataSize = pcmData.count
        let fileSize = 36 + dataSize

        var header = Data()

        // RIFF header
        header.append(contentsOf: [UInt8]("RIFF".utf8))
        header.append(contentsOf: withUnsafeBytes(of: UInt32(fileSize).littleEndian) { Array($0) })
        header.append(contentsOf: [UInt8]("WAVE".utf8))

        // fmt sub-chunk
        header.append(contentsOf: [UInt8]("fmt ".utf8))
        header.append(contentsOf: withUnsafeBytes(of: UInt32(16).littleEndian) { Array($0) })        // Sub-chunk size
        header.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Array($0) })         // PCM format
        header.append(contentsOf: withUnsafeBytes(of: UInt16(channels).littleEndian) { Array($0) })  // Channels
        header.append(contentsOf: withUnsafeBytes(of: UInt32(sampleRate).littleEndian) { Array($0) }) // Sample rate
        header.append(contentsOf: withUnsafeBytes(of: UInt32(byteRate).littleEndian) { Array($0) })  // Byte rate
        header.append(contentsOf: withUnsafeBytes(of: UInt16(blockAlign).littleEndian) { Array($0) }) // Block align
        header.append(contentsOf: withUnsafeBytes(of: UInt16(bitsPerSample).littleEndian) { Array($0) }) // Bits per sample

        // data sub-chunk
        header.append(contentsOf: [UInt8]("data".utf8))
        header.append(contentsOf: withUnsafeBytes(of: UInt32(dataSize).littleEndian) { Array($0) })

        header.append(pcmData)
        return header
    }

    // MARK: - Error Types

    enum TTSError: LocalizedError {
        case notConfigured
        case invalidURL
        case httpError(Int)
        case apiError(String)
        case noAudioData

        var errorDescription: String? {
            switch self {
            case .notConfigured:
                return "Gemini TTS is not configured. API key is missing."
            case .invalidURL:
                return "Invalid TTS API URL."
            case .httpError(let code):
                return "TTS server returned error code: \(code)"
            case .apiError(let message):
                return "TTS API error: \(message)"
            case .noAudioData:
                return "No audio data in response."
            }
        }
    }
}
