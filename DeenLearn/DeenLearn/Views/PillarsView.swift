//
//  PillarsView.swift
//  DeenLearn
//
//  Phase 1.2 - Pillars Tab: Foundations of Islam
//  Teaching the 5 pillars through stories (kids) and structured lessons (adults)
//

import SwiftUI

struct PillarsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPillar: Pillar?
    @State private var showPillarDetail = false
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if isKidsMode {
                    kidsWorldMapView
                } else {
                    adultsLessonCardsView
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(isKidsMode ? "🏰 Pillar Worlds" : "Five Pillars")
            .sheet(item: $selectedPillar) { pillar in
                if isKidsMode {
                    KidsPillarDetailView(pillar: pillar)
                        .environmentObject(appState)
                } else {
                    AdultsPillarDetailView(pillar: pillar)
                        .environmentObject(appState)
                }
            }
        }
    }
    
    // MARK: - Kids World Map UI
    
    var kidsWorldMapView: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Text("🗺️ Explore the Five Worlds!")
                    .font(.title2.bold())
                
                Text("Each pillar is a magical world to discover")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
            
            // Progress overview
            HStack(spacing: 16) {
                KidsProgressBadge(
                    icon: "star.fill",
                    value: "\(appState.learningProgress.pillarsCompleted)",
                    label: "Completed",
                    color: .yellow
                )
                
                KidsProgressBadge(
                    icon: "sparkles",
                    value: "\(totalStarsEarned)",
                    label: "Stars",
                    color: .orange
                )
            }
            .padding(.horizontal)
            
            // Pillar Worlds
            ForEach(Pillar.allPillars) { pillar in
                KidsPillarWorldCard(
                    pillar: pillar,
                    isCompleted: isPillarCompleted(pillar),
                    starsEarned: starsForPillar(pillar)
                ) {
                    selectedPillar = pillar
                }
            }
            
            Spacer(minLength: 40)
        }
    }
    
    // MARK: - Adults Lesson Cards View
    
    var adultsLessonCardsView: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("أركان الإسلام")
                    .font(.title)
                
                Text("The Five Pillars of Islam")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("Foundations of Muslim faith and practice")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top)
            
            // Progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Your Progress")
                        .font(.headline)
                    Spacer()
                    Text("\(appState.learningProgress.pillarsCompleted)/5 completed")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                        
                        Capsule()
                            .fill(Color(hex: "2d8b6e"))
                            .frame(width: geo.size.width * CGFloat(appState.learningProgress.pillarsCompleted) / 5)
                    }
                }
                .frame(height: 8)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .padding(.horizontal)
            
            // Pillar Cards
            ForEach(Pillar.allPillars) { pillar in
                AdultsPillarCard(
                    pillar: pillar,
                    isCompleted: isPillarCompleted(pillar)
                ) {
                    selectedPillar = pillar
                }
            }
            
            Spacer(minLength: 40)
        }
    }
    
    // MARK: - Helper Functions
    
    private func isPillarCompleted(_ pillar: Pillar) -> Bool {
        appState.completedLessons.contains("pillar-\(pillar.id)-complete")
    }
    
    private func starsForPillar(_ pillar: Pillar) -> Int {
        // Calculate based on completed activities
        var stars = 0
        if appState.completedLessons.contains("pillar-\(pillar.id)-story") { stars += 1 }
        if appState.completedLessons.contains("pillar-\(pillar.id)-game") { stars += 1 }
        if appState.completedLessons.contains("pillar-\(pillar.id)-complete") { stars += 1 }
        return stars
    }
    
    private var totalStarsEarned: Int {
        Pillar.allPillars.reduce(0) { $0 + starsForPillar($1) }
    }
}

// MARK: - Kids Progress Badge

struct KidsProgressBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3.bold())
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

// MARK: - Kids Pillar World Card

struct KidsPillarWorldCard: View {
    let pillar: Pillar
    let isCompleted: Bool
    let starsEarned: Int
    let action: () -> Void
    
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // World emoji with animation
                ZStack {
                    Circle()
                        .fill(pillar.color.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Text(pillar.worldEmoji)
                        .font(.system(size: 40))
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("World \(pillar.number)")
                            .font(.caption)
                            .foregroundColor(pillar.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(pillar.color.opacity(0.2))
                            .cornerRadius(8)
                        
                        if isCompleted {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                        }
                    }
                    
                    Text(pillar.name)
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                    
                    Text(pillar.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Stars display
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Image(systemName: index < starsEarned ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(pillar.color)
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground), pillar.color.opacity(0.1)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .shadow(color: pillar.color.opacity(0.2), radius: 10, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Adults Pillar Card

struct AdultsPillarCard: View {
    let pillar: Pillar
    let isCompleted: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    // Pillar number and icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(pillar.color.opacity(0.15))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: pillar.icon)
                            .font(.title2)
                            .foregroundColor(pillar.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Pillar \(pillar.number)")
                                .font(.caption)
                                .foregroundColor(pillar.color)
                            
                            if isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.caption)
                            }
                        }
                        
                        Text(pillar.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(pillar.nameArabic)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                
                Text(pillar.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Content preview tags
                HStack(spacing: 8) {
                    ContentTag(icon: "book.fill", text: "Definition")
                    ContentTag(icon: "text.quote", text: "Evidence")
                    ContentTag(icon: "lightbulb.fill", text: "Wisdom")
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

struct ContentTag: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption2)
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Kids Pillar Detail View

struct KidsPillarDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let pillar: Pillar
    
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text(pillar.worldEmoji)
                        .font(.system(size: 60))
                    
                    Text("World \(pillar.number): \(pillar.name)")
                        .font(.title2.bold())
                    
                    Text(pillar.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(pillar.color.opacity(0.15))
                
                // Tab selection
                Picker("Content", selection: $selectedTab) {
                    Text("📖 Stories").tag(0)
                    Text("🎮 Games").tag(1)
                    Text("🏆 Rewards").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Content
                TabView(selection: $selectedTab) {
                    kidsStoriesTab.tag(0)
                    kidsGamesTab.tag(1)
                    kidsRewardsTab.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var kidsStoriesTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("🎬 Story Episodes")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(pillar.storyEpisodes) { episode in
                    StoryEpisodeCard(episode: episode, pillarColor: pillar.color) {
                        // Mark as completed
                        appState.completeLesson("pillar-\(pillar.id)-story-\(episode.id)")
                    }
                }
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal)
        }
    }
    
    var kidsGamesTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("🎮 Mini Games")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(pillar.miniGames) { game in
                    MiniGameCard(game: game, pillarColor: pillar.color) {
                        // Start game
                        appState.completeLesson("pillar-\(pillar.id)-game-\(game.id)")
                    }
                }
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal)
        }
    }
    
    var kidsRewardsTab: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("🏆 Your Rewards")
                    .font(.headline)
                    .padding(.top)
                
                // Stars earned
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        VStack {
                            Image(systemName: "star.fill")
                                .font(.largeTitle)
                                .foregroundColor(index < starsEarned ? .yellow : .gray.opacity(0.3))
                            
                            Text(starLabels[index])
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                
                // Stickers
                VStack(alignment: .leading, spacing: 12) {
                    Text("🎨 Stickers Collected")
                        .font(.subheadline.bold())
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                        ForEach(stickerEmojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(.largeTitle)
                                .opacity(starsEarned > 0 ? 1 : 0.3)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                
                // Complete pillar button
                if starsEarned >= 2 && !isPillarCompleted {
                    Button(action: completePillar) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                            Text("Complete World \(pillar.number)!")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(pillar.color)
                        .cornerRadius(16)
                    }
                }
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal)
        }
    }
    
    private var starLabels: [String] {
        ["Stories", "Games", "Master"]
    }
    
    private var stickerEmojis: [String] {
        switch pillar.id {
        case "shahada": return ["❤️", "💫", "✨", "🌟"]
        case "salah": return ["🕌", "🙏", "🌙", "⭐️"]
        case "zakat": return ["💰", "🤝", "❤️", "🎁"]
        case "sawm": return ["🌙", "🌅", "🍎", "✨"]
        case "hajj": return ["🕋", "💧", "🏔️", "🌍"]
        default: return ["⭐️", "🌟", "✨", "💫"]
        }
    }
    
    private var starsEarned: Int {
        var stars = 0
        if appState.completedLessons.contains(where: { $0.contains("pillar-\(pillar.id)-story") }) { stars += 1 }
        if appState.completedLessons.contains(where: { $0.contains("pillar-\(pillar.id)-game") }) { stars += 1 }
        if appState.completedLessons.contains("pillar-\(pillar.id)-complete") { stars += 1 }
        return stars
    }
    
    private var isPillarCompleted: Bool {
        appState.completedLessons.contains("pillar-\(pillar.id)-complete")
    }
    
    private func completePillar() {
        appState.completeLesson("pillar-\(pillar.id)-complete", points: 50)
        appState.completePillar()
    }
}

struct StoryEpisodeCard: View {
    let episode: StoryEpisode
    let pillarColor: Color
    let action: () -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { isExpanded.toggle() }}) {
                HStack {
                    Text(episode.emoji)
                        .font(.title)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(episode.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Narrated by \(episode.narrator)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(pillarColor)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(episode.content)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(pillarColor.opacity(0.1))
                    .cornerRadius(12)
                
                Button(action: action) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("I finished this story!")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(pillarColor)
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

struct MiniGameCard: View {
    let game: MiniGame
    let pillarColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(pillarColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: game.icon)
                        .font(.title2)
                        .foregroundColor(pillarColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(game.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("Play!")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(pillarColor)
                    .cornerRadius(20)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Adults Pillar Detail View

struct AdultsPillarDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let pillar: Pillar
    
    @State private var selectedSection = 0
    @State private var showFiqhDifferences = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(pillar.color.opacity(0.15))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: pillar.icon)
                                .font(.largeTitle)
                                .foregroundColor(pillar.color)
                        }
                        
                        Text(pillar.nameArabic)
                            .font(.title)
                        
                        Text(pillar.name)
                            .font(.title2.bold())
                        
                        Text(pillar.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Section picker
                    Picker("Section", selection: $selectedSection) {
                        Text("Overview").tag(0)
                        Text("Evidence").tag(1)
                        Text("Scenarios").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Content based on selection
                    switch selectedSection {
                    case 0:
                        overviewSection
                    case 1:
                        evidenceSection
                    case 2:
                        scenariosSection
                    default:
                        overviewSection
                    }
                    
                    // Fiqh Differences Toggle
                    if !pillar.fiqhDifferences.isEmpty {
                        fiqhDifferencesSection
                    }
                    
                    // Mark as complete button
                    if !isPillarCompleted {
                        Button(action: completePillar) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Mark as Complete")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(pillar.color)
                            .cornerRadius(16)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var overviewSection: some View {
        VStack(spacing: 16) {
            // Definition
            LessonCard(
                title: "Definition",
                icon: "book.fill",
                content: pillar.definition,
                color: pillar.color
            )
            
            // Wisdom
            LessonCard(
                title: "Wisdom & Benefits",
                icon: "lightbulb.fill",
                content: pillar.wisdom,
                color: .orange
            )
            
            // Practical Application
            LessonCard(
                title: "Practical Application",
                icon: "hands.sparkles.fill",
                content: pillar.practicalApplication,
                color: .green
            )
        }
        .padding(.horizontal)
    }
    
    var evidenceSection: some View {
        VStack(spacing: 16) {
            // Quran Evidence
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "book.closed.fill")
                        .foregroundColor(.purple)
                    Text("Quran Evidence")
                        .font(.headline)
                }
                
                ForEach(pillar.quranEvidence) { evidence in
                    EvidenceCard(evidence: evidence, color: .purple)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Hadith Evidence
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "text.quote")
                        .foregroundColor(.green)
                    Text("Hadith Evidence")
                        .font(.headline)
                }
                
                ForEach(pillar.hadithEvidence) { evidence in
                    EvidenceCard(evidence: evidence, color: .green)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
        .padding(.horizontal)
    }
    
    var scenariosSection: some View {
        VStack(spacing: 16) {
            Text("Scenario-Based Learning")
                .font(.headline)
            
            ForEach(pillar.scenarios) { scenario in
                ScenarioCard(scenario: scenario, color: pillar.color)
            }
        }
        .padding(.horizontal)
    }
    
    var fiqhDifferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { showFiqhDifferences.toggle() }}) {
                HStack {
                    Image(systemName: "books.vertical.fill")
                        .foregroundColor(.blue)
                    
                    Text("Fiqh Differences (Optional)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: showFiqhDifferences ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if showFiqhDifferences {
                ForEach(pillar.fiqhDifferences) { diff in
                    FiqhDifferenceCard(difference: diff)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private var isPillarCompleted: Bool {
        appState.completedLessons.contains("pillar-\(pillar.id)-complete")
    }
    
    private func completePillar() {
        appState.completeLesson("pillar-\(pillar.id)-complete", points: 50)
        appState.completePillar()
    }
}

struct LessonCard: View {
    let title: String
    let icon: String
    let content: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct EvidenceCard: View {
    let evidence: Evidence
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(evidence.arabic)
                .font(.title3)
                .foregroundColor(color)
            
            Text(evidence.translation)
                .font(.body)
                .foregroundColor(.secondary)
            
            Text(evidence.reference)
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ScenarioCard: View {
    let scenario: Scenario
    let color: Color
    
    @State private var showAnswer = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(scenario.category)
                    .font(.caption)
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
            }
            
            Text(scenario.question)
                .font(.headline)
            
            Button(action: { withAnimation { showAnswer.toggle() }}) {
                HStack {
                    Text(showAnswer ? "Hide Answer" : "Show Answer")
                        .font(.subheadline)
                    Image(systemName: showAnswer ? "eye.slash" : "eye")
                }
                .foregroundColor(color)
            }
            
            if showAnswer {
                Text(scenario.answer)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct FiqhDifferenceCard: View {
    let difference: FiqhDifference
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(difference.topic)
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                FiqhRow(madhab: "Hanafi", opinion: difference.hanafi, color: .blue)
                FiqhRow(madhab: "Maliki", opinion: difference.maliki, color: .green)
                FiqhRow(madhab: "Shafi'i", opinion: difference.shafii, color: .purple)
                FiqhRow(madhab: "Hanbali", opinion: difference.hanbali, color: .orange)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }
}

struct FiqhRow: View {
    let madhab: String
    let opinion: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(madhab)
                .font(.caption.bold())
                .foregroundColor(color)
                .frame(width: 60, alignment: .leading)
            
            Text(opinion)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview

#Preview("Kids Mode") {
    let appState = AppState()
    appState.userMode = .kids
    return PillarsView()
        .environmentObject(appState)
}

#Preview("Adults Mode") {
    let appState = AppState()
    appState.userMode = .adults
    return PillarsView()
        .environmentObject(appState)
}
