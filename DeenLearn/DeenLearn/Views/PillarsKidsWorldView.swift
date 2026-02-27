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

// Enum to track which sheet to show
enum WorldSheetType: Identifiable {
    case story(WorldLandmark)
    case miniGame(WorldLandmark)
    case adventure(Adventure)
    case reward(WorldLandmark)
    
    var id: String {
        switch self {
        case .story(let landmark): return "story-\(landmark.id)"
        case .miniGame(let landmark): return "game-\(landmark.id)"
        case .adventure(let adventure): return "adventure-\(adventure.id)"
        case .reward(let landmark): return "reward-\(landmark.id)"
        }
    }
}

struct PillarsKidsWorldExplorerView: View {
    @EnvironmentObject var appState: AppState
    let world: PillarWorld
    @Environment(\.dismiss) var dismiss
    
    @State private var activeSheet: WorldSheetType?
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
            .sheet(item: $activeSheet) { sheetType in
                switch sheetType {
                case .story(let landmark):
                    StoryActivityView(world: world, landmark: landmark, onComplete: { stars in
                        starsCollected += stars
                    })
                    .environmentObject(appState)
                case .miniGame(let landmark):
                    MiniGameActivityView(world: world, landmark: landmark, onComplete: { stars in
                        starsCollected += stars
                    })
                    .environmentObject(appState)
                case .adventure(let adventure):
                    AdventureView(world: world, adventure: adventure, onComplete: { stars in
                        starsCollected += stars
                    })
                    .environmentObject(appState)
                case .reward(let landmark):
                    RewardView(world: world, landmark: landmark, onCollect: { stars in
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
            if let adventure = world.adventures.first {
                activeSheet = .adventure(adventure)
            }
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
                        switch landmark.activityType {
                        case .story:
                            activeSheet = .story(landmark)
                        case .miniGame:
                            activeSheet = .miniGame(landmark)
                        case .quiz:
                            activeSheet = .miniGame(landmark)
                        case .reward:
                            activeSheet = .reward(landmark)
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
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
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
                        ttsService.stop() // Stop any playing audio when closing
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    var storyContentView: some View {
        VStack(spacing: 24) {
            // Tap to Listen hint
            TapToListenHint(isKidsMode: true)
                .padding(.horizontal)
            
            if stories.isEmpty {
                // Fallback content for landmarks with no stories
                landmarkStoryFallbackView
            } else if currentPage < stories.count {
                let story = stories[currentPage]
                
                // Story emoji
                Text(story.emoji)
                    .font(.system(size: 80))
                    .padding()
                
                // Title - tappable
                HStack(spacing: 6) {
                    Text(story.title)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Image(systemName: ttsService.isSpeaking && ttsService.currentText == story.title ? "speaker.wave.3.fill" : "speaker.wave.2")
                        .font(.caption)
                        .foregroundColor(ttsService.isSpeaking && ttsService.currentText == story.title ? .yellow : .white.opacity(0.6))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    ttsService.speakEnglish(story.title)
                }
                
                // Narrator
                HStack {
                    Image(systemName: "person.circle.fill")
                    Text("Told by \(story.narrator)")
                }
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                
                // Story content with play button
                VStack(spacing: 8) {
                    // Play story button
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        
                        if ttsService.isSpeaking && ttsService.currentText == story.content {
                            ttsService.stop()
                        } else {
                            ttsService.speakEnglish(story.content, rate: 0.4)
                        }
                    }) {
                        HStack {
                            Image(systemName: ttsService.isSpeaking && ttsService.currentText == story.content ? "stop.circle.fill" : "play.circle.fill")
                            Text(ttsService.isSpeaking && ttsService.currentText == story.content ? "Stop Reading" : "🔊 Read Story Aloud")
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(ttsService.isSpeaking && ttsService.currentText == story.content ? Color.orange : Color.green)
                        .cornerRadius(20)
                    }
                    
                    ScrollView {
                        Text(story.content)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .frame(maxHeight: 250)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
                .padding(.horizontal)
                
                // Kids Hadith Corner
                if !world.pillar.kidsHadiths.isEmpty {
                    KidsHadithCornerView(
                        hadith: world.pillar.kidsHadiths[currentPage % world.pillar.kidsHadiths.count],
                        pillarColor: world.pillar.color
                    )
                    .padding(.horizontal)
                }
                
                // Navigation
                HStack {
                    if currentPage > 0 {
                        Button(action: {
                            ttsService.stop()
                            currentPage -= 1
                        }) {
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
                        ttsService.stop()
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
    
    // Fallback content when no stories are available - shows landmark-specific content
    var landmarkStoryFallbackView: some View {
        VStack(spacing: 24) {
            // Landmark emoji
            Text(landmark.emoji)
                .font(.system(size: 80))
                .padding()
            
            // Title
            Text(landmark.name)
                .font(.title2.bold())
                .foregroundColor(.white)
            
            // Character guide
            HStack {
                Text(world.characterEmoji)
                    .font(.largeTitle)
                Text("Guide: \(world.characterName)")
                    .foregroundColor(.white.opacity(0.9))
            }
            
            // Description content
            ScrollView {
                VStack(spacing: 16) {
                    Text(landmark.description)
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    // World-specific content
                    Text(getLandmarkContent())
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .frame(maxHeight: 250)
            .background(Color.white.opacity(0.1))
            .cornerRadius(16)
            .padding(.horizontal)
            
            // Complete button
            Button(action: {
                showingCompletion = true
            }) {
                HStack {
                    Text("Complete")
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(12)
            }
        }
    }
    
    // Get landmark-specific content based on the world and landmark
    func getLandmarkContent() -> String {
        switch world.pillar.id {
        case "shahada":
            return getShahadaLandmarkContent()
        case "salah":
            return getSalahLandmarkContent()
        case "zakat":
            return getZakatLandmarkContent()
        case "sawm":
            return getSawmLandmarkContent()
        case "hajj":
            return getHajjLandmarkContent()
        default:
            return getDefaultLandmarkContent()
        }
    }
    
    func getShahadaLandmarkContent() -> String {
        switch landmark.id {
        case "shahada-lighthouse":
            return "Welcome to the Lighthouse of Truth! 🗼\n\nThe Shahada contains the most important words in Islam:\n\n'La ilaha illallah, Muhammadur Rasulullah'\n\nThis means:\n• There is no god except Allah\n• Muhammad ﷺ is the Messenger of Allah\n\nThese words light our way like a lighthouse in the dark! ✨"
        case "shahada-beach":
            return "Welcome to Belief Beach! 🏖️\n\nThe Shahada has two parts, like two treasures on the beach:\n\n1. La ilaha illallah - We believe in only ONE God, Allah!\n\n2. Muhammadur Rasulullah - We follow Prophet Muhammad ﷺ\n\nWhen we say these words with our heart, we become Muslim! 🌟"
        case "shahada-cave":
            return "Enter the Cave of Wisdom! 🪨\n\nLong ago, Prophet Muhammad ﷺ received his first message from Allah in a cave called Hira!\n\nThe angel Jibreel came and said 'Read!' (Iqra!)\n\nFrom that cave, the light of Islam spread to the whole world!\n\nBelievers have always been strong in their faith, just like the Prophet ﷺ and his companions. 💫"
        case "shahada-treasure":
            return "You found the Treasure of Faith! 💎\n\nThe greatest treasure is not gold or jewels - it's our faith in Allah!\n\nWhen you say the Shahada with true belief:\n• You join millions of Muslims worldwide\n• Angels record your good deed\n• Your heart fills with peace\n\nYou are now a Shahada Champion! 🏆"
        default:
            return "Explore Shahada Island and discover the beauty of faith! The Shahada is the foundation of everything we believe."
        }
    }
    
    func getSalahLandmarkContent() -> String {
        switch landmark.id {
        case "salah-mosque":
            return "The Grand Masjid is where Muslims come together to pray five times a day! 🕌\n\nThe five prayers are:\n• Fajr (Dawn) 🌅\n• Dhuhr (Noon) ☀️\n• Asr (Afternoon) 🌤️\n• Maghrib (Sunset) 🌅\n• Isha (Night) 🌙\n\nEach prayer is a special time to talk to Allah!"
        case "salah-clock":
            return "The Prayer Clock Tower helps us know when it's time to pray! ⏰\n\nMuslims pray at specific times:\n• Fajr: Before sunrise\n• Dhuhr: After midday\n• Asr: In the afternoon\n• Maghrib: Right after sunset\n• Isha: At night\n\nPrayer keeps us connected to Allah all day long!"
        case "salah-garden":
            return "Welcome to the Wudu Garden! 🌺 Before we pray, we clean ourselves with wudu.\n\nSteps of Wudu:\n1. Say Bismillah\n2. Wash hands 3 times\n3. Rinse mouth 3 times\n4. Clean nose 3 times\n5. Wash face 3 times\n6. Wash arms to elbows 3 times\n7. Wipe head once\n8. Wash feet 3 times\n\nNow we're ready to pray!"
        case "salah-school":
            return "At Prayer School, we learn the prayer positions! 🏫\n\n1. Qiyam: Standing tall\n2. Ruku: Bowing to Allah\n3. Sujud: Prostrating on the ground\n4. Sitting: Between prostrations\n\nEach position shows our love and respect for Allah!"
        default:
            return "Discover the beauty of Salah - our special connection with Allah! Each prayer is a gift, helping us stay close to our Creator throughout the day."
        }
    }
    
    func getZakatLandmarkContent() -> String {
        switch landmark.id {
        case "zakat-farm":
            return "Welcome to the Sharing Farm! 🌾\n\nAllah has blessed us with so many good things. When we share, everyone is happy!\n\nZakat means giving 2.5% of our savings to help others. If you have 100 coins, you give just 2-3 coins to help people who need it.\n\nSharing makes our hearts grow bigger! 💚"
        case "zakat-market":
            return "At the Kindness Market, we learn who receives Zakat! 🏪\n\nZakat helps:\n• Poor families who don't have enough\n• People in debt who need help\n• Travelers who are far from home\n• New Muslims learning about Islam\n\nWhen we give Zakat, we spread Allah's love!"
        case "zakat-school":
            return "At Generosity School, we learn from generous people! 🏫\n\nThe Prophet Muhammad ﷺ was the most generous person. He would give everything he had to help others!\n\nThe companions were also very generous. Abu Bakr gave all his wealth for Allah's sake.\n\nGenerosity brings blessings to everyone!"
        default:
            return "Discover the joy of giving! Zakat helps us share Allah's blessings with those who need them most."
        }
    }
    
    func getSawmLandmarkContent() -> String {
        switch landmark.id {
        case "sawm-suhoor":
            return "Suhoor Station - Time for the pre-dawn meal! 🍳\n\nSuhoor is the special meal we eat before Fajr during Ramadan.\n\nThe Prophet ﷺ said there is blessing in suhoor!\n\nGood things to eat:\n• Dates 🌴\n• Water 💧\n• Oatmeal 🥣\n• Eggs 🥚\n\nEat suhoor to have energy for fasting!"
        case "sawm-summit":
            return "Welcome to the Fasting Summit! 🏔️\n\nClimbing the mountain is like fasting - it takes strength and patience!\n\nDuring fasting:\n• We don't eat or drink from Fajr to Maghrib\n• We are extra kind to everyone\n• We read more Quran\n• We make lots of dua\n\nEvery step brings us closer to Allah!"
        case "sawm-iftar":
            return "Iftar Valley - Time to break the fast! 🍽️\n\nWhen the sun sets, we say 'Allahu Akbar' and break our fast!\n\nThe Prophet ﷺ would break his fast with:\n• Fresh dates 🌴\n• Water 💧\n\nThen we pray Maghrib and enjoy a delicious meal with family and friends! 🥘"
        case "sawm-laylatul":
            return "Laylatul Qadr Peak - The Night of Power! ✨\n\nThis is the most special night of Ramadan! The Quran says it's better than 1000 months!\n\nOn this night:\n• The Quran was revealed\n• Angels come down to Earth\n• All good deeds are multiplied\n\nWe look for it in the last 10 nights of Ramadan! 🌙"
        default:
            return "Discover the blessings of fasting! Ramadan is a special month of worship, reflection, and growing closer to Allah."
        }
    }
    
    func getHajjLandmarkContent() -> String {
        switch landmark.id {
        case "hajj-ihram":
            return "Ihram Oasis - Preparing for the Sacred Journey! 🏕️\n\nIhram is the special white clothing worn during Hajj.\n\nFor men: Two white pieces of cloth\nFor women: Simple, modest clothing\n\nWearing Ihram reminds us that everyone is equal before Allah. Rich or poor, young or old - we all look the same!\n\nLabbayk Allahumma Labbayk! 🕋"
        case "hajj-tawaf":
            return "Tawaf Trail - Circling the Kaaba! 🔄\n\nTawaf means walking around the Kaaba 7 times!\n\nThe Kaaba is the House of Allah that Prophet Ibrahim built.\n\nWhile walking, pilgrims:\n• Make dua to Allah\n• Ask for forgiveness\n• Feel unity with millions of Muslims\n\nThe Kaaba is in our hearts wherever we are! 🕋"
        case "hajj-safa":
            return "Safa & Marwa Path - Following Hajar's Footsteps! 🏃\n\nLong ago, Hajar and baby Ismail were alone in the desert. Baby Ismail was thirsty!\n\nHajar ran between two hills - Safa and Marwa - seven times, looking for water.\n\nAllah rewarded her faith by making Zamzam water spring from the ground! 💧\n\nWe walk this path to remember her beautiful faith!"
        case "hajj-arafat":
            return "Mount Arafat - The Most Important Day! ⛰️\n\nThe Day of Arafat is the heart of Hajj!\n\nOn this day:\n• Pilgrims stand on Mount Arafat\n• They make dua from Dhuhr to Maghrib\n• Allah forgives their sins\n• They feel closest to Allah\n\nThe Prophet ﷺ said: 'Hajj is Arafat!' 🤲"
        default:
            return "Discover the amazing journey of Hajj! Millions of Muslims travel to Makkah to follow the footsteps of Prophet Ibrahim."
        }
    }
    
    func getDefaultLandmarkContent() -> String {
        return "Welcome to \(landmark.name)! 🌟\n\n\(landmark.description)\n\nExplore this special place in \(world.worldName) with your guide \(world.characterName) \(world.characterEmoji)!"
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
    @State private var targetedDropTarget: String? = nil
    
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
                        .draggable(item.id)
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
                    .background(targetedDropTarget == target.id ? Color.white.opacity(0.4) : Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .dropDestination(for: String.self) { droppedItems, _ in
                        guard let droppedId = droppedItems.first else { return false }
                        if target.matchId == droppedId {
                            matchedPairs.insert(droppedId)
                            onScoreUpdate(1)
                            return true
                        }
                        return false
                    } isTargeted: { isTargeted in
                        targetedDropTarget = isTargeted ? target.id : nil
                    }
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
        case "zakat":
            items = [
                DragItem(id: "1", text: "2.5%", emoji: "💰"),
                DragItem(id: "2", text: "Poor", emoji: "🤲"),
                DragItem(id: "3", text: "Purify", emoji: "✨")
            ]
            targets = [
                DropTarget(id: "t1", text: "Amount we give", matchId: "1"),
                DropTarget(id: "t2", text: "Who receives Zakat", matchId: "2"),
                DropTarget(id: "t3", text: "What Zakat does to wealth", matchId: "3")
            ]
        case "sawm":
            items = [
                DragItem(id: "1", text: "Suhoor", emoji: "🌙"),
                DragItem(id: "2", text: "Iftar", emoji: "🌅"),
                DragItem(id: "3", text: "Ramadan", emoji: "☪️")
            ]
            targets = [
                DropTarget(id: "t1", text: "Pre-dawn meal", matchId: "1"),
                DropTarget(id: "t2", text: "Breaking the fast", matchId: "2"),
                DropTarget(id: "t3", text: "Month of fasting", matchId: "3")
            ]
        case "hajj":
            items = [
                DragItem(id: "1", text: "Kaaba", emoji: "🕋"),
                DragItem(id: "2", text: "Ihram", emoji: "🥋"),
                DragItem(id: "3", text: "Tawaf", emoji: "🔄")
            ]
            targets = [
                DropTarget(id: "t1", text: "House of Allah", matchId: "1"),
                DropTarget(id: "t2", text: "Pilgrim's clothing", matchId: "2"),
                DropTarget(id: "t3", text: "Walking around Kaaba", matchId: "3")
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
    @State private var targetedSlot: Int? = nil
    
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
                            .fill(targetedSlot == index ? Color.white.opacity(0.5) : Color.white.opacity(0.3))
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
                            Text("Drop a piece here")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .dropDestination(for: String.self) { droppedItems, _ in
                        guard let droppedId = droppedItems.first,
                              let piece = pieces.first(where: { $0.id == droppedId }),
                              !placedPieces.contains(droppedId),
                              index == placedPieces.count else { return false }
                        placePiece(piece)
                        return true
                    } isTargeted: { isTargeted in
                        targetedSlot = isTargeted ? index : nil
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
                    VStack {
                        Text(piece.emoji)
                            .font(.title2)
                        Text(piece.text)
                            .font(.caption2)
                    }
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .draggable(piece.id)
                }
            }
        }
        .onAppear {
            setupPuzzle()
        }
    }
    
    func setupPuzzle() {
        // Setup based on pillar
        switch pillar.id {
        case "shahada":
            pieces = [
                PillarPiece(id: "p1", order: 0, text: "La ilaha illallah", emoji: "☝️"),
                PillarPiece(id: "p2", order: 1, text: "Muhammadur", emoji: "⭐"),
                PillarPiece(id: "p3", order: 2, text: "Rasulullah", emoji: "🤲")
            ].shuffled()
        case "salah":
            pieces = [
                PillarPiece(id: "p1", order: 0, text: "Make Wudu", emoji: "💧"),
                PillarPiece(id: "p2", order: 1, text: "Face Qiblah", emoji: "🕋"),
                PillarPiece(id: "p3", order: 2, text: "Say Allahu Akbar", emoji: "🙏")
            ].shuffled()
        case "zakat":
            pieces = [
                PillarPiece(id: "p1", order: 0, text: "Count your wealth", emoji: "💰"),
                PillarPiece(id: "p2", order: 1, text: "Calculate 2.5%", emoji: "🧮"),
                PillarPiece(id: "p3", order: 2, text: "Give to the needy", emoji: "🤝")
            ].shuffled()
        case "sawm":
            pieces = [
                PillarPiece(id: "p1", order: 0, text: "Eat Suhoor", emoji: "🌙"),
                PillarPiece(id: "p2", order: 1, text: "Fast all day", emoji: "☀️"),
                PillarPiece(id: "p3", order: 2, text: "Break fast at Maghrib", emoji: "🌅")
            ].shuffled()
        case "hajj":
            pieces = [
                PillarPiece(id: "p1", order: 0, text: "Wear Ihram", emoji: "🥋"),
                PillarPiece(id: "p2", order: 1, text: "Circle the Kaaba", emoji: "🕋"),
                PillarPiece(id: "p3", order: 2, text: "Stand at Arafat", emoji: "⛰️")
            ].shuffled()
        default:
            pieces = [
                PillarPiece(id: "p1", order: 0, text: "Step 1", emoji: "1️⃣"),
                PillarPiece(id: "p2", order: 1, text: "Step 2", emoji: "2️⃣"),
                PillarPiece(id: "p3", order: 2, text: "Step 3", emoji: "3️⃣")
            ].shuffled()
        }
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
    @State private var matchedCards: Set<String> = []
    @State private var targetedCard: String? = nil
    
    struct MatchCard: Identifiable {
        let id: String
        let content: String
        let pairId: String
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Drag matching pairs together!")
                .font(.headline)
                .foregroundColor(.white)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(cards) { card in
                    CardView(
                        card: card,
                        isMatched: matchedCards.contains(card.id),
                        isTargeted: targetedCard == card.id
                    )
                    .draggable(card.id)
                    .dropDestination(for: String.self) { droppedItems, _ in
                        guard let droppedId = droppedItems.first,
                              droppedId != card.id,
                              !matchedCards.contains(card.id),
                              !matchedCards.contains(droppedId),
                              let droppedCard = cards.first(where: { $0.id == droppedId }) else { return false }
                        if droppedCard.pairId == card.pairId {
                            matchedCards.insert(card.id)
                            matchedCards.insert(droppedId)
                            if matchedCards.count == cards.count {
                                onComplete()
                            }
                            return true
                        }
                        return false
                    } isTargeted: { isTargeted in
                        targetedCard = isTargeted ? card.id : nil
                    }
                }
            }
        }
        .onAppear {
            setupCards()
        }
    }
    
    func setupCards() {
        var pairs: [(String, String)] = []
        
        // Setup based on pillar
        switch pillar.id {
        case "shahada":
            pairs = [
                ("☝️", "One God"),
                ("⭐", "Prophet"),
                ("💚", "Faith")
            ]
        case "salah":
            pairs = [
                ("🌅", "Fajr"),
                ("☀️", "Dhuhr"),
                ("🌙", "Isha")
            ]
        case "zakat":
            pairs = [
                ("💰", "Wealth"),
                ("🤲", "Give"),
                ("💚", "Purify")
            ]
        case "sawm":
            pairs = [
                ("🌙", "Suhoor"),
                ("🌅", "Iftar"),
                ("☪️", "Ramadan")
            ]
        case "hajj":
            pairs = [
                ("🕋", "Kaaba"),
                ("🐪", "Journey"),
                ("💧", "Zamzam")
            ]
        default:
            pairs = [
                ("🕌", "Mosque"),
                ("📿", "Prayer"),
                ("📖", "Quran")
            ]
        }
        
        var allCards: [MatchCard] = []
        for (index, pair) in pairs.enumerated() {
            allCards.append(MatchCard(id: "e\(index)", content: pair.0, pairId: "pair\(index)"))
            allCards.append(MatchCard(id: "t\(index)", content: pair.1, pairId: "pair\(index)"))
        }
        cards = allCards.shuffled()
    }
    
}

struct CardView: View {
    let card: MatchingGameView.MatchCard
    let isMatched: Bool
    let isTargeted: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isMatched ? Color.green : (isTargeted ? Color.white.opacity(0.8) : Color.white))
                .frame(height: 60)
            
            Text(card.content)
                .font(card.content.count == 1 ? .title : .caption)
                .foregroundColor(isMatched ? .white : .black)
        }
        .opacity(isMatched ? 0.6 : 1.0)
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

// MARK: - Reward View

struct RewardView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let world: PillarWorld
    let landmark: WorldLandmark
    let onCollect: (Int) -> Void
    
    @State private var showConfetti = false
    @State private var scaleEffect: CGFloat = 0.5
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: world.backgroundGradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    // Reward emoji
                    Text(landmark.emoji)
                        .font(.system(size: 100))
                        .scaleEffect(scaleEffect)
                        .onAppear {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                scaleEffect = 1.2
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    scaleEffect = 1.0
                                }
                            }
                        }
                    
                    Text("🎉 Congratulations! 🎉")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text(landmark.name)
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(landmark.description)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Stars reward
                    VStack(spacing: 8) {
                        Text("You earned 3 stars!")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            ForEach(0..<3, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(16)
                    
                    // Badge earned
                    HStack {
                        Image(systemName: "rosette")
                            .font(.title)
                            .foregroundColor(.purple)
                        Text("Badge: \(world.worldName) Champion!")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    Button(action: {
                        appState.completedLessons.insert("reward-\(landmark.id)")
                        appState.learningProgress.starsEarned += 3
                        onCollect(3)
                        dismiss()
                    }) {
                        Text("🎁 Collect Reward!")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 40)
                }
                .padding()
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
}

// MARK: - Kids Hadith Corner View

struct KidsHadithCornerView: View {
    let hadith: KidsHadith
    let pillarColor: Color
    @ObservedObject private var ttsService = TextToSpeechService.shared
    @State private var apiArabicText: String?
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Text(hadith.emoji)
                    .font(.title2)
                Text("Hadith Corner")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                Text("📚")
                    .font(.title2)
            }
            
            // Arabic text
            Text(apiArabicText ?? hadith.arabicText)
                .font(.title3)
                .foregroundColor(.yellow)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .contentShape(Rectangle())
                .onTapGesture {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    ttsService.speakArabic(apiArabicText ?? hadith.arabicText, rate: 0.3)
                }
            
            // Title
            Text(hadith.title)
                .font(.subheadline.bold())
                .foregroundColor(.white)
            
            // Simple meaning for kids
            Text(hadith.simpleMeaning)
                .font(.callout)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .contentShape(Rectangle())
                .onTapGesture {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    ttsService.speakEnglish(hadith.simpleMeaning, rate: 0.4)
                }
            
            // Fun fact
            HStack {
                Text("💡")
                Text(hadith.funFact)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .italic()
            }
            .padding(.horizontal)
            
            // Reference
            Text(hadith.reference)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
        .task {
            await fetchFromAPI()
        }
    }
    
    private func fetchFromAPI() async {
        let hadithService = HadithAPIService.shared
        if let apiHadith = await hadithService.fetchHadith(collection: hadith.collection, number: hadith.hadithNumber) {
            apiArabicText = apiHadith.arab
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
