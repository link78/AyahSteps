import SwiftUI

// MARK: - AI Quran Coach View
struct AIQuranCoachView: View {
    @StateObject private var coachService = AIQuranCoachService.shared
    @State private var selectedSurah = "Al-Fatihah"
    @State private var selectedAyah = 1
    @State private var isRecording = false
    @State private var showFeedback = false
    @Environment(\.dismiss) private var dismiss
    
    let isKidsMode: Bool
    
    let surahs = ["Al-Fatihah", "Al-Ikhlas", "Al-Falaq", "Al-Nas", "Al-Kawthar", "Al-Asr"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    headerCard
                    
                    // Surah Selector
                    surahSelector
                    
                    // Recording Section
                    recordingSection
                    
                    // Feedback Section
                    if let feedback = coachService.lastFeedback {
                        feedbackSection(feedback)
                    }
                    
                    // Tajweed Rules Section
                    tajweedRulesSection
                }
                .padding()
            }
            .navigationTitle(isKidsMode ? "🎤 Qur'an Coach" : "AI Recitation Coach")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Header Card
    private var headerCard: some View {
        VStack(spacing: 12) {
            if isKidsMode {
                Text("🎤")
                    .font(.system(size: 50))
                
                Text("Practice Your Recitation!")
                    .font(.title2.bold())
                
                Text("I'll listen to you read the Qur'an and help you get better! 🌟")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.purple)
                
                Text("AI Recitation Analysis")
                    .font(.headline)
                
                Text("Practice your Qur'an recitation and receive AI-powered feedback on pronunciation and tajweed.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5)
        )
    }
    
    // MARK: - Surah Selector
    private var surahSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(isKidsMode ? "📖 Choose a Surah:" : "Select Surah")
                .font(isKidsMode ? .headline : .subheadline)
                .fontWeight(.semibold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(surahs, id: \.self) { surah in
                        Button {
                            selectedSurah = surah
                        } label: {
                            VStack(spacing: 4) {
                                Text(surahEmoji(for: surah))
                                    .font(.title2)
                                Text(surah)
                                    .font(isKidsMode ? .caption.bold() : .caption)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedSurah == surah ? Color.purple.opacity(0.2) : Color(.systemGray6))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedSurah == surah ? Color.purple : Color.clear, lineWidth: 2)
                                    )
                            )
                            .foregroundColor(selectedSurah == surah ? .purple : .primary)
                        }
                    }
                }
            }
        }
    }
    
    private func surahEmoji(for surah: String) -> String {
        switch surah {
        case "Al-Fatihah": return "🌟"
        case "Al-Ikhlas": return "💎"
        case "Al-Falaq": return "🌅"
        case "Al-Nas": return "👥"
        case "Al-Kawthar": return "💧"
        case "Al-Asr": return "⏰"
        default: return "📖"
        }
    }
    
    // MARK: - Recording Section
    private var recordingSection: some View {
        VStack(spacing: 16) {
            Text(isKidsMode ? "🎙️ Tap to Start Recording!" : "Record Your Recitation")
                .font(isKidsMode ? .headline : .subheadline)
            
            Button {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(isRecording ? Color.red : Color.purple)
                        .frame(width: 80, height: 80)
                    
                    if isRecording {
                        Circle()
                            .stroke(Color.red.opacity(0.5), lineWidth: 4)
                            .frame(width: 100, height: 100)
                            .scaleEffect(isRecording ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isRecording)
                    }
                    
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            
            Text(isRecording 
                 ? (isKidsMode ? "🔴 Recording... Tap to stop!" : "Recording... Tap to stop")
                 : (isKidsMode ? "Tap the microphone to begin! 🎤" : "Tap to start recording"))
                .font(.caption)
                .foregroundColor(.secondary)
            
            if coachService.isAnalyzing {
                HStack {
                    ProgressView()
                    Text(isKidsMode ? "Checking your recitation... 🤔" : "Analyzing...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5)
        )
    }
    
    // MARK: - Feedback Section
    private func feedbackSection(_ feedback: AIQuranCoachService.RecitationFeedback) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(isKidsMode ? "📊 Your Results!" : "Feedback")
                .font(.headline)
            
            // Scores
            HStack(spacing: 20) {
                scoreCircle(score: feedback.overallScore, label: isKidsMode ? "⭐ Overall" : "Overall", color: .green)
                scoreCircle(score: feedback.pronunciationScore, label: isKidsMode ? "🗣️ Voice" : "Pronunciation", color: .blue)
                scoreCircle(score: feedback.tajweedScore, label: isKidsMode ? "🎵 Tajweed" : "Tajweed", color: .purple)
            }
            .frame(maxWidth: .infinity)
            
            // Encouragement
            Text(feedback.encouragement)
                .font(isKidsMode ? .body : .subheadline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.1))
                )
            
            // Feedback Items
            if !feedback.feedback.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(isKidsMode ? "💡 Tips to improve:" : "Areas for Improvement")
                        .font(.subheadline.bold())
                    
                    ForEach(feedback.feedback) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.issue)
                                    .font(.caption)
                                Text(item.correction)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            
            // Recommendations
            VStack(alignment: .leading, spacing: 8) {
                Text(isKidsMode ? "🎯 Practice Plan:" : "Practice Recommendations")
                    .font(.subheadline.bold())
                
                ForEach(feedback.practiceRecommendations, id: \.self) { rec in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(rec)
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5)
        )
    }
    
    private func scoreCircle(score: Int, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 6)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: Double(score) / 100)
                    .stroke(color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                
                Text("\(score)")
                    .font(.headline.bold())
            }
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Tajweed Rules Section
    private var tajweedRulesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(isKidsMode ? "🎓 Learn Tajweed Rules!" : "Tajweed Reference")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(AIQuranCoachService.TajweedRule.allCases, id: \.self) { rule in
                    TajweedRuleCard(rule: rule, isKidsMode: isKidsMode, coachService: coachService)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5)
        )
    }
    
    // MARK: - Recording Functions
    private func startRecording() {
        isRecording = true
    }
    
    private func stopRecording() {
        isRecording = false
        
        // Simulate analysis
        Task {
            _ = await coachService.analyzeRecitation(surah: selectedSurah, ayah: selectedAyah, isKidsMode: isKidsMode)
        }
    }
}

// MARK: - Tajweed Rule Card
struct TajweedRuleCard: View {
    let rule: AIQuranCoachService.TajweedRule
    let isKidsMode: Bool
    let coachService: AIQuranCoachService
    
    @State private var showExplanation = false
    
    var body: some View {
        Button {
            showExplanation = true
        } label: {
            VStack(spacing: 4) {
                Text(ruleEmoji)
                    .font(.title2)
                Text(rule.rawValue)
                    .font(.caption.bold())
                    .foregroundColor(.primary)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .sheet(isPresented: $showExplanation) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(ruleEmoji)
                            .font(.system(size: 60))
                            .frame(maxWidth: .infinity)
                        
                        Text(rule.rawValue)
                            .font(.title.bold())
                        
                        Text(coachService.explainTajweedRule(rule, isKidsMode: isKidsMode))
                            .font(.body)
                        
                        if !isKidsMode {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Applicable Letters:")
                                    .font(.headline)
                                Text(rule.letters)
                                    .font(.title2)
                                    .foregroundColor(.purple)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle(rule.rawValue)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            showExplanation = false
                        }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    private var ruleEmoji: String {
        switch rule {
        case .ghunnah: return "🎵"
        case .ikhfa: return "🤫"
        case .idgham: return "🤝"
        case .iqlab: return "🔄"
        case .izhar: return "📢"
        case .qalqalah: return "🔔"
        case .madd: return "➡️"
        }
    }
}

// MARK: - Preview
#Preview {
    AIQuranCoachView(isKidsMode: true)
}
