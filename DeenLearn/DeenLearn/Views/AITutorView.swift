import SwiftUI

// MARK: - AI Tutor View
struct AITutorView: View {
    @StateObject private var tutorService = AITutorService.shared
    @State private var userInput = ""
    @State private var selectedTopic: AITutorService.Topic = .general
    @Environment(\.dismiss) private var dismiss
    
    let isKidsMode: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            // Welcome Message
                            welcomeMessage
                            
                            // Conversation History
                            ForEach(tutorService.conversationHistory) { message in
                                ChatBubble(message: message, isKidsMode: isKidsMode)
                                    .id(message.id)
                            }
                            
                            // Loading indicator
                            if tutorService.isProcessing {
                                HStack {
                                    ProgressView()
                                        .padding(.horizontal)
                                    Text(isKidsMode ? "Thinking... 🤔" : "Processing...")
                                        .font(isKidsMode ? .headline : .subheadline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: tutorService.conversationHistory.count) { _, _ in
                        if let lastMessage = tutorService.conversationHistory.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Topic Selector
                topicSelector
                
                // Input Area
                inputArea
            }
            .navigationTitle(isKidsMode ? "🤖 Ask Me!" : "AI Islamic Tutor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { tutorService.clearConversation() }) {
                        Image(systemName: "trash")
                    }
                    .disabled(tutorService.conversationHistory.isEmpty)
                }
            }
        }
    }
    
    // MARK: - Welcome Message
    private var welcomeMessage: some View {
        VStack(spacing: 8) {
            if isKidsMode {
                Text("🤖")
                    .font(.system(size: 60))
                
                Text("Assalamu Alaikum!")
                    .font(.title2.bold())
                
                Text("I'm your Islamic learning buddy! Ask me anything about Islam and I'll help you learn! 🌟")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                
                Text("AI Islamic Tutor")
                    .font(.headline)
                
                Text("Ask questions about Islamic knowledge. Responses are for educational purposes. For religious rulings (fatwa), consult qualified scholars.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5)
        )
    }
    
    // MARK: - Topic Selector
    private var topicSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AITutorService.Topic.allCases, id: \.self) { topic in
                    Button {
                        selectedTopic = topic
                    } label: {
                        Text(topicLabel(for: topic))
                            .font(isKidsMode ? .caption.bold() : .caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(selectedTopic == topic ? Color.green : Color(.systemGray5))
                            )
                            .foregroundColor(selectedTopic == topic ? .white : .primary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    private func topicLabel(for topic: AITutorService.Topic) -> String {
        if isKidsMode {
            switch topic {
            case .pillars: return "🏛️ Pillars"
            case .salah: return "🕌 Prayer"
            case .quran: return "📖 Qur'an"
            case .arabic: return "🔤 Arabic"
            case .prophets: return "⭐ Prophets"
            case .manners: return "😊 Manners"
            case .general: return "🌟 General"
            }
        }
        return topic.rawValue
    }
    
    // MARK: - Input Area
    private var inputArea: some View {
        HStack(spacing: 12) {
            TextField(isKidsMode ? "Ask me anything! 🌟" : "Type your question...", text: $userInput)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.send)
                .onSubmit(sendMessage)
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(userInput.isEmpty ? Color.gray : Color.green))
            }
            .disabled(userInput.isEmpty || tutorService.isProcessing)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    // MARK: - Send Message
    private func sendMessage() {
        guard !userInput.isEmpty else { return }
        let question = userInput
        userInput = ""
        
        Task {
            _ = await tutorService.getResponse(for: question, topic: selectedTopic, isKidsMode: isKidsMode)
        }
    }
}

// MARK: - Chat Bubble
struct ChatBubble: View {
    let message: AITutorService.ChatMessage
    let isKidsMode: Bool
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(isKidsMode ? .body : .subheadline)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(message.isUser ? Color.green : Color(.systemGray5))
                    )
                    .foregroundColor(message.isUser ? .white : .primary)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser { Spacer() }
        }
    }
}

// MARK: - Preview
#Preview {
    AITutorView(isKidsMode: true)
}
