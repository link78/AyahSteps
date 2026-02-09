//
//  QuranView.swift
//  DeenLearn
//
//  Phase 1.4 - Quran Tab: Reading, Recitation, Memorization
//  Complete Quran learning experience for all ages
//

import SwiftUI

struct QuranView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSection: QuranSection = .reading
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    quranHeader
                    
                    // Section Picker
                    sectionPicker
                    
                    // Content based on section
                    switch selectedSection {
                    case .reading:
                        ReadingModeView(isKidsMode: isKidsMode)
                    case .wordByWord:
                        WordByWordView(isKidsMode: isKidsMode)
                    case .memorization:
                        MemorizationModeView(isKidsMode: isKidsMode)
                    case .tajweed:
                        TajweedToolsView(isKidsMode: isKidsMode)
                    case .juzAmma:
                        JuzAmmaAdventureView(isKidsMode: isKidsMode)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(isKidsMode ? "📖 Quran" : "Quran")
        }
    }
    
    var quranHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "6B5B95"), Color(hex: "8E7CC3")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "book.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            
            Text("القرآن الكريم")
                .font(.title)
            
            Text("The Noble Quran")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if isKidsMode {
                Text("🌟 Learn, Read, and Memorize! 🌟")
                    .font(.subheadline)
                    .foregroundColor(.purple)
            }
        }
        .padding()
    }
    
    var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(QuranSection.allCases, id: \.self) { section in
                    // Skip Juz Amma section for adults (it's kids-focused)
                    if section != .juzAmma || isKidsMode {
                        QuranSectionButton(
                            section: section,
                            isSelected: selectedSection == section,
                            isKidsMode: isKidsMode
                        ) {
                            withAnimation {
                                selectedSection = section
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

enum QuranSection: String, CaseIterable {
    case reading = "Reading"
    case wordByWord = "Word"
    case memorization = "Memorize"
    case tajweed = "Tajweed"
    case juzAmma = "Juz Amma"
    
    var icon: String {
        switch self {
        case .reading: return "book.fill"
        case .wordByWord: return "textformat.abc"
        case .memorization: return "brain.head.profile"
        case .tajweed: return "waveform.path.ecg"
        case .juzAmma: return "map.fill"
        }
    }
    
    var kidsEmoji: String {
        switch self {
        case .reading: return "📖"
        case .wordByWord: return "🔤"
        case .memorization: return "🧠"
        case .tajweed: return "🎨"
        case .juzAmma: return "🗺️"
        }
    }
}

struct QuranSectionButton: View {
    let section: QuranSection
    let isSelected: Bool
    let isKidsMode: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if isKidsMode {
                    Text(section.kidsEmoji)
                        .font(.title2)
                } else {
                    Image(systemName: section.icon)
                        .font(.title3)
                }
                
                Text(section.rawValue)
                    .font(.caption)
            }
            .frame(width: 70, height: 70)
            .background(isSelected ? Color(hex: "6B5B95") : Color(.systemBackground))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("\(section.rawValue) section")
    }
}

// MARK: - Reading Mode View

struct ReadingModeView: View {
    let isKidsMode: Bool
    @State private var selectedSurah: Surah?
    @State private var showTajweedOverlay = false
    @State private var searchText = ""
    @State private var filterJuz: Int? = nil
    
    var allSurahs: [Surah] {
        Surah.getAllSurahs()
    }
    
    var filteredSurahs: [Surah] {
        var result = allSurahs
        
        // Filter by search text
        if !searchText.isEmpty {
            result = result.filter { surah in
                surah.name.localizedCaseInsensitiveContains(searchText) ||
                surah.nameArabic.contains(searchText) ||
                surah.englishMeaning.localizedCaseInsensitiveContains(searchText) ||
                "\(surah.id)".contains(searchText)
            }
        }
        
        // Filter by Juz
        if let juz = filterJuz {
            result = result.filter { $0.juz.contains(juz) }
        }
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Options bar
            HStack {
                Text(isKidsMode ? "📚 Mushaf" : "Mushaf (Reading)")
                    .font(.headline)
                
                Spacer()
                
                Toggle("Tajweed Colors", isOn: $showTajweedOverlay)
                    .labelsHidden()
                
                Text("Tajweed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search Surah...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            
            // Juz filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // All Juz
                    Button(action: { filterJuz = nil }) {
                        Text("All")
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(filterJuz == nil ? Color(hex: "6B5B95") : Color(.systemGray6))
                            .foregroundColor(filterJuz == nil ? .white : .primary)
                            .cornerRadius(8)
                    }
                    
                    // Juz 1-30
                    ForEach(1...30, id: \.self) { juz in
                        Button(action: { filterJuz = juz }) {
                            Text("Juz \(juz)")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(filterJuz == juz ? Color(hex: "6B5B95") : Color(.systemGray6))
                                .foregroundColor(filterJuz == juz ? .white : .primary)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Surah count
            Text("\(filteredSurahs.count) Surahs")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            // Surah list - All 114 surahs
            ForEach(filteredSurahs, id: \.id) { surah in
                SurahReadingCard(surah: surah, isKidsMode: isKidsMode) {
                    selectedSurah = surah
                }
            }
        }
        .sheet(item: $selectedSurah) { surah in
            SurahReaderView(surah: surah, isKidsMode: isKidsMode, showTajweed: showTajweedOverlay)
        }
    }
}

struct SurahReadingCard: View {
    let surah: Surah
    let isKidsMode: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Surah number
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "6B5B95").opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    if isKidsMode {
                        Text(surah.kidsEmoji)
                            .font(.title2)
                    } else {
                        Text("\(surah.id)")
                            .font(.headline)
                            .foregroundColor(Color(hex: "6B5B95"))
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(surah.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(surah.nameArabic)
                            .font(.title3)
                            .foregroundColor(Color(hex: "6B5B95"))
                    }
                    
                    HStack {
                        Text(surah.englishMeaning)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text("\(surah.verseCount) verses")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(surah.revelationType.rawValue)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(surah.revelationType == .meccan ? Color.orange : Color.green)
                            .cornerRadius(4)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

// MARK: - Surah Reader View

struct SurahReaderView: View {
    let surah: Surah
    let isKidsMode: Bool
    let showTajweed: Bool
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedWord: QuranWord?
    @State private var bookmarks: [Int] = []
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
    var ayahs: [Ayah] {
        Ayah.getAyahs(forSurah: surah.id)
    }
    
    private let bismillah = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Tap to Listen hint
                    TapToListenHint(isKidsMode: isKidsMode)
                        .padding(.horizontal)
                    
                    // Surah header
                    VStack(spacing: 12) {
                        // Surah name in Arabic - tappable
                        HStack(spacing: 6) {
                            Text(surah.nameArabic)
                                .font(.largeTitle)
                            
                            Image(systemName: ttsService.isSpeaking && ttsService.currentText == surah.nameArabic ? "speaker.wave.3.fill" : "speaker.wave.2")
                                .font(.title3)
                                .foregroundColor(ttsService.isSpeaking && ttsService.currentText == surah.nameArabic ? .blue : .gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            ttsService.speakArabic(surah.nameArabic, rate: 0.35)
                        }
                        
                        Text(surah.name)
                            .font(.title2)
                        
                        Text(surah.englishMeaning)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Bismillah (except for Surah 9) - tappable
                        if surah.id != 9 && surah.id != 1 {
                            HStack(spacing: 6) {
                                Text(bismillah)
                                    .font(.title2)
                                    .foregroundColor(Color(hex: "6B5B95"))
                                
                                Image(systemName: ttsService.isSpeaking && ttsService.currentText == bismillah ? "speaker.wave.3.fill" : "speaker.wave.2")
                                    .font(.caption)
                                    .foregroundColor(ttsService.isSpeaking && ttsService.currentText == bismillah ? .blue : .gray)
                            }
                            .padding(.top)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                ttsService.speakArabic(bismillah, rate: 0.3)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "6B5B95").opacity(0.1))
                    .cornerRadius(20)
                    
                    // Ayahs
                    if ayahs.isEmpty {
                        Text("Surah content coming soon...")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(ayahs) { ayah in
                            AyahReadingView(
                                ayah: ayah,
                                isKidsMode: isKidsMode,
                                showTajweed: showTajweed,
                                isBookmarked: bookmarks.contains(ayah.ayahNumber),
                                onWordTap: { word in
                                    selectedWord = word
                                },
                                onBookmarkToggle: {
                                    if bookmarks.contains(ayah.ayahNumber) {
                                        bookmarks.removeAll { $0 == ayah.ayahNumber }
                                    } else {
                                        bookmarks.append(ayah.ayahNumber)
                                    }
                                }
                            )
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(item: $selectedWord) { word in
                WordDetailView(word: word, isKidsMode: isKidsMode)
            }
        }
    }
}

struct AyahReadingView: View {
    let ayah: Ayah
    let isKidsMode: Bool
    let showTajweed: Bool
    let isBookmarked: Bool
    let onWordTap: (QuranWord) -> Void
    let onBookmarkToggle: () -> Void
    
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
    // Get full ayah text for audio
    private var fullAyahArabic: String {
        ayah.words.map { $0.arabic }.joined(separator: " ")
    }
    
    private var isPlayingThisAyah: Bool {
        ttsService.isSpeaking && ttsService.currentText == fullAyahArabic
    }
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Ayah number, bookmark, and play button
            HStack {
                Button(action: onBookmarkToggle) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(isBookmarked ? .orange : .secondary)
                }
                
                // Play entire ayah button
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    
                    if isPlayingThisAyah {
                        ttsService.stop()
                    } else {
                        ttsService.speakArabic(fullAyahArabic, rate: 0.3)
                    }
                }) {
                    Image(systemName: isPlayingThisAyah ? "stop.circle.fill" : "play.circle.fill")
                        .font(.title3)
                        .foregroundColor(isPlayingThisAyah ? .orange : Color(hex: "6B5B95"))
                }
                
                Spacer()
                
                Text("\(ayah.ayahNumber)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Circle().fill(Color(hex: "6B5B95")))
            }
            
            // Arabic text with tappable words - each word plays when tapped
            FlowLayout(spacing: 8) {
                ForEach(ayah.words) { word in
                    Button(action: {
                        // Play the word audio
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        ttsService.speakArabic(word.arabic, rate: 0.3)
                        
                        // Also show word detail
                        onWordTap(word)
                    }) {
                        HStack(spacing: 2) {
                            Text(word.arabic)
                                .font(.title2)
                                .foregroundColor(tajweedColor(for: word))
                            
                            if ttsService.isSpeaking && ttsService.currentText == word.arabic {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            // Transliteration
            Text(ayah.transliteration)
                .font(.body)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Translation
            Text(ayah.translation)
                .font(.body)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(isPlayingThisAyah ? Color.blue.opacity(0.05) : Color(.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isPlayingThisAyah ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 2)
        )
    }
    
    private func tajweedColor(for word: QuranWord) -> Color {
        guard showTajweed, let firstRule = word.tajweedRules.first else {
            return .primary
        }
        return Color(hex: firstRule.color)
    }
}

// Simple flow layout for Arabic words
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.maxX - result.positions[index].x - subview.sizeThatFits(.unspecified).width,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var positions: [CGPoint] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

// MARK: - Word Detail View

struct WordDetailView: View {
    let word: QuranWord
    let isKidsMode: Bool
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
    private var isPlayingThisWord: Bool {
        ttsService.isSpeaking && ttsService.currentText == word.arabic
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Tap to Listen hint
                    TapToListenHint(isKidsMode: isKidsMode)
                    
                    // Word display - tappable for pronunciation
                    VStack(spacing: 16) {
                        HStack(spacing: 8) {
                            Text(word.arabic)
                                .font(.system(size: isKidsMode ? 72 : 60))
                            
                            Image(systemName: isPlayingThisWord ? "speaker.wave.3.fill" : "speaker.wave.2")
                                .font(.title2)
                                .foregroundColor(isPlayingThisWord ? .blue : .gray)
                        }
                        
                        Text(word.transliteration)
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        Text(word.translation)
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        if isKidsMode {
                            Text("✨ Tap the word or button to hear how it sounds! ✨")
                                .font(.caption)
                                .foregroundColor(.purple)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "6B5B95").opacity(0.1))
                    .cornerRadius(20)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        ttsService.speakArabic(word.arabic, rate: 0.3)
                    }
                    
                    // Audio button - NOW WORKING with actual TTS
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        if isPlayingThisWord {
                            ttsService.stop()
                        } else {
                            ttsService.speakArabic(word.arabic, rate: 0.3)
                        }
                    }) {
                        HStack {
                            Image(systemName: isPlayingThisWord ? "stop.circle.fill" : "speaker.wave.2.fill")
                                .symbolEffect(.bounce, value: isPlayingThisWord)
                            Text(isPlayingThisWord ? "🔊 Playing..." : (isKidsMode ? "🔊 Hear Pronunciation" : "Play Pronunciation"))
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isPlayingThisWord ? Color.orange : Color(hex: "6B5B95"))
                        .cornerRadius(16)
                    }
                    
                    Text(isPlayingThisWord ? "Speaking..." : "Tap to hear")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Root word section
                    if let rootWord = word.rootWord, let rootMeaning = word.rootMeaning {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "tree")
                                    .foregroundColor(Color(hex: "6B5B95"))
                                Text(isKidsMode ? "🌱 Word Root" : "Root Word (جذر)")
                                    .font(.headline)
                            }
                            
                            HStack(spacing: 20) {
                                VStack(spacing: 4) {
                                    Text("Root")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(rootWord)
                                        .font(.title2)
                                        .foregroundColor(Color(hex: "6B5B95"))
                                }
                                
                                Divider()
                                    .frame(height: 40)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Meaning")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(rootMeaning)
                                        .font(.body)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            if isKidsMode {
                                Text("💡 Learning the root helps you understand many related words!")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                                    .padding(.top, 8)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 5)
                    }
                    
                    // Tajweed rules for this word
                    if !word.tajweedRules.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "paintpalette")
                                    .foregroundColor(Color(hex: "6B5B95"))
                                Text(isKidsMode ? "🎨 Tajweed Colors" : "Tajweed Rules Applied")
                                    .font(.headline)
                            }
                            
                            ForEach(word.tajweedRules) { rule in
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color(hex: rule.color))
                                        .frame(width: 20, height: 20)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack {
                                            Text(rule.name)
                                                .font(.subheadline.bold())
                                            Text("(\(rule.nameArabic))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Text(rule.description)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(8)
                                .background(Color(hex: rule.color).opacity(0.1))
                                .cornerRadius(8)
                            }
                            
                            if isKidsMode {
                                Text("🌈 Colors help you remember how to recite beautifully!")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                                    .padding(.top, 8)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 5)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationTitle(isKidsMode ? "📖 Word Details" : "Word Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Word By Word View

struct WordByWordView: View {
    let isKidsMode: Bool
    @State private var selectedSurah: Int = 1
    @State private var currentWordIndex: Int = 0
    
    var currentAyahs: [Ayah] {
        Ayah.getAyahs(forSurah: selectedSurah)
    }
    
    var allWords: [QuranWord] {
        currentAyahs.flatMap { $0.words }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isKidsMode ? "🔤 Learn Word by Word" : "Word-by-Word Learning")
                .font(.headline)
                .padding(.horizontal)
            
            // Surah picker
            Picker("Surah", selection: $selectedSurah) {
                Text("Al-Fatiha").tag(1)
                Text("Al-Ikhlas").tag(112)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if allWords.isEmpty {
                Text("Content coming soon...")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                // Word display
                VStack(spacing: 20) {
                    Text(allWords[currentWordIndex].arabic)
                        .font(.system(size: 80))
                    
                    Text(allWords[currentWordIndex].transliteration)
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    Text(allWords[currentWordIndex].translation)
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    // Audio button
                    Button(action: { /* TODO: Play audio */ }) {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                            Text("Listen")
                        }
                        .padding()
                        .background(Color(hex: "6B5B95"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(true)
                    .opacity(0.5)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .padding(.horizontal)
                
                // Navigation
                HStack(spacing: 20) {
                    Button(action: { if currentWordIndex > 0 { currentWordIndex -= 1 }}) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(currentWordIndex > 0 ? Color(hex: "6B5B95") : .gray)
                    }
                    .disabled(currentWordIndex == 0)
                    
                    Text("\(currentWordIndex + 1) / \(allWords.count)")
                        .font(.headline)
                    
                    Button(action: { if currentWordIndex < allWords.count - 1 { currentWordIndex += 1 }}) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(currentWordIndex < allWords.count - 1 ? Color(hex: "6B5B95") : .gray)
                    }
                    .disabled(currentWordIndex >= allWords.count - 1)
                }
                
                // Progress
                SwiftUI.ProgressView(value: Double(currentWordIndex + 1), total: Double(max(allWords.count, 1)))
                //ProgressView("Progress", value: Double(currentWordIndex + 1), total: Double(max(allWords.count, 1)))
                // ProgressView(value: Double(currentWordIndex + 1) / Double(max(allWords.count, 1)))
                //     .tint(Color(hex: "6B5B95"))
                //     .padding(.horizontal)
            }
        }
    }
}

// MARK: - Memorization Mode View

struct MemorizationModeView: View {
    let isKidsMode: Bool
    @State private var selectedSurah: Int = 112
    @State private var currentAyahIndex: Int = 0
    @State private var isLooping = false
    @State private var loopCount = 3
    @State private var showTranslation = true
    @State private var currentLoopIteration = 0
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
    var ayahs: [Ayah] {
        Ayah.getAyahs(forSurah: selectedSurah)
    }
    
    private var isPlayingCurrentAyah: Bool {
        guard !ayahs.isEmpty else { return false }
        return ttsService.isSpeaking && ttsService.currentText == ayahs[currentAyahIndex].arabic
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isKidsMode ? "🧠 Memorization Mode" : "Memorization")
                .font(.headline)
                .padding(.horizontal)
            
            // Surah picker
            Picker("Surah", selection: $selectedSurah) {
                Text("Al-Fatiha").tag(1)
                Text("Al-Ikhlas").tag(112)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onChange(of: selectedSurah) { _, _ in
                currentAyahIndex = 0
            }
            
            if ayahs.isEmpty {
                Text("Content coming soon...")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                // Current ayah
                VStack(spacing: 16) {
                    Text("Ayah \(currentAyahIndex + 1) of \(ayahs.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(ayahs[currentAyahIndex].arabic)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text(ayahs[currentAyahIndex].transliteration)
                        .font(.body)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                    
                    if showTranslation {
                        Text(ayahs[currentAyahIndex].translation)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .padding(.horizontal)
                
                // Controls
                VStack(spacing: 16) {
                    // Loop controls
                    HStack {
                        Toggle("Loop Ayah", isOn: $isLooping)
                        
                        if isLooping {
                            Stepper("×\(loopCount)", value: $loopCount, in: 1...10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Toggle("Show Translation", isOn: $showTranslation)
                        .padding(.horizontal)
                    
                    // Playback buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                            if isPlayingCurrentAyah {
                                ttsService.stop()
                                currentLoopIteration = 0
                            } else {
                                // Play the current ayah
                                playCurrentAyah()
                            }
                        }) {
                            VStack {
                                Image(systemName: isPlayingCurrentAyah ? "stop.circle.fill" : "play.circle.fill")
                                    .font(.largeTitle)
                                    .symbolEffect(.bounce, value: isPlayingCurrentAyah)
                                Text(isPlayingCurrentAyah ? "Stop" : "Play")
                                    .font(.caption)
                            }
                            .foregroundColor(isPlayingCurrentAyah ? .orange : Color(hex: "6B5B95"))
                        }
                        
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            // Play at slower rate for call and response
                            if !ayahs.isEmpty {
                                ttsService.speakArabic(ayahs[currentAyahIndex].arabic, rate: 0.25)
                            }
                        }) {
                            VStack {
                                Image(systemName: "mic.circle.fill")
                                    .font(.largeTitle)
                                Text("Respond")
                                    .font(.caption)
                            }
                            .foregroundColor(.green)
                        }
                    }
                    
                    if isLooping && isPlayingCurrentAyah {
                        Text("Loop \(currentLoopIteration + 1) of \(loopCount)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Navigation
                HStack(spacing: 20) {
                    Button(action: { if currentAyahIndex > 0 { currentAyahIndex -= 1 }}) {
                        Text("Previous")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(currentAyahIndex > 0 ? Color(hex: "6B5B95") : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(currentAyahIndex == 0)
                    
                    Button(action: { if currentAyahIndex < ayahs.count - 1 { currentAyahIndex += 1 }}) {
                        Text("Next")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(currentAyahIndex < ayahs.count - 1 ? Color(hex: "6B5B95") : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(currentAyahIndex >= ayahs.count - 1)
                }
                
                // Progress
                SwiftUI.ProgressView(value: Double(currentAyahIndex + 1), total: Double(max(ayahs.count, 1)))
//                 ProgressView(value: Double(currentAyahIndex + 1) / Double(max(ayahs.count, 1))) {
//     EmptyView()
// }
                // ProgressView(value: Double(currentAyahIndex + 1) / Double(max(ayahs.count, 1)))
                //     .tint(Color(hex: "6B5B95"))
                //     .padding(.horizontal)
            }
        }
    }
    
    private func playCurrentAyah() {
        guard !ayahs.isEmpty else { return }
        ttsService.speakArabic(ayahs[currentAyahIndex].arabic, rate: 0.3)
    }
}

// MARK: - Tajweed Tools View

struct TajweedToolsView: View {
    let isKidsMode: Bool
    @State private var selectedRule: TajweedRule?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(isKidsMode ? "🎨 Tajweed Colors" : "Tajweed Rules")
                .font(.headline)
                .padding(.horizontal)
            
            if isKidsMode {
                Text("Each color helps you read the Quran beautifully!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            ForEach(TajweedRule.allRules) { rule in
                QuranTajweedRuleCard(rule: rule, isKidsMode: isKidsMode) {
                    selectedRule = rule
                }
            }
        }
        .sheet(item: $selectedRule) { rule in
            TajweedRuleDetailView(rule: rule, isKidsMode: isKidsMode)
        }
    }
}

struct QuranTajweedRuleCard: View {
    let rule: TajweedRule
    let isKidsMode: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Circle()
                    .fill(Color(hex: rule.color))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(rule.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(rule.nameArabic)
                            .font(.subheadline)
                            .foregroundColor(Color(hex: rule.color))
                    }
                    
                    Text(isKidsMode ? "Tap to learn more!" : rule.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

struct TajweedRuleDetailView: View {
    let rule: TajweedRule
    let isKidsMode: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Color circle
                    Circle()
                        .fill(Color(hex: rule.color))
                        .frame(width: 100, height: 100)
                    
                    // Name
                    VStack(spacing: 8) {
                        Text(rule.nameArabic)
                            .font(.largeTitle)
                        
                        Text(rule.name)
                            .font(.title2)
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What is it?")
                            .font(.headline)
                        
                        Text(rule.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    
                    // Example
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Example")
                            .font(.headline)
                        
                        Text(rule.example)
                            .font(.title2)
                            .foregroundColor(Color(hex: rule.color))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    
                    // Audio placeholder
                    Button(action: { /* TODO: Play example audio */ }) {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                            Text("Hear Example")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: rule.color))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    .disabled(true)
                    .opacity(0.5)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationTitle(rule.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Juz Amma Adventure View (Kids)

struct JuzAmmaAdventureView: View {
    let isKidsMode: Bool
    @State private var selectedAdventure: JuzAmmaAdventure?
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 8) {
                Text("🗺️ Juz Amma Adventure!")
                    .font(.title2.bold())
                
                Text("Learn the last part of the Quran - one surah at a time!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            
            // Progress overview
            HStack(spacing: 20) {
                VStack {
                    Text("0")
                        .font(.title.bold())
                        .foregroundColor(.green)
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(JuzAmmaAdventure.adventures.count)")
                        .font(.title.bold())
                        .foregroundColor(.purple)
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("0")
                        .font(.title.bold())
                        .foregroundColor(.yellow)
                    Text("Stars")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .padding(.horizontal)
            
            // Adventure map (simplified list)
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(JuzAmmaAdventure.adventures, id: \.id) { adventure in
                        JuzAmmaAdventureCard(adventure: adventure) {
                            selectedAdventure = adventure
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedAdventure) { adventure in
            SurahAdventureView(adventure: adventure)
        }
    }
}

struct JuzAmmaAdventureCard: View {
    let adventure: JuzAmmaAdventure
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Emoji with lock indicator
                ZStack {
                    Circle()
                        .fill(adventure.isUnlocked ? 
                            Color.purple.opacity(0.2) : Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    if adventure.isUnlocked {
                        Text(adventure.emoji)
                            .font(.largeTitle)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(adventure.surahName)
                            .font(.headline)
                            .foregroundColor(adventure.isUnlocked ? .primary : .gray)
                        
                        Spacer()
                        
                        Text(adventure.surahNameArabic)
                            .font(.subheadline)
                            .foregroundColor(adventure.isUnlocked ? .purple : .gray)
                    }
                    
                    Text(adventure.storyTheme)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        // Difficulty
                        Text(adventure.difficulty.rawValue)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(difficultyColor(adventure.difficulty))
                            .cornerRadius(4)
                        
                        Spacer()
                        
                        // Stars
                        HStack(spacing: 2) {
                            ForEach(0..<3) { index in
                                Image(systemName: index < adventure.starsEarned ? "star.fill" : "star")
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
                
                if adventure.isUnlocked {
                    Image(systemName: adventure.isCompleted ? "checkmark.circle.fill" : "chevron.right")
                        .foregroundColor(adventure.isCompleted ? .green : .secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .opacity(adventure.isUnlocked ? 1 : 0.6)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!adventure.isUnlocked)
        .padding(.horizontal)
    }
    
    func difficultyColor(_ difficulty: DifficultyLevel) -> Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

struct SurahAdventureView: View {
    let adventure: JuzAmmaAdventure
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Text(adventure.emoji)
                            .font(.system(size: 80))
                        
                        Text(adventure.surahNameArabic)
                            .font(.largeTitle)
                        
                        Text(adventure.surahName)
                            .font(.title2)
                        
                        Text(adventure.storyTheme)
                            .font(.headline)
                            .foregroundColor(.purple)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.2), Color.purple.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(20)
                    
                    // Learning path
                    VStack(alignment: .leading, spacing: 16) {
                        Text("🎯 Your Mission")
                            .font(.headline)
                        
                        MissionStep(number: 1, title: "Listen", description: "Hear the surah recited", isComplete: false)
                        MissionStep(number: 2, title: "Learn", description: "Understand the meaning", isComplete: false)
                        MissionStep(number: 3, title: "Practice", description: "Read along word by word", isComplete: false)
                        MissionStep(number: 4, title: "Memorize", description: "Recite from memory", isComplete: false)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    
                    // Reward preview
                    VStack(spacing: 12) {
                        Text("🏆 Reward")
                            .font(.headline)
                        
                        Text(adventure.reward)
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    
                    // Start button
                    Button(action: { /* TODO: Start surah learning */ }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Adventure!")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(16)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct MissionStep: View {
    let number: Int
    let title: String
    let description: String
    let isComplete: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isComplete ? Color.green : Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                if isComplete {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                } else {
                    Text("\(number)")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview("Kids Mode") {
    let appState = AppState()
    appState.userMode = .kids
    return QuranView()
        .environmentObject(appState)
}

#Preview("Adults Mode") {
    let appState = AppState()
    appState.userMode = .adults
    return QuranView()
        .environmentObject(appState)
}
