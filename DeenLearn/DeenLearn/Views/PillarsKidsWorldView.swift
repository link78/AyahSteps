//
//  PillarsKidsWorldView.swift
//  DeenLearn
//
//  Phase 2 - Enhanced Kids Mode for Pillars of Islam
//  Story-based worlds with mini-games, animated stories, and rewards
//

import SwiftUI

// MARK: - World Theme Configuration

struct PillarWorld: Identifiable {
    let id: String
    let pillar: Pillar
    let worldName: String
    let theme: WorldTheme
    let backgroundGradient: [Color]
    let characterName: String
    let characterEmoji: String
    let landmarks: [WorldLandmark]
    let adventures: [Adventure]
}

struct WorldTheme {
    let primaryEmoji: String
    let secondaryEmojis: [String]
    let ambientElements: [String]
    let soundDescription: String
}

struct WorldLandmark: Identifiable {
    let id: String
    let name: String
    let emoji: String
    let description: String
    let isUnlocked: Bool
    let activityType: LandmarkActivity
}

enum LandmarkActivity {
    case story
    case miniGame
    case quiz
    case reward
}

struct Adventure: Identifiable {
    let id: String
    let title: String
    let description: String
    let steps: [AdventureStep]
    let reward: AdventureReward
}

struct AdventureStep: Identifiable {
    let id: String
    let instruction: String
    let emoji: String
    let duration: Int // seconds
}

struct AdventureReward {
    let stars: Int
    let badge: String?
    let characterUpgrade: String?
}

// MARK: - Pillar Worlds Data

extension PillarWorld {
    static let allWorlds: [PillarWorld] = [
        // 1. Shahada Island
        PillarWorld(
            id: "shahada-island",
            pillar: Pillar.allPillars[0],
            worldName: "Shahada Island",
            theme: WorldTheme(
                primaryEmoji: "🏝️",
                secondaryEmojis: ["🌴", "🐚", "🦀", "🌊"],
                ambientElements: ["waves", "seagulls", "palm trees"],
                soundDescription: "Ocean waves and gentle breeze"
            ),
            backgroundGradient: [Color(hex: "74b9ff"), Color(hex: "0984e3")],
            characterName: "Captain Iman",
            characterEmoji: "🧑‍✈️",
            landmarks: [
                WorldLandmark(id: "shahada-lighthouse", name: "Lighthouse of Truth", emoji: "🗼", description: "Learn the meaning of La ilaha illallah", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "shahada-beach", name: "Belief Beach", emoji: "🏖️", description: "Play the Shahada matching game", isUnlocked: true, activityType: .miniGame),
                WorldLandmark(id: "shahada-cave", name: "Cave of Wisdom", emoji: "🪨", description: "Discover stories of strong faith", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "shahada-treasure", name: "Treasure of Faith", emoji: "💎", description: "Earn your Shahada badge!", isUnlocked: false, activityType: .reward)
            ],
            adventures: [
                Adventure(
                    id: "shahada-adv-1",
                    title: "The Special Words",
                    description: "Join Captain Iman to discover the most important words!",
                    steps: [
                        AdventureStep(id: "s1", instruction: "Say 'Bismillah' to start!", emoji: "✨", duration: 3),
                        AdventureStep(id: "s2", instruction: "Listen to the Shahada", emoji: "👂", duration: 10),
                        AdventureStep(id: "s3", instruction: "Repeat after Captain Iman", emoji: "🗣️", duration: 15),
                        AdventureStep(id: "s4", instruction: "Learn what it means", emoji: "💡", duration: 20)
                    ],
                    reward: AdventureReward(stars: 3, badge: "Shahada Explorer", characterUpgrade: "Captain's Hat")
                )
            ]
        ),
        
        // 2. Salah City
        PillarWorld(
            id: "salah-city",
            pillar: Pillar.allPillars[1],
            worldName: "Salah City",
            theme: WorldTheme(
                primaryEmoji: "🏙️",
                secondaryEmojis: ["🕌", "🌇", "🏛️", "🌆"],
                ambientElements: ["adhan", "birds chirping", "gentle wind"],
                soundDescription: "Beautiful adhan echoing through the city"
            ),
            backgroundGradient: [Color(hex: "55efc4"), Color(hex: "00b894")],
            characterName: "Mayor Salim",
            characterEmoji: "👳",
            landmarks: [
                WorldLandmark(id: "salah-mosque", name: "Grand Masjid", emoji: "🕌", description: "Learn about the 5 daily prayers", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "salah-clock", name: "Prayer Clock Tower", emoji: "🕐", description: "Match prayers to their times", isUnlocked: true, activityType: .miniGame),
                WorldLandmark(id: "salah-garden", name: "Wudu Garden", emoji: "🌺", description: "Learn the steps of wudu", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "salah-school", name: "Prayer School", emoji: "🏫", description: "Practice the prayer positions", isUnlocked: true, activityType: .miniGame),
                WorldLandmark(id: "salah-medal", name: "Prayer Champion Medal", emoji: "🏅", description: "Become a Salah champion!", isUnlocked: false, activityType: .reward)
            ],
            adventures: [
                Adventure(
                    id: "salah-adv-1",
                    title: "A Day in Salah City",
                    description: "Follow Mayor Salim through all 5 prayer times!",
                    steps: [
                        AdventureStep(id: "p1", instruction: "Wake up for Fajr 🌅", emoji: "🌅", duration: 5),
                        AdventureStep(id: "p2", instruction: "Pray Dhuhr at noon ☀️", emoji: "☀️", duration: 5),
                        AdventureStep(id: "p3", instruction: "Asr in the afternoon 🌤️", emoji: "🌤️", duration: 5),
                        AdventureStep(id: "p4", instruction: "Maghrib at sunset 🌅", emoji: "🌅", duration: 5),
                        AdventureStep(id: "p5", instruction: "Isha under the stars 🌙", emoji: "🌙", duration: 5)
                    ],
                    reward: AdventureReward(stars: 5, badge: "Prayer Master", characterUpgrade: "Golden Prayer Rug")
                )
            ]
        ),
        
        // 3. Zakat Village
        PillarWorld(
            id: "zakat-village",
            pillar: Pillar.allPillars[2],
            worldName: "Zakat Village",
            theme: WorldTheme(
                primaryEmoji: "🏘️",
                secondaryEmojis: ["🏠", "🌾", "🐄", "🌻"],
                ambientElements: ["farm animals", "children playing", "market sounds"],
                soundDescription: "Happy village with friendly neighbors"
            ),
            backgroundGradient: [Color(hex: "fdcb6e"), Color(hex: "f39c12")],
            characterName: "Farmer Kareem",
            characterEmoji: "👨‍🌾",
            landmarks: [
                WorldLandmark(id: "zakat-farm", name: "Sharing Farm", emoji: "🌾", description: "Learn why we share our blessings", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "zakat-market", name: "Kindness Market", emoji: "🏪", description: "Help distribute Zakat to those in need", isUnlocked: true, activityType: .miniGame),
                WorldLandmark(id: "zakat-school", name: "Generosity School", emoji: "🏫", description: "Stories of generous companions", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "zakat-heart", name: "Heart of Gold Award", emoji: "💛", description: "Earn your generosity badge!", isUnlocked: false, activityType: .reward)
            ],
            adventures: [
                Adventure(
                    id: "zakat-adv-1",
                    title: "The Giving Garden",
                    description: "Help Farmer Kareem share the harvest!",
                    steps: [
                        AdventureStep(id: "z1", instruction: "Count your apples 🍎", emoji: "🍎", duration: 5),
                        AdventureStep(id: "z2", instruction: "Calculate 2.5% to share", emoji: "🧮", duration: 10),
                        AdventureStep(id: "z3", instruction: "Find families who need help", emoji: "👨‍👩‍👧‍👦", duration: 8),
                        AdventureStep(id: "z4", instruction: "Share with a smile! 😊", emoji: "🤝", duration: 5)
                    ],
                    reward: AdventureReward(stars: 4, badge: "Generous Heart", characterUpgrade: "Golden Basket")
                )
            ]
        ),
        
        // 4. Ramadan Mountain
        PillarWorld(
            id: "ramadan-mountain",
            pillar: Pillar.allPillars[3],
            worldName: "Ramadan Mountain",
            theme: WorldTheme(
                primaryEmoji: "🏔️",
                secondaryEmojis: ["⭐", "🌙", "✨", "🎆"],
                ambientElements: ["stars twinkling", "peaceful night", "gentle breeze"],
                soundDescription: "Magical starry night on the mountain"
            ),
            backgroundGradient: [Color(hex: "a29bfe"), Color(hex: "6c5ce7")],
            characterName: "Guide Layla",
            characterEmoji: "👩‍🦱",
            landmarks: [
                WorldLandmark(id: "sawm-suhoor", name: "Suhoor Station", emoji: "🍳", description: "Learn about the pre-dawn meal", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "sawm-summit", name: "Fasting Summit", emoji: "🏔️", description: "Climb through a day of fasting", isUnlocked: true, activityType: .miniGame),
                WorldLandmark(id: "sawm-iftar", name: "Iftar Valley", emoji: "🍽️", description: "Celebrate breaking the fast", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "sawm-laylatul", name: "Laylatul Qadr Peak", emoji: "✨", description: "Discover the Night of Power", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "sawm-eid", name: "Eid Celebration!", emoji: "🎉", description: "Celebrate completing Ramadan!", isUnlocked: false, activityType: .reward)
            ],
            adventures: [
                Adventure(
                    id: "sawm-adv-1",
                    title: "A Day of Fasting",
                    description: "Experience Ramadan with Guide Layla!",
                    steps: [
                        AdventureStep(id: "r1", instruction: "Wake up for suhoor 🌃", emoji: "🌃", duration: 5),
                        AdventureStep(id: "r2", instruction: "Make intention to fast", emoji: "💭", duration: 5),
                        AdventureStep(id: "r3", instruction: "Be patient and kind all day", emoji: "😊", duration: 10),
                        AdventureStep(id: "r4", instruction: "Break fast with dates 🌅", emoji: "🌅", duration: 5),
                        AdventureStep(id: "r5", instruction: "Thank Allah for the blessing", emoji: "🤲", duration: 5)
                    ],
                    reward: AdventureReward(stars: 5, badge: "Ramadan Champion", characterUpgrade: "Crescent Moon Cape")
                )
            ]
        ),
        
        // 5. Hajj Desert Journey
        PillarWorld(
            id: "hajj-desert",
            pillar: Pillar.allPillars[4],
            worldName: "Hajj Desert Journey",
            theme: WorldTheme(
                primaryEmoji: "🏜️",
                secondaryEmojis: ["🐪", "🕋", "⛺", "🌵"],
                ambientElements: ["desert wind", "pilgrims chanting", "caravan bells"],
                soundDescription: "Labbayk echoing through the desert"
            ),
            backgroundGradient: [Color(hex: "fab1a0"), Color(hex: "e17055")],
            characterName: "Explorer Ibrahim",
            characterEmoji: "🧔",
            landmarks: [
                WorldLandmark(id: "hajj-ihram", name: "Ihram Oasis", emoji: "🏕️", description: "Learn about the pilgrim's clothing", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "hajj-tawaf", name: "Tawaf Trail", emoji: "🔄", description: "Circle the Kaaba 7 times", isUnlocked: true, activityType: .miniGame),
                WorldLandmark(id: "hajj-safa", name: "Safa & Marwa Path", emoji: "🏃", description: "Walk like Hajar between the hills", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "hajj-arafat", name: "Mount Arafat", emoji: "⛰️", description: "The most important day of Hajj", isUnlocked: true, activityType: .story),
                WorldLandmark(id: "hajj-zamzam", name: "Zamzam Well", emoji: "💧", description: "Earn your Hajj completion badge!", isUnlocked: false, activityType: .reward)
            ],
            adventures: [
                Adventure(
                    id: "hajj-adv-1",
                    title: "The Pilgrimage Path",
                    description: "Follow the footsteps of millions with Explorer Ibrahim!",
                    steps: [
                        AdventureStep(id: "h1", instruction: "Put on Ihram clothes", emoji: "🥋", duration: 5),
                        AdventureStep(id: "h2", instruction: "Say: Labbayk Allahumma Labbayk!", emoji: "🗣️", duration: 8),
                        AdventureStep(id: "h3", instruction: "Walk around the Kaaba", emoji: "🕋", duration: 10),
                        AdventureStep(id: "h4", instruction: "Run between Safa and Marwa", emoji: "🏃", duration: 8),
                        AdventureStep(id: "h5", instruction: "Stand at Arafat", emoji: "⛰️", duration: 5),
                        AdventureStep(id: "h6", instruction: "Drink Zamzam water", emoji: "💧", duration: 5)
                    ],
                    reward: AdventureReward(stars: 6, badge: "Hajj Hero", characterUpgrade: "Pilgrim's Staff")
                )
            ]
        )
    ]
    
    static func world(for pillar: Pillar) -> PillarWorld? {
        allWorlds.first { $0.pillar.id == pillar.id }
    }
}

// MARK: - Kids World Explorer View

struct PillarsKidsWorldExplorerView: View {
    @EnvironmentObject var appState: AppState
    let world: PillarWorld
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedLandmark: WorldLandmark?
    @State private var showAdventure = false
    @State private var currentAdventure: Adventure?
    @State private var showStoryView = false
    @State private var showMiniGameView = false
    @State private var showRewardView = false
    @State private var characterBounce = false
    @State private var starsCollected = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: world.backgroundGradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Ambient elements
                ambientElementsView
                
                ScrollView {
                    VStack(spacing: 24) {
                        // World Header
                        worldHeaderView
                        
                        // Character Guide
                        characterGuideView
                        
                        // Adventure Button
                        adventureButtonView
                        
                        // Landmarks Map
                        landmarksMapView
                        
                        // Progress Section
                        progressSectionView
                        
                        Spacer(minLength: 100)
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(starsCollected)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(20)
                }
            }
            .sheet(isPresented: $showStoryView) {
                if let landmark = selectedLandmark {
                    StoryActivityView(world: world, landmark: landmark, onComplete: { stars in
                        starsCollected += stars
                    })
                    .environmentObject(appState)
                }
            }
            .sheet(isPresented: $showMiniGameView) {
                if let landmark = selectedLandmark {
                    MiniGameActivityView(world: world, landmark: landmark, onComplete: { stars in
                        starsCollected += stars
                    })
                    .environmentObject(appState)
                }
            }
            .sheet(isPresented: $showAdventure) {
                if let adventure = currentAdventure {
                    AdventureView(world: world, adventure: adventure, onComplete: { stars in
                        starsCollected += stars
                    })
                    .environmentObject(appState)
                }
            }
            .onAppear {
                loadProgress()
            }
        }
    }
    
    // MARK: - World Header
    
    var worldHeaderView: some View {
        VStack(spacing: 16) {
            // World emoji with glow
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)
                
                Text(world.theme.primaryEmoji)
                    .font(.system(size: 70))
            }
            
            Text(world.worldName)
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            
            Text(world.pillar.description)
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.top, 20)
    }
    
    // MARK: - Character Guide
    
    var characterGuideView: some View {
        HStack(spacing: 16) {
            // Character with bounce animation
            Text(world.characterEmoji)
                .font(.system(size: 50))
                .scaleEffect(characterBounce ? 1.1 : 1.0)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                        characterBounce = true
                    }
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Guide")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(world.characterName)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                Text("\"Welcome to \(world.worldName)! Let's explore together!\"")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .italic()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(20)
    }
    
    // MARK: - Adventure Button
    
    var adventureButtonView: some View {
        Button(action: {
            currentAdventure = world.adventures.first
            showAdventure = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🎯 START ADVENTURE")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                    
                    if let adventure = world.adventures.first {
                        Text(adventure.title)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                
                Spacer()
                
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.orange, Color.red],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .shadow(color: .orange.opacity(0.5), radius: 10, y: 5)
        }
    }
    
    // MARK: - Landmarks Map
    
    var landmarksMapView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🗺️ Explore Landmarks")
                .font(.title3.bold())
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(world.landmarks) { landmark in
                    LandmarkCard(landmark: landmark) {
                        selectedLandmark = landmark
                        switch landmark.activityType {
                        case .story:
                            showStoryView = true
                        case .miniGame:
                            showMiniGameView = true
                        case .quiz:
                            showMiniGameView = true
                        case .reward:
                            showRewardView = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Progress Section
    
    var progressSectionView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Your Progress")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(landmarksCompleted)/\(world.landmarks.count)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.3))
                    
                    Capsule()
                        .fill(Color.white)
                        .frame(width: geo.size.width * CGFloat(landmarksCompleted) / CGFloat(world.landmarks.count))
                }
            }
            .frame(height: 12)
            
            // Stars earned
            HStack {
                ForEach(0..<6) { index in
                    Image(systemName: index < starsCollected ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                
                Spacer()
                
                Text("\(starsCollected) stars earned")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(16)
    }
    
    // MARK: - Ambient Elements
    
    var ambientElementsView: some View {
        ZStack {
            // Floating emojis
            ForEach(0..<5, id: \.self) { index in
                FloatingEmoji(
                    emoji: world.theme.secondaryEmojis[index % world.theme.secondaryEmojis.count],
                    delay: Double(index) * 0.5
                )
            }
        }
    }
    
    // MARK: - Helpers
    
    var landmarksCompleted: Int {
        world.landmarks.filter { landmark in
            appState.completedLessons.contains("landmark-\(landmark.id)")
        }.count
    }
    
    func loadProgress() {
        starsCollected = appState.learningProgress.starsEarned
    }
}

// MARK: - Floating Emoji View

struct FloatingEmoji: View {
    let emoji: String
    let delay: Double
    
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        Text(emoji)
            .font(.system(size: 30))
            .opacity(opacity)
            .offset(y: offset)
            .position(
                x: CGFloat.random(in: 50...350),
                y: CGFloat.random(in: 100...700)
            )
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 3)
                    .repeatForever(autoreverses: true)
                    .delay(delay)
                ) {
                    offset = -20
                    opacity = 0.6
                }
            }
    }
}

// MARK: - Landmark Card

struct LandmarkCard: View {
    let landmark: WorldLandmark
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Landmark emoji
                ZStack {
                    Circle()
                        .fill(landmark.isUnlocked ? Color.white : Color.gray.opacity(0.5))
                        .frame(width: 60, height: 60)
                    
                    if landmark.isUnlocked {
                        Text(landmark.emoji)
                            .font(.system(size: 30))
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                
                Text(landmark.name)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                // Activity type indicator
                HStack(spacing: 4) {
                    Image(systemName: activityIcon)
                        .font(.caption2)
                    Text(activityLabel)
                        .font(.caption2)
                }
                .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(landmark.isUnlocked ? 0.2 : 0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!landmark.isUnlocked)
        .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    var activityIcon: String {
        switch landmark.activityType {
        case .story: return "book.fill"
        case .miniGame: return "gamecontroller.fill"
        case .quiz: return "questionmark.circle.fill"
        case .reward: return "gift.fill"
        }
    }
    
    var activityLabel: String {
        switch landmark.activityType {
        case .story: return "Story"
        case .miniGame: return "Game"
        case .quiz: return "Quiz"
        case .reward: return "Reward"
        }
    }
}

// MARK: - Story Activity View

struct StoryActivityView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let world: PillarWorld
    let landmark: WorldLandmark
    let onComplete: (Int) -> Void
    
    @State private var currentPage = 0
    @State private var showingCompletion = false
    
    var stories: [StoryEpisode] {
        world.pillar.storyEpisodes
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: world.backgroundGradient.map { $0.opacity(0.8) },
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if showingCompletion {
                    completionView
                } else {
                    storyContentView
                }
            }
            .navigationTitle(landmark.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    var storyContentView: some View {
        VStack(spacing: 24) {
            if currentPage < stories.count {
                let story = stories[currentPage]
                
                // Story emoji
                Text(story.emoji)
                    .font(.system(size: 80))
                    .padding()
                
                // Title
                Text(story.title)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                // Narrator
                HStack {
                    Image(systemName: "person.circle.fill")
                    Text("Told by \(story.narrator)")
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                
                // Story content
                ScrollView {
                    Text(story.content)
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(maxHeight: 250)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Navigation
                HStack {
                    if currentPage > 0 {
                        Button(action: { currentPage -= 1 }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                    
                    // Page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<stories.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.white : Color.white.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if currentPage < stories.count - 1 {
                            currentPage += 1
                        } else {
                            showingCompletion = true
                        }
                    }) {
                        HStack {
                            Text(currentPage < stories.count - 1 ? "Next" : "Complete")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
    }
    
    var completionView: some View {
        VStack(spacing: 24) {
            Text("🎉")
                .font(.system(size: 100))
            
            Text("Story Complete!")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            
            Text("You earned 2 stars!")
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
            
            HStack {
                ForEach(0..<2, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                }
            }
            
            Button(action: {
                appState.completedLessons.insert("landmark-\(landmark.id)")
                onComplete(2)
                dismiss()
            }) {
                Text("Collect Stars")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - Mini Game Activity View

struct MiniGameActivityView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let world: PillarWorld
    let landmark: WorldLandmark
    let onComplete: (Int) -> Void
    
    @State private var gameType: MiniGameViewType = .dragDrop
    @State private var score = 0
    @State private var showingCompletion = false
    
    enum MiniGameViewType {
        case dragDrop
        case fixPillar
        case matching
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: world.backgroundGradient.map { $0.opacity(0.8) },
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if showingCompletion {
                    gameCompletionView
                } else {
                    VStack(spacing: 20) {
                        Text("🎮 \(landmark.name)")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        Text(landmark.description)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        // Game content based on type
                        switch gameType {
                        case .dragDrop:
                            DragDropGameView(
                                pillar: world.pillar,
                                onScoreUpdate: { points in
                                    score += points
                                    if score >= 3 {
                                        showingCompletion = true
                                    }
                                }
                            )
                        case .fixPillar:
                            FixPillarGameView(
                                pillar: world.pillar,
                                onComplete: {
                                    score = 3
                                    showingCompletion = true
                                }
                            )
                        case .matching:
                            MatchingGameView(
                                pillar: world.pillar,
                                onComplete: {
                                    score = 3
                                    showingCompletion = true
                                }
                            )
                        }
                        
                        // Score display
                        HStack {
                            Text("Score: \(score)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            ForEach(0..<3, id: \.self) { index in
                                Image(systemName: index < score ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    var gameCompletionView: some View {
        VStack(spacing: 24) {
            Text("🏆")
                .font(.system(size: 100))
            
            Text("Game Complete!")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            
            Text("You earned \(min(score, 3)) stars!")
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
            
            HStack {
                ForEach(0..<min(score, 3), id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                }
            }
            
            Button(action: {
                appState.completedLessons.insert("landmark-\(landmark.id)")
                onComplete(min(score, 3))
                dismiss()
            }) {
                Text("Collect Stars")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - Drag Drop Game

struct DragDropGameView: View {
    let pillar: Pillar
    let onScoreUpdate: (Int) -> Void
    
    @State private var items: [DragItem] = []
    @State private var targets: [DropTarget] = []
    @State private var matchedPairs: Set<String> = []
    
    struct DragItem: Identifiable {
        let id: String
        let text: String
        let emoji: String
    }
    
    struct DropTarget: Identifiable {
        let id: String
        let text: String
        let matchId: String
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Match the words to their meanings!")
                .font(.headline)
                .foregroundColor(.white)
            
            // Items to drag
            VStack(spacing: 12) {
                ForEach(items) { item in
                    if !matchedPairs.contains(item.id) {
                        HStack {
                            Text(item.emoji)
                            Text(item.text)
                                .font(.subheadline.bold())
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .onTapGesture {
                            checkMatch(item: item)
                        }
                    }
                }
            }
            
            Divider()
                .background(Color.white)
            
            // Drop targets
            VStack(spacing: 12) {
                ForEach(targets) { target in
                    HStack {
                        Text(target.text)
                            .font(.subheadline)
                            .foregroundColor(matchedPairs.contains(target.matchId) ? .green : .white)
                        
                        Spacer()
                        
                        if matchedPairs.contains(target.matchId) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .onAppear {
            setupGame()
        }
    }
    
    @State private var selectedItem: DragItem?
    
    func checkMatch(item: DragItem) {
        if selectedItem == nil {
            selectedItem = item
        } else if let target = targets.first(where: { $0.matchId == item.id }) {
            matchedPairs.insert(item.id)
            onScoreUpdate(1)
            selectedItem = nil
        }
    }
    
    func setupGame() {
        // Setup based on pillar
        switch pillar.id {
        case "shahada":
            items = [
                DragItem(id: "1", text: "La ilaha", emoji: "☝️"),
                DragItem(id: "2", text: "illallah", emoji: "🤲"),
                DragItem(id: "3", text: "Muhammad", emoji: "⭐")
            ]
            targets = [
                DropTarget(id: "t1", text: "There is no god", matchId: "1"),
                DropTarget(id: "t2", text: "except Allah", matchId: "2"),
                DropTarget(id: "t3", text: "Messenger of Allah", matchId: "3")
            ]
        case "salah":
            items = [
                DragItem(id: "1", text: "Fajr", emoji: "🌅"),
                DragItem(id: "2", text: "Dhuhr", emoji: "☀️"),
                DragItem(id: "3", text: "Maghrib", emoji: "🌇")
            ]
            targets = [
                DropTarget(id: "t1", text: "Dawn prayer", matchId: "1"),
                DropTarget(id: "t2", text: "Noon prayer", matchId: "2"),
                DropTarget(id: "t3", text: "Sunset prayer", matchId: "3")
            ]
        default:
            items = [
                DragItem(id: "1", text: pillar.name, emoji: pillar.worldEmoji),
                DragItem(id: "2", text: "Islam", emoji: "☪️"),
                DragItem(id: "3", text: "Faith", emoji: "💚")
            ]
            targets = [
                DropTarget(id: "t1", text: pillar.description, matchId: "1"),
                DropTarget(id: "t2", text: "Our religion", matchId: "2"),
                DropTarget(id: "t3", text: "Belief in heart", matchId: "3")
            ]
        }
    }
}

// MARK: - Fix Pillar Game

struct FixPillarGameView: View {
    let pillar: Pillar
    let onComplete: () -> Void
    
    @State private var pieces: [PillarPiece] = []
    @State private var placedPieces: [String] = []
    
    struct PillarPiece: Identifiable {
        let id: String
        let order: Int
        let text: String
        let emoji: String
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Put the pillar back together!")
                .font(.headline)
                .foregroundColor(.white)
            
            // Building area
            VStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 50)
                        
                        if index < placedPieces.count,
                           let piece = pieces.first(where: { $0.id == placedPieces[index] }) {
                            HStack {
                                Text(piece.emoji)
                                Text(piece.text)
                                    .font(.subheadline.bold())
                            }
                            .foregroundColor(.white)
                        } else {
                            Text("Tap a piece to place here")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            
            // Available pieces
            Text("Available pieces:")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            HStack(spacing: 12) {
                ForEach(pieces.filter { !placedPieces.contains($0.id) }) { piece in
                    Button(action: {
                        placePiece(piece)
                    }) {
                        VStack {
                            Text(piece.emoji)
                                .font(.title2)
                            Text(piece.text)
                                .font(.caption2)
                        }
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .onAppear {
            setupPuzzle()
        }
    }
    
    func setupPuzzle() {
        pieces = [
            PillarPiece(id: "p1", order: 0, text: "Step 1", emoji: "1️⃣"),
            PillarPiece(id: "p2", order: 1, text: "Step 2", emoji: "2️⃣"),
            PillarPiece(id: "p3", order: 2, text: "Step 3", emoji: "3️⃣")
        ].shuffled()
    }
    
    func placePiece(_ piece: PillarPiece) {
        placedPieces.append(piece.id)
        
        if placedPieces.count == 3 {
            // Check if correct order
            let isCorrect = placedPieces.enumerated().allSatisfy { index, pieceId in
                pieces.first(where: { $0.id == pieceId })?.order == index
            }
            
            if isCorrect {
                onComplete()
            } else {
                // Reset
                placedPieces = []
            }
        }
    }
}

// MARK: - Matching Game

struct MatchingGameView: View {
    let pillar: Pillar
    let onComplete: () -> Void
    
    @State private var cards: [MatchCard] = []
    @State private var flippedCards: [String] = []
    @State private var matchedCards: Set<String> = []
    
    struct MatchCard: Identifiable {
        let id: String
        let content: String
        let pairId: String
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Find matching pairs!")
                .font(.headline)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(cards) { card in
                    CardView(
                        card: card,
                        isFlipped: flippedCards.contains(card.id) || matchedCards.contains(card.id),
                        isMatched: matchedCards.contains(card.id)
                    ) {
                        flipCard(card)
                    }
                }
            }
        }
        .onAppear {
            setupCards()
        }
    }
    
    func setupCards() {
        let pairs = [
            ("🕌", "Mosque"),
            ("📿", "Prayer"),
            ("📖", "Quran")
        ]
        
        var allCards: [MatchCard] = []
        for (index, pair) in pairs.enumerated() {
            allCards.append(MatchCard(id: "e\(index)", content: pair.0, pairId: "pair\(index)"))
            allCards.append(MatchCard(id: "t\(index)", content: pair.1, pairId: "pair\(index)"))
        }
        cards = allCards.shuffled()
    }
    
    func flipCard(_ card: MatchCard) {
        guard !matchedCards.contains(card.id), !flippedCards.contains(card.id) else { return }
        
        flippedCards.append(card.id)
        
        if flippedCards.count == 2 {
            let firstCard = cards.first { $0.id == flippedCards[0] }
            let secondCard = cards.first { $0.id == flippedCards[1] }
            
            if firstCard?.pairId == secondCard?.pairId {
                matchedCards.insert(flippedCards[0])
                matchedCards.insert(flippedCards[1])
                
                if matchedCards.count == cards.count {
                    onComplete()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                flippedCards = []
            }
        }
    }
}

struct CardView: View {
    let card: MatchingGameView.MatchCard
    let isFlipped: Bool
    let isMatched: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isMatched ? Color.green : (isFlipped ? Color.white : Color.blue))
                    .frame(height: 60)
                
                if isFlipped || isMatched {
                    Text(card.content)
                        .font(card.content.count == 1 ? .title : .caption)
                        .foregroundColor(isMatched ? .white : .black)
                } else {
                    Text("?")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(isMatched)
    }
}

// MARK: - Adventure View

struct AdventureView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let world: PillarWorld
    let adventure: Adventure
    let onComplete: (Int) -> Void
    
    @State private var currentStep = 0
    @State private var stepProgress: CGFloat = 0
    @State private var showCompletion = false
    @State private var timer: Timer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: world.backgroundGradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if showCompletion {
                    adventureCompletionView
                } else {
                    adventureStepView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Exit") {
                        timer?.invalidate()
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    var adventureStepView: some View {
        VStack(spacing: 24) {
            // Adventure title
            Text(adventure.title)
                .font(.title2.bold())
                .foregroundColor(.white)
            
            // Progress indicator
            HStack(spacing: 8) {
                ForEach(0..<adventure.steps.count, id: \.self) { index in
                    Circle()
                        .fill(index <= currentStep ? Color.white : Color.white.opacity(0.3))
                        .frame(width: 12, height: 12)
                }
            }
            
            Spacer()
            
            // Current step
            if currentStep < adventure.steps.count {
                let step = adventure.steps[currentStep]
                
                VStack(spacing: 20) {
                    Text(step.emoji)
                        .font(.system(size: 100))
                    
                    Text(step.instruction)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // Progress bar for step
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.3))
                            
                            Capsule()
                                .fill(Color.white)
                                .frame(width: geo.size.width * stepProgress)
                        }
                    }
                    .frame(height: 8)
                    .padding(.horizontal, 40)
                }
                .onAppear {
                    startStepTimer(duration: step.duration)
                }
            }
            
            Spacer()
            
            // Skip button
            Button(action: {
                timer?.invalidate()
                nextStep()
            }) {
                Text("Next Step →")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
    
    var adventureCompletionView: some View {
        VStack(spacing: 24) {
            Text("🎊")
                .font(.system(size: 100))
            
            Text("Adventure Complete!")
                .font(.largeTitle.bold())
                .foregroundColor(.white)
            
            Text(adventure.title)
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
            
            // Rewards
            VStack(spacing: 16) {
                HStack {
                    ForEach(0..<adventure.reward.stars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                    }
                }
                
                if let badge = adventure.reward.badge {
                    HStack {
                        Image(systemName: "rosette")
                            .foregroundColor(.purple)
                        Text("Badge: \(badge)")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                }
                
                if let upgrade = adventure.reward.characterUpgrade {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(.orange)
                        Text("Unlocked: \(upgrade)")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                }
            }
            
            Button(action: {
                appState.completedLessons.insert("adventure-\(adventure.id)")
                appState.learningProgress.starsEarned += adventure.reward.stars
                onComplete(adventure.reward.stars)
                dismiss()
            }) {
                Text("Claim Rewards!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)
        }
    }
    
    func startStepTimer(duration: Int) {
        stepProgress = 0
        let interval = 0.1
        let increment = CGFloat(interval) / CGFloat(duration)
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if stepProgress < 1 {
                stepProgress += increment
            } else {
                timer?.invalidate()
                nextStep()
            }
        }
    }
    
    func nextStep() {
        if currentStep < adventure.steps.count - 1 {
            currentStep += 1
            stepProgress = 0
        } else {
            showCompletion = true
        }
    }
}

// MARK: - Preview

#Preview {
    if let world = PillarWorld.allWorlds.first {
        PillarsKidsWorldExplorerView(world: world)
            .environmentObject(AppState())
    }
}
