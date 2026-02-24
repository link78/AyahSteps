import Foundation

// MARK: - Gemini AI Service
/// Integrates Google's Gemini AI API for advanced natural language processing
/// capabilities in Islamic education
class GeminiService: ObservableObject {
    static let shared = GeminiService()

    @Published var isConfigured = false

    private var apiKey: String = ""
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
        loadAPIKey()
    }

    // MARK: - Configuration

    /// Configure the service with a Gemini API key
    func configure(apiKey: String) {
        self.apiKey = apiKey
        self.isConfigured = !apiKey.isEmpty
        saveAPIKey(apiKey)
    }

    private func saveAPIKey(_ key: String) {
        UserDefaults.standard.set(key, forKey: "geminiAPIKey")
    }

    private func loadAPIKey() {
        if let key = UserDefaults.standard.string(forKey: "geminiAPIKey"), !key.isEmpty {
            self.apiKey = key
            self.isConfigured = true
        }
    }

    // MARK: - API Request Models

    private struct GeminiRequest: Encodable {
        let contents: [Content]
        let generationConfig: GenerationConfig?
        let safetySettings: [SafetySetting]?

        struct Content: Encodable {
            let parts: [Part]
            let role: String?
        }

        struct Part: Encodable {
            let text: String
        }

        struct GenerationConfig: Encodable {
            let temperature: Double?
            let topK: Int?
            let topP: Double?
            let maxOutputTokens: Int?
        }

        struct SafetySetting: Encodable {
            let category: String
            let threshold: String
        }
    }

    // MARK: - API Response Models

    private struct GeminiResponse: Decodable {
        let candidates: [Candidate]?
        let error: GeminiError?

        struct Candidate: Decodable {
            let content: Content?
        }

        struct Content: Decodable {
            let parts: [Part]?
        }

        struct Part: Decodable {
            let text: String?
        }

        struct GeminiError: Decodable {
            let message: String?
            let code: Int?
        }
    }

    // MARK: - Generate Content

    /// Generate a response from the Gemini API
    /// - Parameters:
    ///   - prompt: The user's prompt/question
    ///   - systemInstruction: Optional system instruction for context
    /// - Returns: The generated text response
    func generateContent(prompt: String, systemInstruction: String? = nil) async throws -> String {
        guard isConfigured else {
            throw GeminiError.notConfigured
        }

        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            throw GeminiError.invalidURL
        }

        var contents: [GeminiRequest.Content] = []

        // Add system instruction as the first user message if provided
        if let systemInstruction = systemInstruction {
            contents.append(GeminiRequest.Content(
                parts: [GeminiRequest.Part(text: systemInstruction)],
                role: "user"
            ))
            contents.append(GeminiRequest.Content(
                parts: [GeminiRequest.Part(text: "Understood. I will follow these instructions.")],
                role: "model"
            ))
        }

        // Add the user's prompt
        contents.append(GeminiRequest.Content(
            parts: [GeminiRequest.Part(text: prompt)],
            role: "user"
        ))

        let request = GeminiRequest(
            contents: contents,
            generationConfig: GeminiRequest.GenerationConfig(
                temperature: 0.7,
                topK: 40,
                topP: 0.95,
                maxOutputTokens: 1024
            ),
            safetySettings: [
                GeminiRequest.SafetySetting(
                    category: "HARM_CATEGORY_HARASSMENT",
                    threshold: "BLOCK_MEDIUM_AND_ABOVE"
                ),
                GeminiRequest.SafetySetting(
                    category: "HARM_CATEGORY_HATE_SPEECH",
                    threshold: "BLOCK_MEDIUM_AND_ABOVE"
                ),
                GeminiRequest.SafetySetting(
                    category: "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                    threshold: "BLOCK_MEDIUM_AND_ABOVE"
                ),
                GeminiRequest.SafetySetting(
                    category: "HARM_CATEGORY_DANGEROUS_CONTENT",
                    threshold: "BLOCK_MEDIUM_AND_ABOVE"
                )
            ]
        )

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            if let errorResponse = try? JSONDecoder().decode(GeminiResponse.self, from: data),
               let errorMessage = errorResponse.error?.message {
                throw GeminiError.apiError(errorMessage)
            }
            throw GeminiError.httpError(httpResponse.statusCode)
        }

        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)

        guard let text = geminiResponse.candidates?.first?.content?.parts?.first?.text else {
            throw GeminiError.noContent
        }

        return text
    }

    // MARK: - Islamic Education Helpers

    /// Generate an Islamic education response with appropriate context
    func generateIslamicResponse(
        question: String,
        topic: String,
        isKidsMode: Bool
    ) async throws -> String {
        let systemInstruction: String

        if isKidsMode {
            systemInstruction = """
            You are a friendly Islamic education assistant for children. Follow these guidelines:
            - Use simple, age-appropriate language that children can understand
            - Include relevant emojis to make responses engaging and fun
            - Keep responses concise (2-4 paragraphs maximum)
            - Always be encouraging and positive
            - Reference Qur'an and Hadith in simple terms when relevant
            - Focus on the topic: \(topic)
            - Never provide content inappropriate for children
            - Use analogies and examples children can relate to
            - If unsure about an Islamic ruling, say "Ask your parents or teacher for more details!"
            """
        } else {
            systemInstruction = """
            You are a knowledgeable Islamic education assistant. Follow these guidelines:
            - Provide accurate Islamic knowledge with scholarly references when possible
            - Reference relevant Qur'an verses and authentic Hadith
            - Keep responses informative but concise (3-5 paragraphs maximum)
            - Present information in a balanced manner, noting different scholarly opinions when relevant
            - Focus on the topic: \(topic)
            - For specific religious rulings (fatwa), advise consulting qualified scholars
            - Use proper Arabic transliteration with diacritical marks when appropriate
            - Maintain a respectful and educational tone
            """
        }

        return try await generateContent(
            prompt: question,
            systemInstruction: systemInstruction
        )
    }

    // MARK: - Error Types

    enum GeminiError: LocalizedError {
        case notConfigured
        case invalidURL
        case invalidResponse
        case httpError(Int)
        case apiError(String)
        case noContent

        var errorDescription: String? {
            switch self {
            case .notConfigured:
                return "Gemini API is not configured. Please add your API key in Settings."
            case .invalidURL:
                return "Invalid API URL."
            case .invalidResponse:
                return "Invalid response from server."
            case .httpError(let code):
                return "Server returned error code: \(code)"
            case .apiError(let message):
                return "API error: \(message)"
            case .noContent:
                return "No content in response."
            }
        }
    }
}
