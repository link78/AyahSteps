//
//  PillarsView.swift
//  DeenLearn
//
//  Phase 1.2 - Pillars Tab: Foundations of Islam
//  Phase 2 - Enhanced Kids Mode with Story-based Worlds
//  Teaching the 5 pillars through stories (kids) and structured lessons (adults)
//

import SwiftUI

struct PillarsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPillar: Pillar?
    @State private var selectedWorld: PillarWorld?
    @State private var showPillarDetail = false
    @State private var showWorldExplorer = false
    
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
                    // Phase 2: Use enhanced world explorer for kids
                    if let world = PillarWorld.world(for: pillar) {
                        PillarsKidsWorldExplorerView(world: world)
                            .environmentObject(appState)
                    } else {
                        KidsPillarDetailView(pillar: pillar)
                            .environmentObject(appState)
                    }
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
                    value: "\(appState.learningProgress.starsEarned)",
                    label: "Stars",
                    color: .orange
                )
            }
            .padding(.horizontal)
            
            // Pillar Worlds - Enhanced with themed world names
            ForEach(PillarWorld.allWorlds) { world in
                KidsPillarWorldCardEnhanced(
                    world: world,
                    isCompleted: isPillarCompleted(world.pillar),
                    starsEarned: starsForPillar(world.pillar)
                ) {
                    selectedPillar = world.pillar
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

// MARK: - Enhanced Kids Pillar World Card (Phase 2)

struct KidsPillarWorldCardEnhanced: View {
    let world: PillarWorld
    let isCompleted: Bool
    let starsEarned: Int
    let action: () -> Void
    
    @State private var isAnimating = false
    @State private var floatOffset: CGFloat = 0
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                // World themed header
                HStack(spacing: 16) {
                    // World emoji with floating animation
                    ZStack {
                        // Background glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [world.pillar.color.opacity(0.4), world.pillar.color.opacity(0.1)],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 50
                                )
                            )
                            .frame(width: 90, height: 90)
                        
                        // Main emoji
                        Text(world.theme.primaryEmoji)
                            .font(.system(size: 45))
                            .offset(y: floatOffset)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        // World label
                        HStack(spacing: 6) {
                            Text("World \(world.pillar.number)")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(world.pillar.color)
                                .cornerRadius(8)
                            
                            if isCompleted {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        
                        // World name
                        Text(world.worldName)
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                        
                        // Character guide
                        HStack(spacing: 4) {
                            Text(world.characterEmoji)
                                .font(.caption)
                            Text("Guide: \(world.characterName)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Stars display
                        HStack(spacing: 4) {
                            ForEach(0..<6, id: \.self) { index in
                                Image(systemName: index < starsEarned ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.caption2)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Play button
                    VStack {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(world.pillar.color)
                        
                        Text("Explore")
                            .font(.caption2)
                            .foregroundColor(world.pillar.color)
                    }
                }
                .padding(16)
                
                // Landmarks preview
                HStack(spacing: 12) {
                    ForEach(world.landmarks.prefix(4)) { landmark in
                        VStack(spacing: 4) {
                            Text(landmark.emoji)
                                .font(.title3)
                            Text(landmark.name.components(separatedBy: " ").first ?? "")
                                .font(.system(size: 8))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .background(world.pillar.color.opacity(0.1))
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground), world.pillar.color.opacity(0.15)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: world.pillar.color.opacity(0.3), radius: 10, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(world.pillar.color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                floatOffset = -8
            }
        }
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
    @State private var journalText = ""
    @State private var showJournalSaved = false
    @State private var selectedReflectionPrompt: ReflectionPrompt?
    
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
                    
                    // Section picker - Enhanced with more tabs
                    Picker("Section", selection: $selectedSection) {
                        Text("Overview").tag(0)
                        Text("Evidence").tag(1)
                        Text("Cases").tag(2)
                        Text("Reflect").tag(3)
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
                        caseLearningSection
                    case 3:
                        reflectionSection
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
    
    var caseLearningSection: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(pillar.color)
                    Text("Case-Based Learning")
                        .font(.headline)
                }
                
                Text("Apply your knowledge to real-life situations")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Real-life scenarios
            ForEach(pillar.scenarios) { scenario in
                EnhancedScenarioCard(scenario: scenario, color: pillar.color)
            }
            
            // Special tools based on pillar
            if pillar.id == "zakat" {
                ZakatCalculatorCard(color: pillar.color)
            }
            
            if pillar.id == "salah" {
                PrayerTimingsCard(color: pillar.color)
            }
        }
        .padding(.horizontal)
    }
    
    var reflectionSection: some View {
        VStack(spacing: 20) {
            // Reflection prompts
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.purple)
                    Text("Reflection Prompts")
                        .font(.headline)
                }
                
                Text("Take a moment to think deeply about this pillar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                ForEach(reflectionPromptsForPillar) { prompt in
                    ReflectionPromptCard(
                        prompt: prompt,
                        color: pillar.color,
                        isSelected: selectedReflectionPrompt?.id == prompt.id
                    ) {
                        withAnimation {
                            if selectedReflectionPrompt?.id == prompt.id {
                                selectedReflectionPrompt = nil
                            } else {
                                selectedReflectionPrompt = prompt
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Journaling space
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "pencil.and.outline")
                        .foregroundColor(.orange)
                    Text("Personal Journal")
                        .font(.headline)
                    
                    Spacer()
                    
                    if showJournalSaved {
                        Text("Saved ✓")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                if let prompt = selectedReflectionPrompt {
                    Text("Reflecting on: \"\(prompt.question)\"")
                        .font(.caption)
                        .foregroundColor(pillar.color)
                        .italic()
                }
                
                TextEditor(text: $journalText)
                    .frame(minHeight: 150)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        Group {
                            if journalText.isEmpty {
                                Text("Write your thoughts, reflections, and goals...")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 16)
                            }
                        },
                        alignment: .topLeading
                    )
                
                Button(action: saveJournal) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("Save Reflection")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(journalText.isEmpty ? Color.gray : pillar.color)
                    .cornerRadius(12)
                }
                .disabled(journalText.isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Daily reminder setup
            DailyReminderCard(pillar: pillar)
        }
        .padding(.horizontal)
    }
    
    // Reflection prompts for each pillar
    var reflectionPromptsForPillar: [ReflectionPrompt] {
        switch pillar.id {
        case "shahada":
            return [
                ReflectionPrompt(id: "sh1", question: "What does bearing witness to Allah's oneness mean in your daily life?", category: "Personal"),
                ReflectionPrompt(id: "sh2", question: "How has your understanding of Tawhid grown over time?", category: "Growth"),
                ReflectionPrompt(id: "sh3", question: "What can you do tomorrow to better embody the Shahada?", category: "Action")
            ]
        case "salah":
            return [
                ReflectionPrompt(id: "sa1", question: "How has Salah affected your sense of peace today?", category: "Personal"),
                ReflectionPrompt(id: "sa2", question: "What challenges do you face in maintaining khushu (concentration)?", category: "Challenge"),
                ReflectionPrompt(id: "sa3", question: "How can you improve your prayer experience this week?", category: "Action")
            ]
        case "zakat":
            return [
                ReflectionPrompt(id: "z1", question: "How does giving Zakat purify your wealth and soul?", category: "Spiritual"),
                ReflectionPrompt(id: "z2", question: "Who in your community might benefit from your Zakat?", category: "Community"),
                ReflectionPrompt(id: "z3", question: "What is your plan for calculating and distributing Zakat this year?", category: "Action")
            ]
        case "sawm":
            return [
                ReflectionPrompt(id: "sw1", question: "What spiritual benefits have you experienced from fasting?", category: "Spiritual"),
                ReflectionPrompt(id: "sw2", question: "How has fasting increased your gratitude?", category: "Personal"),
                ReflectionPrompt(id: "sw3", question: "What goals do you have for your next Ramadan?", category: "Goals")
            ]
        case "hajj":
            return [
                ReflectionPrompt(id: "h1", question: "What does the concept of Hajj mean to you spiritually?", category: "Spiritual"),
                ReflectionPrompt(id: "h2", question: "How are you preparing (financially and spiritually) for Hajj?", category: "Preparation"),
                ReflectionPrompt(id: "h3", question: "What lessons from Hajj can you apply in daily life?", category: "Application")
            ]
        default:
            return []
        }
    }
    
    private func saveJournal() {
        // Save journal entry
        let entry = JournalEntryData(
            id: UUID().uuidString,
            pillarId: pillar.id,
            promptId: selectedReflectionPrompt?.id,
            content: journalText,
            date: Date()
        )
        appState.saveJournalEntry(entry)
        
        withAnimation {
            showJournalSaved = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showJournalSaved = false
            }
        }
    }
    
    // Keep the old scenarios section as well for backward compatibility
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

// MARK: - Reflection Prompt Model

struct ReflectionPrompt: Identifiable {
    let id: String
    let question: String
    let category: String
}

// MARK: - Enhanced Scenario Card

struct EnhancedScenarioCard: View {
    let scenario: Scenario
    let color: Color
    
    @State private var showAnswer = false
    @State private var userResponse = ""
    @State private var hasSubmitted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Category badge
            HStack {
                Text(scenario.category)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(color)
                    .cornerRadius(8)
                
                Spacer()
                
                if hasSubmitted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            // Question
            Text(scenario.question)
                .font(.headline)
            
            // User can type their own answer first
            if !hasSubmitted {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your thoughts:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("Type your answer...", text: $userResponse, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                    
                    Button(action: {
                        withAnimation {
                            hasSubmitted = true
                            showAnswer = true
                        }
                    }) {
                        Text("Submit & See Answer")
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(userResponse.isEmpty ? Color.gray : color)
                            .cornerRadius(10)
                    }
                    .disabled(userResponse.isEmpty)
                }
            }
            
            // Show/Hide answer toggle
            if hasSubmitted {
                Button(action: { withAnimation { showAnswer.toggle() }}) {
                    HStack {
                        Text(showAnswer ? "Hide Scholarly Answer" : "Show Scholarly Answer")
                            .font(.subheadline)
                        Image(systemName: showAnswer ? "eye.slash" : "eye")
                    }
                    .foregroundColor(color)
                }
            }
            
            // Answer
            if showAnswer {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Scholarly Answer:")
                        .font(.caption.bold())
                        .foregroundColor(color)
                    
                    Text(scenario.answer)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(color.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

// MARK: - Reflection Prompt Card

struct ReflectionPromptCard: View {
    let prompt: ReflectionPrompt
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(prompt.category)
                        .font(.caption)
                        .foregroundColor(color)
                    
                    Text(prompt.question)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? color : .gray)
            }
            .padding()
            .background(isSelected ? color.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Daily Reminder Card

struct DailyReminderCard: View {
    let pillar: Pillar
    
    @State private var reminderEnabled = false
    @State private var reminderTime = Date()
    @State private var showTimePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundColor(.blue)
                Text("Daily Reminders")
                    .font(.headline)
            }
            
            Text("Set a daily reminder to reflect on \(pillar.name)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Toggle(isOn: $reminderEnabled) {
                HStack {
                    Image(systemName: "alarm")
                    Text("Enable reminder")
                }
            }
            .tint(pillar.color)
            
            if reminderEnabled {
                HStack {
                    Text("Reminder time:")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                // Reminder message preview
                VStack(alignment: .leading, spacing: 4) {
                    Text("You'll receive:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(reminderMessage)
                        .font(.caption)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    var reminderMessage: String {
        switch pillar.id {
        case "shahada":
            return "🌟 Take a moment to renew your intention and remember Allah's oneness."
        case "salah":
            return "🕌 Time for reflection! How has prayer enriched your day?"
        case "zakat":
            return "💝 Remember: Wealth is purified through giving. Review your Zakat plans."
        case "sawm":
            return "🌙 Fasting teaches discipline and gratitude. Reflect on its blessings."
        case "hajj":
            return "🕋 The journey of a lifetime awaits. Continue preparing your heart."
        default:
            return "Time for your daily reflection on the pillars of Islam."
        }
    }
}

// MARK: - Zakat Calculator Card

struct ZakatCalculatorCard: View {
    let color: Color
    
    @State private var showCalculator = false
    @State private var goldValue: String = ""
    @State private var silverValue: String = ""
    @State private var cashValue: String = ""
    @State private var investmentsValue: String = ""
    @State private var businessValue: String = ""
    
    var totalAssets: Double {
        (Double(goldValue) ?? 0) +
        (Double(silverValue) ?? 0) +
        (Double(cashValue) ?? 0) +
        (Double(investmentsValue) ?? 0) +
        (Double(businessValue) ?? 0)
    }
    
    var zakatAmount: Double {
        totalAssets * 0.025 // 2.5%
    }
    
    // Current nisab threshold (approximately $5,000 - should be updated)
    let nisabThreshold: Double = 5000
    
    var isAboveNisab: Bool {
        totalAssets >= nisabThreshold
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { showCalculator.toggle() }}) {
                HStack {
                    Image(systemName: "percent")
                        .foregroundColor(color)
                    
                    Text("Zakat Calculator")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: showCalculator ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if showCalculator {
                VStack(spacing: 16) {
                    Text("Enter your zakatable assets:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    AssetInputRow(label: "Gold (value)", icon: "🥇", value: $goldValue)
                    AssetInputRow(label: "Silver (value)", icon: "🥈", value: $silverValue)
                    AssetInputRow(label: "Cash & Bank", icon: "💵", value: $cashValue)
                    AssetInputRow(label: "Investments", icon: "📈", value: $investmentsValue)
                    AssetInputRow(label: "Business Assets", icon: "🏢", value: $businessValue)
                    
                    Divider()
                    
                    // Results
                    VStack(spacing: 8) {
                        HStack {
                            Text("Total Assets:")
                            Spacer()
                            Text("$\(totalAssets, specifier: "%.2f")")
                                .bold()
                        }
                        
                        HStack {
                            Text("Nisab Threshold:")
                            Spacer()
                            Text("$\(nisabThreshold, specifier: "%.2f")")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Zakat Eligible:")
                            Spacer()
                            Text(isAboveNisab ? "Yes ✓" : "No")
                                .foregroundColor(isAboveNisab ? .green : .orange)
                                .bold()
                        }
                        
                        if isAboveNisab {
                            HStack {
                                Text("Zakat Due (2.5%):")
                                Spacer()
                                Text("$\(zakatAmount, specifier: "%.2f")")
                                    .font(.title3.bold())
                                    .foregroundColor(color)
                            }
                            .padding()
                            .background(color.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    
                    Text("Note: Consult a scholar for precise calculations. Nisab varies based on current gold/silver prices.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct AssetInputRow: View {
    let label: String
    let icon: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(icon)
            Text(label)
                .font(.subheadline)
            Spacer()
            TextField("$0", text: $value)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 100)
        }
    }
}

// MARK: - Prayer Timings Card

struct PrayerTimingsCard: View {
    let color: Color
    
    @State private var showPrayerTimes = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { showPrayerTimes.toggle() }}) {
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(color)
                    
                    Text("Prayer Times Helper")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: showPrayerTimes ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if showPrayerTimes {
                VStack(spacing: 12) {
                    Text("Common questions about prayer times:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    PrayerQuestionRow(
                        question: "What if I miss Fajr?",
                        answer: "Make it up as soon as you wake up with the intention of qada (makeup prayer). Seek forgiveness and try setting multiple alarms.",
                        color: color
                    )
                    
                    PrayerQuestionRow(
                        question: "Can I combine prayers while traveling?",
                        answer: "Yes, you may shorten and combine Dhuhr with Asr, and Maghrib with Isha while traveling, according to most scholars.",
                        color: color
                    )
                    
                    PrayerQuestionRow(
                        question: "What if I forget a prayer?",
                        answer: "Pray it as soon as you remember. The Prophet ﷺ said: 'Whoever forgets a prayer, let him pray it when he remembers it.'",
                        color: color
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct PrayerQuestionRow: View {
    let question: String
    let answer: String
    let color: Color
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { withAnimation { isExpanded.toggle() }}) {
                HStack {
                    Text("Q: \(question)")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "minus.circle" : "plus.circle")
                        .foregroundColor(color)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(answer)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(color.opacity(0.1))
                    .cornerRadius(8)
            }
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
