//
//  ArabicView.swift
//  DeenLearn
//
//  Arabic/Visual Language Tab - Teaching Arabic letters, vocabulary, and concepts
//

import SwiftUI

struct ArabicView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSection: ArabicSection = .alphabet
    
    enum ArabicSection: String, CaseIterable {
        case alphabet = "Alphabet"
        case tracing = "Tracing"
        case vocabulary = "Vocabulary"
        case games = "Games"
        case conceptMaps = "Concept Maps"
        
        var icon: String {
            switch self {
            case .alphabet: return "textformat.abc"
            case .tracing: return "pencil.tip"
            case .vocabulary: return "book.fill"
            case .games: return "gamecontroller.fill"
            case .conceptMaps: return "map.fill"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Section Picker
                sectionPicker
                
                // Content based on selection
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedSection {
                        case .alphabet:
                            AlphabetSectionView()
                        case .tracing:
                            TracingSectionView()
                        case .vocabulary:
                            VocabularySectionView()
                        case .games:
                            GamesSectionView()
                        case .conceptMaps:
                            ConceptMapsSectionView()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(appState.isKidsMode ? "🔤 Arabic Fun!" : "Arabic Language")
            .background(Color(.systemGroupedBackground))
        }
        .navigationViewStyle(.stack)
        .environmentObject(appState)
    }
    
    private var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ArabicSection.allCases, id: \.self) { section in
                    Button(action: { selectedSection = section }) {
                        HStack(spacing: 6) {
                            Image(systemName: section.icon)
                            Text(section.rawValue)
                        }
                        .font(appState.isKidsMode ? .headline : .subheadline)
                        .fontWeight(selectedSection == section ? .bold : .medium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(selectedSection == section ? appState.themeColor : Color(.systemGray5))
                        .foregroundColor(selectedSection == section ? .white : .primary)
                        .cornerRadius(20)
                    }
                    .accessibilityLabel("\(section.rawValue) section")
                    .accessibilityHint("Tap to view \(section.rawValue.lowercased()) content")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Alphabet Section

struct AlphabetSectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedLetter: ArabicLetter?
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
    let columns = [
        GridItem(.adaptive(minimum: DeviceLayout.scaled(70)), spacing: DeviceLayout.scaled(12))
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Tap to Listen Hint
            TapToListenHint(isKidsMode: appState.isKidsMode)
            
            // Header
            if appState.isKidsMode {
                Text("🎨 Tap a letter to learn!")
                    .font(.title2)
                    .fontWeight(.bold)
            } else {
                Text("Arabic Alphabet - 28 Letters")
                    .font(.headline)
                Text("Tap any letter to see all forms and hear pronunciation")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Letter Grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(ArabicLetter.alphabet) { letter in
                    LetterCardView(letter: letter, isKidsMode: appState.isKidsMode, ttsService: ttsService)
                        .onTapGesture {
                            // Play the letter sound
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            ttsService.speakArabic(letter.isolated, rate: 0.3)
                            
                            selectedLetter = letter
                        }
                }
            }
        }
        .sheet(item: $selectedLetter) { letter in
            LetterDetailView(letter: letter)
                .environmentObject(appState)
        }
    }
}

struct LetterCardView: View {
    let letter: ArabicLetter
    let isKidsMode: Bool
    @ObservedObject var ttsService: TextToSpeechService
    
    private var isCurrentlySpeaking: Bool {
        ttsService.isSpeaking && ttsService.currentText == letter.isolated
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(letter.isolated)
            .font(.system(size: DeviceLayout.scaledFont(isKidsMode ? 36 : 32)))
            
            HStack(spacing: 2) {
                Text(letter.name)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Image(systemName: isCurrentlySpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
                    .font(.system(size: 8))
                    .foregroundColor(isCurrentlySpeaking ? .blue : .gray.opacity(0.5))
            }
        }
        .responsiveFrame(width: 70, height: 70)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCurrentlySpeaking ? Color.blue.opacity(0.1) : Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
        )
    }
}

struct LetterDetailView: View {
    let letter: ArabicLetter
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Large Letter Display with tap-to-listen
                    VStack(spacing: 8) {
                        Text(letter.isolated)
                            .font(.system(size: DeviceLayout.scaledFont(120)))
                        Text(letter.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 4) {
                            Text("[\(letter.transliteration)]")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            
                            Image(systemName: ttsService.isSpeaking && ttsService.currentText == letter.isolated ? "speaker.wave.3.fill" : "speaker.wave.2")
                                .foregroundColor(ttsService.isSpeaking ? .blue : .gray)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(appState.themeColor.opacity(0.1))
                    .cornerRadius(20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        ttsService.speakArabic(letter.isolated, rate: 0.3)
                    }
                    
                    // Tap to Listen hint
                    TapToListenHint(isKidsMode: appState.isKidsMode)
                    
                    // Four Forms
                    VStack(alignment: .leading, spacing: 12) {
                        Text(appState.isKidsMode ? "📝 Letter Forms" : "Position Forms")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            FormBox(title: "Isolated", form: letter.isolated)
                            FormBox(title: "Initial", form: letter.initial)
                            FormBox(title: "Medial", form: letter.medial)
                            FormBox(title: "Final", form: letter.final)
                        }
                    }
                    
                    // Pronunciation
                    VStack(alignment: .leading, spacing: 8) {
                        Text(appState.isKidsMode ? "🗣️ How to Say It" : "Pronunciation")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: ttsService.isSpeaking && ttsService.currentText == letter.pronunciation ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                                .foregroundColor(ttsService.isSpeaking && ttsService.currentText == letter.pronunciation ? .blue : appState.themeColor)
                            Text(letter.pronunciation)
                            Spacer()
                            Text(appState.isKidsMode ? "👆 Tap!" : "Tap to listen")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            ttsService.speakEnglish(letter.pronunciation, rate: 0.4)
                        }
                        
                        // Audio button - NOW WORKING
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            ttsService.speakArabic(letter.isolated, rate: 0.3)
                        }) {
                            HStack {
                                Image(systemName: ttsService.isSpeaking && ttsService.currentText == letter.isolated ? "stop.circle.fill" : "play.circle.fill")
                                Text(ttsService.isSpeaking && ttsService.currentText == letter.isolated ? "Playing..." : "Hear Pronunciation")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ttsService.isSpeaking && ttsService.currentText == letter.isolated ? Color.orange : appState.themeColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    
                    // Example Word
                    VStack(alignment: .leading, spacing: 8) {
                        Text(appState.isKidsMode ? "🎯 Example Word" : "Example")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            Text(letter.exampleIcon)
                                .font(.system(size: 50))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 4) {
                                    Text(letter.exampleWord)
                                        .font(.system(size: 28))
                                    
                                    Image(systemName: ttsService.isSpeaking && ttsService.currentText == letter.exampleWord ? "speaker.wave.3.fill" : "speaker.wave.2")
                                        .font(.caption)
                                        .foregroundColor(ttsService.isSpeaking && ttsService.currentText == letter.exampleWord ? .blue : .gray)
                                }
                                Text(letter.exampleTranslation)
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            ttsService.speakArabic(letter.exampleWord, rate: 0.35)
                        }
                    }
                    
                    if appState.isKidsMode {
                        // Fun fact for kids
                        HStack {
                            Text("⭐")
                            Text("Great job learning \(letter.name)!")
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle(letter.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct FormBox: View {
    let title: String
    let form: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(form)
                .font(.system(size: 32))
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Tracing Section

struct TracingSectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedLetter: ArabicLetter?
    @State private var tracingProgress: CGFloat = 0
    @State private var showTracingView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            if appState.isKidsMode {
                Text("✏️ Practice Writing!")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Use your finger to trace the letters")
                    .foregroundColor(.secondary)
            } else {
                Text("Tracing Practice")
                    .font(.headline)
                Text("Master letter formation through guided tracing")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Letter selection
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ArabicLetter.alphabet.prefix(10)) { letter in
                        Button(action: {
                            selectedLetter = letter
                            showTracingView = true
                        }) {
                            VStack {
                                Text(letter.isolated)
                                    .font(.system(size: 40))
                                Text(letter.name)
                                    .font(.caption)
                            }
                            .frame(width: 80, height: 80)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            // Tracing Canvas Preview
            if let letter = selectedLetter {
                TracingCanvasView(letter: letter)
            } else {
                // Default tracing area
                VStack(spacing: 16) {
                    Text(appState.isKidsMode ? "👆 Select a letter above!" : "Select a letter to begin tracing")
                        .foregroundColor(.secondary)
                    
                    // Sample tracing area
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6))
                        
                        Text("ا")
                            .font(.system(size: DeviceLayout.scaledFont(150)))
                            .foregroundColor(.gray.opacity(0.3))
                        
                        Text(appState.isKidsMode ? "Tap a letter to start!" : "Select a letter")
                            .foregroundColor(.secondary)
                            .offset(y: 80)
                    }
                    .frame(height: 250)
                }
            }
            
            // Tips
            VStack(alignment: .leading, spacing: 8) {
                Text(appState.isKidsMode ? "💡 Tips for Tracing" : "Writing Tips")
                    .font(.headline)
                
                TipRow(icon: "arrow.right", text: "Arabic is written right to left")
                TipRow(icon: "pencil", text: "Start from the dot or beginning mark")
                TipRow(icon: "repeat", text: "Practice each letter multiple times")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct TracingCanvasView: View {
    let letter: ArabicLetter
    @State private var lines: [[CGPoint]] = []
    @State private var currentLine: [CGPoint] = []
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 16) {
            Text(appState.isKidsMode ? "Trace the letter \(letter.name)!" : "Trace: \(letter.name)")
                .font(.headline)
            
            ZStack {
                // Background letter (guide)
                Text(letter.isolated)
                    .font(.system(size: DeviceLayout.scaledFont(150)))
                    .foregroundColor(.gray.opacity(0.2))
                
                // Drawing canvas
                Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        if let first = line.first {
                            path.move(to: first)
                            for point in line.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        context.stroke(path, with: .color(appState.themeColor), lineWidth: 8)
                    }
                    
                    var currentPath = Path()
                    if let first = currentLine.first {
                        currentPath.move(to: first)
                        for point in currentLine.dropFirst() {
                            currentPath.addLine(to: point)
                        }
                    }
                    context.stroke(currentPath, with: .color(appState.themeColor), lineWidth: 8)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            currentLine.append(value.location)
                        }
                        .onEnded { _ in
                            lines.append(currentLine)
                            currentLine = []
                        }
                )
            }
            .frame(height: 250)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            
            // Controls
            HStack(spacing: 20) {
                Button(action: {
                    lines = []
                    currentLine = []
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Clear")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                }
                
                if appState.isKidsMode {
                    Button(action: { /* Check tracing */ }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Check!")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(appState.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }
}

// MARK: - Vocabulary Section

struct VocabularySectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: VocabularyCategory = .salahWords
    @State private var selectedWord: VocabularyWord?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            if appState.isKidsMode {
                Text("📚 Learn New Words!")
                    .font(.title2)
                    .fontWeight(.bold)
            } else {
                Text("Vocabulary Packs")
                    .font(.headline)
            }
            
            // Category Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(VocabularyCategory.allCases, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            VStack(spacing: 4) {
                                Text(category.icon)
                                    .font(.title2)
                                Text(category.rawValue)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? category.color.opacity(0.2) : Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedCategory == category ? category.color : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            // Words Grid
            let words = VocabularyWord.words(for: selectedCategory)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                ForEach(words) { word in
                    VocabularyCardView(word: word)
                        .onTapGesture {
                            selectedWord = word
                        }
                }
            }
        }
        .sheet(item: $selectedWord) { word in
            VocabularyDetailView(word: word)
                .environmentObject(appState)
        }
    }
}

struct VocabularyCardView: View {
    let word: VocabularyWord
    
    var body: some View {
        VStack(spacing: 8) {
            Text(word.icon)
                .font(.system(size: 40))
            Text(word.arabic)
                .font(.title2)
            Text(word.english)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
    }
}

struct VocabularyDetailView: View {
    let word: VocabularyWord
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
    private var isPlayingWord: Bool {
        ttsService.isSpeaking && ttsService.currentText == word.arabic
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Icon and Word
                VStack(spacing: 12) {
                    Text(word.icon)
                        .font(.system(size: DeviceLayout.scaledFont(80)))
                    
                    Text(word.arabic)
                        .font(.system(size: DeviceLayout.scaledFont(48)))
                    
                    Text(word.transliteration)
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text(word.english)
                        .font(.title)
                        .fontWeight(.medium)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(word.category.color.opacity(0.1))
                .cornerRadius(20)
                
                // Audio Button
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    if isPlayingWord {
                        ttsService.stop()
                    } else {
                        ttsService.speakArabic(word.arabic, rate: 0.35)
                    }
                }) {
                    HStack {
                        Image(systemName: isPlayingWord ? "stop.circle.fill" : "speaker.wave.2.fill")
                        Text(isPlayingWord ? "Playing..." : "Tap to Listen")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isPlayingWord ? Color.orange : appState.themeColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                // Category badge
                HStack {
                    Text(word.category.icon)
                    Text(word.category.rawValue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(word.category.color.opacity(0.2))
                .cornerRadius(20)
                
                Spacer()
                
                if appState.isKidsMode {
                    Text("⭐ Great job learning a new word!")
                        .fontWeight(.medium)
                        .padding()
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(12)
                }
            }
            .padding()
            .navigationTitle(word.english)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Games Section

struct GamesSectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedGame: ArabicMiniGameType?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            if appState.isKidsMode {
                Text("🎮 Fun Games!")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Learn Arabic while playing!")
                    .foregroundColor(.secondary)
            } else {
                Text("Mini-Games")
                    .font(.headline)
                Text("Reinforce your learning through interactive games")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Game Cards
            ForEach(ArabicMiniGameType.allCases, id: \.self) { gameType in
                GameCardView(gameType: gameType) {
                    selectedGame = gameType
                }
            }
        }
        .sheet(item: $selectedGame) { game in
            MiniGameView(gameType: game)
                .environmentObject(appState)
        }
    }
}

struct GameCardView: View {
    let gameType: ArabicMiniGameType
    let action: () -> Void
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(gameType.icon)
                    .font(.system(size: 40))
                    .frame(width: 60, height: 60)
                    .background(appState.themeColor.opacity(0.1))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(gameType.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(gameType.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "play.circle.fill")
                    .font(.title)
                    .foregroundColor(appState.themeColor)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MiniGameView: View {
    let gameType: ArabicMiniGameType
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var score = 0
    @State private var currentRound = 0
    @State private var gameItems: [MatchGameItem] = []
    @State private var selectedItem: MatchGameItem?
    @State private var isCorrect: Bool?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Score
                HStack {
                    Text(appState.isKidsMode ? "⭐ Stars:" : "Score:")
                        .font(.headline)
                    Text("\(score)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(appState.themeColor)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Game Content
                switch gameType {
                case .matchIconToWord:
                    MatchIconGameContent(score: $score, isKidsMode: appState.isKidsMode)
                case .soundRecognition:
                    SoundRecognitionGameContent(score: $score, isKidsMode: appState.isKidsMode)
                case .buildSentence:
                    BuildSentenceGameContent(score: $score, isKidsMode: appState.isKidsMode)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(gameType.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct MatchIconGameContent: View {
    @Binding var score: Int
    let isKidsMode: Bool
    
    private static let defaultItems: [(icon: String, arabic: String, english: String)] = [
        ("🦁", "أَسَد", "Lion"),
        ("🏠", "بَيْت", "House"),
        ("☀️", "شَمْس", "Sun"),
        ("🌙", "قَمَر", "Moon")
    ]
    
    @State private var items = defaultItems
    @State private var shuffledArabicItems = defaultItems.shuffled()
    @State private var matchedPairs: Set<String> = []
    @State private var showFeedback = false
    @State private var isCorrectMatch = false
    @State private var targetedArabic: String? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isKidsMode ? "Match the picture to the Arabic word!" : "Match icons to their Arabic names")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 40) {
                // Icons column
                VStack(spacing: 12) {
                    Text("Pictures")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    ForEach(items, id: \.icon) { item in
                        Text(item.icon)
                            .font(.system(size: 40))
                            .frame(width: 70, height: 70)
                            .background(
                                matchedPairs.contains(item.arabic) ? Color.green.opacity(0.2) :
                                Color(.systemGray6)
                            )
                            .cornerRadius(12)
                            .draggable(item.icon)
                            .opacity(matchedPairs.contains(item.arabic) ? 0.5 : 1.0)
                    }
                }
                
                // Arabic column
                VStack(spacing: 12) {
                    Text("Arabic")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    ForEach(shuffledArabicItems, id: \.arabic) { item in
                        Text(item.arabic)
                            .font(.title2)
                            .frame(width: 100, height: 70)
                            .background(
                                matchedPairs.contains(item.arabic) ? Color.green.opacity(0.2) :
                                targetedArabic == item.arabic ? Color.blue.opacity(0.2) :
                                Color(.systemGray6)
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(targetedArabic == item.arabic ? Color.blue : Color.clear, lineWidth: 2)
                            )
                            .dropDestination(for: String.self) { droppedItems, _ in
                                guard let droppedIcon = droppedItems.first,
                                      !matchedPairs.contains(item.arabic) else { return false }
                                if item.icon == droppedIcon {
                                    matchedPairs.insert(item.arabic)
                                    score += 10
                                    isCorrectMatch = true
                                } else {
                                    isCorrectMatch = false
                                }
                                showFeedback = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    showFeedback = false
                                }
                                return true
                            } isTargeted: { targeted in
                                targetedArabic = targeted ? item.arabic : nil
                            }
                            .opacity(matchedPairs.contains(item.arabic) ? 0.5 : 1.0)
                    }
                }
            }
            
            // Feedback
            if showFeedback {
                Text(isCorrectMatch ? (isKidsMode ? "⭐ Great job!" : "Correct!") : (isKidsMode ? "Try again! 💪" : "Not quite, try again"))
                    .font(.headline)
                    .foregroundColor(isCorrectMatch ? .green : .orange)
                    .padding()
                    .background(isCorrectMatch ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                    .cornerRadius(12)
            }
            
            // Completion
            if matchedPairs.count == items.count {
                VStack(spacing: 12) {
                    Text(isKidsMode ? "🎉 You did it!" : "All matched!")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Score: \(score)")
                        .font(.headline)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .onAppear {
            if shuffledArabicItems.isEmpty {
                shuffledArabicItems = items.shuffled()
            }
        }
    }
}

struct SoundRecognitionGameContent: View {
    @Binding var score: Int
    let isKidsMode: Bool
    @State private var currentLetter = ArabicLetter.alphabet.first ?? ArabicLetter(name: "Alif", transliteration: "a", isolated: "ا", initial: "ا", medial: "ـا", final: "ـا", pronunciation: "Like 'a' in 'father'", exampleWord: "أَسَد", exampleTranslation: "Lion", exampleIcon: "🦁")
    @State private var options: [ArabicLetter] = []
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var isDropTargeted = false
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
    private var isPlayingCurrentLetter: Bool {
        ttsService.isSpeaking && ttsService.currentText == currentLetter.isolated
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isKidsMode ? "Listen and pick the right letter!" : "Identify the letter by its sound")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            // Play sound button - uses Gemini AI voice
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                ttsService.speakArabic(currentLetter.isolated, rate: 0.3)
            }) {
                VStack(spacing: 12) {
                    Image(systemName: isPlayingCurrentLetter ? "stop.circle.fill" : "sparkles")
                        .font(.system(size: 50))
                    Text(isPlayingCurrentLetter ? "Playing..." : "AI Voice")
                        .font(.headline)
                }
                .responsiveFrame(width: 150, height: 150)
                .background(isPlayingCurrentLetter ? Color.orange.opacity(0.1) : Color.blue.opacity(0.1))
                .foregroundColor(isPlayingCurrentLetter ? .orange : .blue)
                .cornerRadius(20)
            }
            
            Text(isKidsMode ? "👆 Tap to hear the letter!" : "Tap to hear, then pick the matching letter")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Letter to identify
            Text("Which letter is: \(currentLetter.name)?")
                .font(.title3)
            
            // Drop target zone
            VStack(spacing: 8) {
                Image(systemName: "arrow.down.circle")
                    .font(.system(size: 30))
                Text("Drop the correct letter here")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(isDropTargeted ? Color.blue.opacity(0.2) : Color(.systemGray6))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isDropTargeted ? Color.blue : Color(.systemGray4), lineWidth: isDropTargeted ? 2 : 1)
            )
            .dropDestination(for: String.self) { droppedItems, _ in
                guard let droppedName = droppedItems.first else { return false }
                if let letter = options.first(where: { $0.name == droppedName }) {
                    checkAnswer(letter)
                }
                return true
            } isTargeted: { targeted in
                isDropTargeted = targeted
            }
            
            // Options
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
                ForEach(getOptions(), id: \.id) { letter in
                    Text(letter.isolated)
                        .font(.system(size: 36))
                        .frame(width: 80, height: 80)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .draggable(letter.name)
                }
            }
            
            // Feedback
            if showFeedback {
                Text(isCorrect ? (isKidsMode ? "⭐ Correct!" : "Right!") : (isKidsMode ? "Not that one! 💪" : "Try again"))
                    .font(.headline)
                    .foregroundColor(isCorrect ? .green : .orange)
                    .padding()
            }
        }
        .onAppear {
            setupOptions()
        }
    }
    
    func getOptions() -> [ArabicLetter] {
        if options.isEmpty {
            setupOptions()
        }
        return options
    }
    
    func setupOptions() {
        var selected = [currentLetter]
        while selected.count < 4 {
            if let random = ArabicLetter.alphabet.randomElement(), !selected.contains(where: { $0.name == random.name }) {
                selected.append(random)
            }
        }
        options = selected.shuffled()
    }
    
    func checkAnswer(_ letter: ArabicLetter) {
        isCorrect = letter.name == currentLetter.name
        if isCorrect {
            score += 10
            // Next question
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let nextLetter = ArabicLetter.alphabet.randomElement() {
                    currentLetter = nextLetter
                }
                setupOptions()
                showFeedback = false
            }
        }
        showFeedback = true
    }
}

struct BuildSentenceGameContent: View {
    @Binding var score: Int
    let isKidsMode: Bool
    @State private var currentGame = SentenceBuildGame.samples[0]
    @State private var selectedWords: [String] = []
    @State private var availableWords: [String] = SentenceBuildGame.samples[0].shuffledWords
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var isSentenceAreaTargeted = false
    @State private var isAvailableAreaTargeted = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isKidsMode ? "Put the words in order!" : "Arrange words to form the sentence")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            // Translation hint
            Text("\"\(currentGame.translation)\"")
                .font(.title3)
                .italic()
                .foregroundColor(.secondary)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            // Selected words area
            VStack(spacing: 8) {
                Text("Your sentence:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    ForEach(selectedWords, id: \.self) { word in
                        Text(word)
                            .font(.title2)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                            .draggable(word)
                    }
                    
                    if selectedWords.isEmpty {
                        Text("Drop words here")
                            .foregroundColor(.secondary)
                    }
                }
                .frame(minHeight: 60)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSentenceAreaTargeted ? Color.blue.opacity(0.1) : Color(.systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSentenceAreaTargeted ? Color.blue : Color(.systemGray4), lineWidth: isSentenceAreaTargeted ? 2 : 1)
                )
                .dropDestination(for: String.self) { droppedItems, _ in
                    for word in droppedItems {
                        if let index = availableWords.firstIndex(of: word) {
                            availableWords.remove(at: index)
                            selectedWords.append(word)
                        }
                    }
                    return true
                } isTargeted: { targeted in
                    isSentenceAreaTargeted = targeted
                }
            }
            
            // Available words
            VStack(spacing: 8) {
                Text("Available words:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    ForEach(availableWords, id: \.self) { word in
                        Text(word)
                            .font(.title2)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .draggable(word)
                    }
                }
                .frame(minHeight: 50)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(isAvailableAreaTargeted ? Color.blue.opacity(0.1) : Color.clear)
                .cornerRadius(12)
                .dropDestination(for: String.self) { droppedItems, _ in
                    for word in droppedItems {
                        if let index = selectedWords.firstIndex(of: word) {
                            selectedWords.remove(at: index)
                            availableWords.append(word)
                        }
                    }
                    return true
                } isTargeted: { targeted in
                    isAvailableAreaTargeted = targeted
                }
            }
            
            // Check button
            Button(action: checkSentence) {
                Text(isKidsMode ? "Check My Answer! ✨" : "Check Answer")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedWords.count == currentGame.correctSentence.count ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(selectedWords.count != currentGame.correctSentence.count)
            
            // Feedback
            if showFeedback {
                Text(isCorrect ? (isKidsMode ? "🎉 Perfect!" : "Correct!") : (isKidsMode ? "Almost! Try again 💪" : "Not quite right"))
                    .font(.headline)
                    .foregroundColor(isCorrect ? .green : .orange)
                    .padding()
            }
        }
        .onAppear {
            availableWords = currentGame.shuffledWords
        }
    }
    
    func checkSentence() {
        isCorrect = selectedWords == currentGame.correctSentence
        if isCorrect {
            score += 20
        }
        showFeedback = true
    }
}

// MARK: - Concept Maps Section

struct ConceptMapsSectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedMap: ConceptMap?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            if appState.isKidsMode {
                Text("🗺️ Visual Maps!")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("See how things connect!")
                    .foregroundColor(.secondary)
            } else {
                Text("Visual Concept Maps")
                    .font(.headline)
                Text("Understand Islamic concepts through visual connections")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Map Cards
            ForEach(ConceptMap.allMaps) { map in
                ConceptMapCardView(map: map) {
                    selectedMap = map
                }
            }
        }
        .sheet(item: $selectedMap) { map in
            ConceptMapDetailView(map: map)
                .environmentObject(appState)
        }
    }
}

struct ConceptMapCardView: View {
    let map: ConceptMap
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(map.icon)
                    .font(.system(size: 40))
                    .frame(width: 60, height: 60)
                    .background(map.color.opacity(0.1))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(map.title)
                            .font(.headline)
                        Text(map.arabicTitle)
                            .font(.headline)
                    }
                    .foregroundColor(.primary)
                    
                    Text("\(map.nodes.count) concepts connected")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(map.color)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ConceptMapDetailView: View {
    let map: ConceptMap
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var selectedNode: ConceptNode?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Map Header
                    HStack {
                        Text(map.icon)
                            .font(.system(size: 50))
                        VStack(alignment: .leading) {
                            Text(map.title)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(map.arabicTitle)
                                .font(.title2)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(map.color.opacity(0.1))
                    .cornerRadius(16)
                    
                    // Concept Flow
                    Text(appState.isKidsMode ? "Follow the journey! 👇" : "Concept Flow")
                        .font(.headline)
                    
                    // Nodes as a flow
                    ForEach(Array(map.nodes.enumerated()), id: \.element.id) { index, node in
                        VStack(spacing: 0) {
                            // Node card
                            Button(action: { selectedNode = node }) {
                                HStack(spacing: 16) {
                                    Text(node.icon)
                                        .font(.system(size: 36))
                                        .frame(width: 60, height: 60)
                                        .background(map.color.opacity(0.1))
                                        .cornerRadius(12)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(node.title)
                                                .font(.headline)
                                            Text("(\(node.arabic))")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        Text(node.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(index + 1)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .frame(width: 24, height: 24)
                                        .background(map.color)
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Arrow to next (if not last)
                            if index < map.nodes.count - 1 {
                                VStack(spacing: 2) {
                                    Rectangle()
                                        .fill(map.color.opacity(0.3))
                                        .frame(width: 2, height: 20)
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                        .foregroundColor(map.color)
                                    Rectangle()
                                        .fill(map.color.opacity(0.3))
                                        .frame(width: 2, height: 20)
                                }
                            }
                        }
                    }
                    
                    // Legend for kids
                    if appState.isKidsMode {
                        HStack {
                            Text("🎯")
                            Text("Tap any step to learn more!")
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle(map.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Preview

struct ArabicView_Previews: PreviewProvider {
    static var previews: some View {
        ArabicView()
            .environmentObject(AppState())
    }
}
