//
//  HomeView.swift
//  DeenLearn
//
//  Home Tab - Central Hub with personalized dashboard
//  Phase 1.1 Implementation
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCharacterAnimation = false
    @State private var selectedQuickAction: String?
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var primaryColor: Color {
        isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e")
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let ageGreeting = appState.ageAppropriateGreeting
        
        switch hour {
        case 5..<12:
            if isKidsMode {
                return appState.ageGroup == .earlyChildhood 
                    ? "Good Morning, \(ageGreeting)! ☀️⭐" 
                    : "Good Morning, \(ageGreeting)! ☀️"
            } else {
                return "Good Morning, \(ageGreeting)"
            }
        case 12..<17:
            if isKidsMode {
                return appState.ageGroup == .earlyChildhood 
                    ? "Good Afternoon, \(ageGreeting)! 🌤️🎈" 
                    : "Good Afternoon, \(ageGreeting)! 🌤️"
            } else {
                return "Good Afternoon, \(ageGreeting)"
            }
        case 17..<21:
            if isKidsMode {
                return appState.ageGroup == .earlyChildhood 
                    ? "Good Evening, \(ageGreeting)! 🌙⭐" 
                    : "Good Evening, \(ageGreeting)! 🌙"
            } else {
                return "Good Evening, \(ageGreeting)"
            }
        default:
            return "Assalamu Alaikum, \(ageGreeting)!"
        }
    }
    
    // Age-appropriate message for kids adventure section
    var ageAppropriateAdventureText: String {
        switch appState.ageGroup {
        case .earlyChildhood:
            return "Let's play and learn! 🎈"
        case .children:
            return "Ready for an adventure?"
        case .tweens:
            return "What will you discover today?"
        default:
            return "Continue your learning journey"
        }
    }
    
    // Daily reflection prompts for adults
    let reflectionPrompts = [
        "How can you apply today's lesson in your daily life?",
        "Take a moment to reflect on Allah's blessings today.",
        "What Islamic value can you practice today?",
        "Remember: Small consistent deeds are most beloved to Allah."
    ]
    
    var dailyReflection: String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return reflectionPrompts[dayOfYear % reflectionPrompts.count]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if isKidsMode {
                        kidsHomeContent
                    } else {
                        adultsHomeContent
                    }
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(isKidsMode ? "🏠 Home" : "Home")
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                showCharacterAnimation = true
            }
        }
    }
    
    // MARK: - Kids Mode Content
    
    var kidsHomeContent: some View {
        VStack(spacing: 20) {
            // Animated Character Greeting
            animatedCharacterGreeting
            
            // Prayer Times Card
            CompactPrayerTimesWidget()
            
            // Daily Goal Cards
            dailyGoalCardsKids
            
            // Progress Rings
            progressRingsSection
            
            // Your Next Adventure Button
            nextAdventureButton
            
            // Stars, Badges, Streaks
            kidsStatsSection
            
            // Quick Actions
            quickActionsSection
            
            // Fun Reminders
            kidsRemindersSection
            
            Spacer(minLength: 40)
        }
    }
    
    // MARK: - Adults Mode Content
    
    var adultsHomeContent: some View {
        VStack(spacing: 20) {
            // Header with Greeting
            adultsHeaderCard
            
            // Prayer Times Card
            PrayerTimesCardView()
            
            // Daily Goal Cards
            dailyGoalCardsAdults
            
            // Progress Rings
            progressRingsSection
            
            // Resume Last Lesson
            resumeLastLessonCard
            
            // Reflection Prompt
            reflectionPromptCard
            
            // Quick Actions
            quickActionsSection
            
            // Reminders
            adultsRemindersSection
            
            Spacer(minLength: 40)
        }
    }
    
    // MARK: - Animated Character Greeting (Kids)
    
    var animatedCharacterGreeting: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(hex: "FF6B6B"), Color(hex: "FFE66D")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(DeviceLayout.scaled(24))
                
                HStack(spacing: 16) {
                    // Animated character
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .responsiveFrame(width: 80, height: 80)
                        
                        Text("🌟")
                            .font(.system(size: DeviceLayout.scaledFont(50)))
                            .scaleEffect(showCharacterAnimation ? 1.1 : 0.9)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: showCharacterAnimation)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(greeting)
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        
                        // Tappable Arabic greeting
                        SpeakableArabicGreeting(text: "السلام عليكم", isKidsMode: true)
                        
                        // Age-appropriate message
                        Text(ageAppropriateAdventureText)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Streak flame
                    VStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.title)
                            .foregroundColor(.orange)
                            .scaleEffect(showCharacterAnimation ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: showCharacterAnimation)
                        Text("\(appState.currentStreak)")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                        Text("streak")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(DeviceLayout.scaled(10))
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(DeviceLayout.scaled(12))
                }
                .padding(DeviceLayout.scaled(20))
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Adults Header Card
    
    var adultsHeaderCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    
                    // Tappable Arabic greeting
                    SpeakableArabicGreeting(text: "السلام عليكم", isKidsMode: false)
                }
                
                Spacer()
                
                // Streak badge
                VStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                    Text("\(appState.currentStreak)")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                }
                .padding(DeviceLayout.scaled(12))
                .background(Color.white.opacity(0.2))
                .cornerRadius(DeviceLayout.scaled(12))
            }
        }
        .padding(DeviceLayout.scaled(20))
        .background(
            LinearGradient(
                colors: [Color(hex: "1a5f4a"), Color(hex: "2d8b6e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(DeviceLayout.scaled(20))
        .padding(.horizontal)
    }
    
    // MARK: - Daily Goal Cards (Kids)
    
    var dailyGoalCardsKids: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(appState.ageGroup == .earlyChildhood ? "🎯 Let's Do This!" : "🎯 Today's Goals")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    DailyGoalCard(
                        title: appState.dailyGoalText(for: "quran"),
                        subtitle: appState.ageGroup == .earlyChildhood ? "Fun story time!" : "Surah Al-Fatiha",
                        icon: "book.fill",
                        color: .purple,
                        isCompleted: appState.dailyGoal.quranSessionCompleted,
                        isKidsMode: true,
                        onTap: {
                            appState.selectedTab = 4 // Navigate to Quran tab
                        },
                        onToggleComplete: {
                            appState.dailyGoal.quranSessionCompleted.toggle()
                            appState.updateStreakIfAllGoalsComplete()
                        }
                    )
                    
                    DailyGoalCard(
                        title: appState.dailyGoalText(for: "salah"),
                        subtitle: appState.ageGroup == .earlyChildhood ? "Watch & copy! 🙏" : "Step \(appState.learningProgress.currentSalahStep)",
                        icon: "person.fill",
                        color: .green,
                        isCompleted: appState.dailyGoal.salahPractice,
                        isKidsMode: true,
                        onTap: {
                            appState.selectedTab = 3 // Navigate to Prayer tab
                        },
                        onToggleComplete: {
                            appState.dailyGoal.salahPractice.toggle()
                            appState.updateStreakIfAllGoalsComplete()
                        }
                    )
                    
                    DailyGoalCard(
                        title: appState.dailyGoalText(for: "arabic"),
                        subtitle: appState.ageGroup == .earlyChildhood ? "Letter: \(appState.currentArabicLetter) ✨" : "Letter: \(appState.currentArabicLetter)",
                        icon: "character.textbox",
                        color: .blue,
                        isCompleted: appState.dailyGoal.arabicPractice,
                        isKidsMode: true,
                        onTap: {
                            appState.selectedTab = 5 // Navigate to Arabic tab
                        },
                        onToggleComplete: {
                            appState.dailyGoal.arabicPractice.toggle()
                            appState.updateStreakIfAllGoalsComplete()
                        }
                    )
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Daily Goal Cards (Adults)
    
    var dailyGoalCardsAdults: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Goals")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DeviceLayout.scaled(10)) {
                DailyGoalCard(
                    title: appState.dailyGoalText(for: "quran"),
                    subtitle: "\(appState.recommendedSessionMinutes)-min session",
                    icon: "book.fill",
                    color: .purple,
                    isCompleted: appState.dailyGoal.quranSessionCompleted,
                    isKidsMode: false,
                    onTap: {
                        appState.selectedTab = 4
                    },
                    onToggleComplete: {
                        appState.dailyGoal.quranSessionCompleted.toggle()
                        appState.updateStreakIfAllGoalsComplete()
                    }
                )
                
                DailyGoalCard(
                    title: appState.dailyGoalText(for: "salah"),
                    subtitle: "Step \(appState.learningProgress.currentSalahStep)",
                    icon: "person.fill",
                    color: Color(hex: "2d8b6e"),
                    isCompleted: appState.dailyGoal.salahPractice,
                    isKidsMode: false,
                    onTap: {
                        appState.selectedTab = 3
                    },
                    onToggleComplete: {
                        appState.dailyGoal.salahPractice.toggle()
                        appState.updateStreakIfAllGoalsComplete()
                    }
                )
                
                DailyGoalCard(
                    title: appState.dailyGoalText(for: "arabic"),
                    subtitle: appState.currentArabicLetter,
                    icon: "character.textbox",
                    color: .blue,
                    isCompleted: appState.dailyGoal.arabicPractice,
                    isKidsMode: false,
                    onTap: {
                        appState.selectedTab = 5
                    },
                    onToggleComplete: {
                        appState.dailyGoal.arabicPractice.toggle()
                        appState.updateStreakIfAllGoalsComplete()
                    }
                )
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Progress Rings Section
    
    var progressRingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(isKidsMode ? "⭐️ Your Progress" : "Learning Progress")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: DeviceLayout.scaled(100)), spacing: DeviceLayout.scaled(10))], spacing: DeviceLayout.scaled(10)) {
                ProgressRingCard(
                    title: "Salah",
                    titleArabic: "الصلاة",
                    progress: appState.learningProgress.salahMastery,
                    color: .green,
                    icon: "person.fill",
                    isKidsMode: isKidsMode
                )
                
                ProgressRingCard(
                    title: "Qur'an",
                    titleArabic: "القرآن",
                    progress: appState.learningProgress.quranMemorization,
                    color: .purple,
                    icon: "book.fill",
                    isKidsMode: isKidsMode
                )
                
                ProgressRingCard(
                    title: "Arabic",
                    titleArabic: "العربية",
                    progress: appState.arabicLetterProgress,
                    color: .blue,
                    icon: "character.textbox",
                    isKidsMode: isKidsMode,
                    subtitle: "\(appState.learningProgress.arabicLettersLearned)/28 letters"
                )
                
                ProgressRingCard(
                    title: "Pillars",
                    titleArabic: "الأركان",
                    progress: appState.pillarsProgress,
                    color: .orange,
                    icon: "building.columns.fill",
                    isKidsMode: isKidsMode,
                    subtitle: "\(appState.learningProgress.pillarsCompleted)/5 completed"
                )
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Next Adventure Button (Kids)
    
    var nextAdventureButton: some View {
        Button(action: {
            // Navigate to next lesson
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.yellow.opacity(0.3))
                        .responsiveFrame(width: 60, height: 60)
                    
                    Text("🚀")
                        .font(.largeTitle)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Next Adventure!")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(appState.learningProgress.lastLessonTitle ?? "Start your journey")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(hex: "FF6B6B"))
            }
            .padding(DeviceLayout.scaled(16))
            .background(Color(.systemBackground))
            .cornerRadius(DeviceLayout.scaled(16))
            .shadow(color: .black.opacity(0.08), radius: 10, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
    
    // MARK: - Kids Stats Section (Stars, Badges, Streaks)
    
    var kidsStatsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🏆 Your Achievements")
                .font(.headline)
                .padding(.horizontal)
            
            HStack(spacing: 12) {
                // Stars
                KidsStatBadge(
                    title: "Stars",
                    value: "\(appState.totalStars)",
                    icon: "star.fill",
                    color: .yellow
                )
                
                // Badges
                KidsStatBadge(
                    title: "Badges",
                    value: "\(appState.badges.filter { $0.isEarned }.count)",
                    icon: "medal.fill",
                    color: .orange
                )
                
                // Streak
                KidsStatBadge(
                    title: "Streak",
                    value: "\(appState.currentStreak)",
                    icon: "flame.fill",
                    color: .red
                )
            }
            .padding(.horizontal)
            
            // Badge showcase
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(appState.badges) { badge in
                        BadgeView(badge: badge, isKidsMode: true)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Resume Last Lesson Card (Adults)
    
    var resumeLastLessonCard: some View {
        Group {
            if let lastLesson = appState.learningProgress.lastLessonTitle {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Resume Learning")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Button(action: {
                        // Navigate to last lesson
                    }) {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: DeviceLayout.scaled(12))
                                    .fill(Color(hex: "2d8b6e").opacity(0.15))
                                    .frame(width: DeviceLayout.scaled(50), height: DeviceLayout.scaled(50))
                                
                                Image(systemName: "play.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color(hex: "2d8b6e"))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Continue: \(lastLesson)")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.primary)
                                
                                Text("Pick up where you left off")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding(DeviceLayout.scaled(16))
                        .background(Color(.systemBackground))
                        .cornerRadius(DeviceLayout.scaled(16))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)
                }
            }
        }
    }
    
    // MARK: - Reflection Prompt Card (Adults)
    
    var reflectionPromptCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Reflection")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "leaf.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "2d8b6e"))
                    
                    Text(dailyReflection)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            .padding(DeviceLayout.scaled(16))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "2d8b6e").opacity(0.1))
            .cornerRadius(DeviceLayout.scaled(16))
            .padding(.horizontal)
        }
    }
    
    // MARK: - Quick Actions Section
    
    var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(isKidsMode ? "🎮 Quick Start" : "Quick Actions")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: DeviceLayout.scaled(140), maximum: DeviceLayout.scaled(200)), spacing: DeviceLayout.scaled(12))], spacing: DeviceLayout.scaled(12)) {
                quickActionCards
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    var quickActionCards: some View {
        QuickActionCard(
            title: "Salah Trainer",
            titleArabic: "الصلاة",
            icon: "person.fill",
            color: .green,
            isKidsMode: isKidsMode
        ) {
            appState.selectedTab = 3
        }
        
        QuickActionCard(
            title: "Open Mushaf",
            titleArabic: "المصحف",
            icon: "book.fill",
            color: .purple,
            isKidsMode: isKidsMode
        ) {
            appState.selectedTab = 4
        }
        
        QuickActionCard(
            title: "Review Pillars",
            titleArabic: "الأركان",
            icon: "building.columns.fill",
            color: .orange,
            isKidsMode: isKidsMode
        ) {
            appState.selectedTab = 1
        }
        
        QuickActionCard(
            title: "Hadith",
            titleArabic: "الحديث",
            icon: "sparkles",
            color: .teal,
            isKidsMode: isKidsMode
        ) {
            appState.selectedTab = 2
        }
        
        QuickActionCard(
            title: "Practice Arabic",
            titleArabic: "العربية",
            icon: "character.textbox",
            color: .blue,
            isKidsMode: isKidsMode
        ) {
            appState.selectedTab = 5
        }
    }
    
    // MARK: - Kids Reminders Section
    
    var kidsRemindersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🔔 Reminders")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                ReminderCard(
                    title: "Time for Salah! 🕌",
                    subtitle: "Don't forget your prayers",
                    icon: "clock.fill",
                    color: .green,
                    isKidsMode: true
                ) {
                    appState.selectedTab = 3 // Prayer tab
                }
                
                ReminderCard(
                    title: "5-Minute Qur'an Session 📖",
                    subtitle: "A little learning every day!",
                    icon: "book.fill",
                    color: .purple,
                    isKidsMode: true
                ) {
                    appState.selectedTab = 4 // Quran tab
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Adults Reminders Section
    
    var adultsRemindersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Reminders")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    appState.remindersEnabled.toggle()
                }) {
                    Image(systemName: appState.remindersEnabled ? "bell.fill" : "bell.slash.fill")
                        .foregroundColor(appState.remindersEnabled ? Color(hex: "2d8b6e") : .secondary)
                }
            }
            .padding(.horizontal)
            
            if appState.remindersEnabled {
                VStack(spacing: 12) {
                    ReminderCard(
                        title: "Prayer Times",
                        subtitle: appState.prayerTimesEnabled ? "Notifications enabled" : "Tap to enable notifications",
                        icon: "clock.fill",
                        color: Color(hex: "2d8b6e"),
                        isKidsMode: false
                    ) {
                        appState.selectedTab = 3 // Prayer tab
                    }
                    
                    ReminderCard(
                        title: "5-Minute Qur'an Session",
                        subtitle: "Daily consistent practice",
                        icon: "book.fill",
                        color: .purple,
                        isKidsMode: false
                    ) {
                        appState.selectedTab = 4 // Quran tab
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Supporting Views

struct DailyGoalCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isCompleted: Bool
    let isKidsMode: Bool
    var onTap: (() -> Void)? = nil
    var onToggleComplete: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: DeviceLayout.scaled(10)) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: DeviceLayout.scaled(isKidsMode ? 40 : 32), height: DeviceLayout.scaled(isKidsMode ? 40 : 32))
                
                Image(systemName: icon)
                    .font(isKidsMode ? .body : .caption)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(isKidsMode ? .headline : .caption)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if !isCompleted {
                    Text(isKidsMode ? "Let's Go! →" : "Start →")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(color)
                }
            }
            
            Spacer(minLength: 0)
            
            Button(action: {
                onToggleComplete?()
            }) {
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(isKidsMode ? .title2 : .body)
                } else {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: DeviceLayout.scaled(isKidsMode ? 24 : 20), height: DeviceLayout.scaled(isKidsMode ? 24 : 20))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(DeviceLayout.scaled(isKidsMode ? 16 : 10))
        .frame(maxWidth: isKidsMode ? DeviceLayout.scaled(160) : .infinity, minHeight: isKidsMode ? DeviceLayout.scaled(150) : nil)
        .background(Color(.systemBackground))
        .cornerRadius(DeviceLayout.scaled(16))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
    }
}

struct ProgressRingCard: View {
    let title: String
    let titleArabic: String
    let progress: Double
    let color: Color
    let icon: String
    let isKidsMode: Bool
    var subtitle: String? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // Background ring
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: isKidsMode ? 10 : 8)
                    .frame(width: DeviceLayout.scaled(70), height: DeviceLayout.scaled(70))
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: isKidsMode ? 10 : 8, lineCap: .round))
                    .frame(width: DeviceLayout.scaled(70), height: DeviceLayout.scaled(70))
                    .rotationEffect(.degrees(-90))
                
                // Center content
                VStack(spacing: 2) {
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundColor(color)
                    Text("\(Int(progress * 100))%")
                        .font(.caption2.bold())
                }
            }
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption.bold())
                
                Text(titleArabic)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(DeviceLayout.scaled(12))
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(DeviceLayout.scaled(16))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

struct KidsStatBadge: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: DeviceLayout.scaled(50), height: DeviceLayout.scaled(50))
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.headline.bold())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(DeviceLayout.scaled(12))
        .background(Color(.systemBackground))
        .cornerRadius(DeviceLayout.scaled(16))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

struct BadgeView: View {
    let badge: Badge
    let isKidsMode: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(badge.isEarned ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: DeviceLayout.scaled(50), height: DeviceLayout.scaled(50))
                
                Image(systemName: badge.icon)
                    .font(.title3)
                    .foregroundColor(badge.isEarned ? .yellow : .gray)
            }
            
            Text(badge.title)
                .font(.caption2)
                .foregroundColor(badge.isEarned ? .primary : .secondary)
                .lineLimit(1)
        }
        .frame(width: DeviceLayout.scaled(70))
        .opacity(badge.isEarned ? 1 : 0.5)
    }
}

struct QuickActionCard: View {
    let title: String
    let titleArabic: String
    let icon: String
    let color: Color
    let isKidsMode: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            onTap()
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: DeviceLayout.scaled(60), height: DeviceLayout.scaled(60))
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(isKidsMode ? .headline : .subheadline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    Text(titleArabic)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(DeviceLayout.scaled(12))
            .frame(maxWidth: .infinity, minHeight: DeviceLayout.scaled(140))
            .background(Color(.systemBackground))
            .cornerRadius(DeviceLayout.scaled(16))
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct ReminderCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isKidsMode: Bool
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.15))
                        .frame(width: DeviceLayout.scaled(44), height: DeviceLayout.scaled(44))
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(isKidsMode ? .headline : .subheadline)
                        .fontWeight(.semibold)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding(DeviceLayout.scaled(16))
            .background(Color(.systemBackground))
            .cornerRadius(DeviceLayout.scaled(16))
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Speakable Arabic Greeting

struct SpeakableArabicGreeting: View {
    let text: String
    let isKidsMode: Bool
    
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
    private var isCurrentlySpeaking: Bool {
        ttsService.isSpeaking && ttsService.currentText == text
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))
            
            Image(systemName: isCurrentlySpeaking ? "speaker.wave.3.fill" : "speaker.wave.2")
                .font(.caption)
                .foregroundColor(isCurrentlySpeaking ? .yellow : .white.opacity(0.6))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            ttsService.speakArabic(text, rate: 0.35)
        }
    }
}

#Preview("Kids Mode") {
    let appState = AppState()
    appState.userMode = .kids
    appState.currentStreak = 5
    appState.totalStars = 25
    appState.learningProgress.salahMastery = 0.45
    appState.learningProgress.quranMemorization = 0.3
    appState.learningProgress.arabicLettersLearned = 10
    appState.learningProgress.pillarsCompleted = 2
    return HomeView()
        .environmentObject(appState)
}

#Preview("Adults Mode") {
    let appState = AppState()
    appState.userMode = .adults
    appState.currentStreak = 12
    appState.learningProgress.salahMastery = 0.65
    appState.learningProgress.quranMemorization = 0.4
    appState.learningProgress.arabicLettersLearned = 15
    appState.learningProgress.pillarsCompleted = 3
    appState.learningProgress.lastLessonTitle = "Wudu Steps"
    return HomeView()
        .environmentObject(appState)
}
