//
//  ProfileView.swift
//  DeenLearn
//
//  Profile & Parent Dashboard Tab
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedSection: ProfileSection = .profile
    @State private var profile = UserProfile.sampleAdult
    @State private var children = ChildProfile.sampleChildren
    @State private var goals = LearningGoal.sampleGoals
    @State private var achievements = Achievement.sampleAchievements
    @State private var bookmarks = Bookmark.sampleBookmarks
    @State private var analytics = ProgressAnalytics.sample
    
    // Sheet states
    @State private var showingEditProfile = false
    @State private var showingAddChild = false
    @State private var showingAddGoal = false
    @State private var selectedChild: ChildProfile?
    @State private var selectedAchievementCategory: AchievementCategory?
    
    // Photo picker
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var profileUIImage: UIImage?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    profileHeaderCard
                    
                    // Section Selector
                    sectionSelector
                    
                    // Content based on selected section
                    switch selectedSection {
                    case .profile:
                        profileSettingsSection
                    case .goals:
                        learningGoalsSection
                    case .progress:
                        progressAnalyticsSection
                    case .bookmarks:
                        bookmarksSection
                    case .achievements:
                        achievementsSection
                    case .parentDashboard:
                        parentDashboardSection
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(appState.isKidsMode ? "My Profile" : "Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingEditProfile = true }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showingEditProfile) {
            EditProfileSheet(profile: $profile)
        }
        .sheet(isPresented: $showingAddChild) {
            AddChildSheet(children: $children)
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalSheet(goals: $goals)
        }
        .sheet(item: $selectedChild) { child in
            ChildDetailSheet(child: child)
        }
    }
    
    // MARK: - Profile Header
    
    private var profileHeaderCard: some View {
        VStack(spacing: 16) {
            // Avatar with photo picker
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                ZStack {
                    if let image = profileUIImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: DeviceLayout.scaled(100), height: DeviceLayout.scaled(100))
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(appState.isKidsMode ? Color.orange.opacity(0.2) : Color.green.opacity(0.2))
                            .responsiveFrame(width: 100, height: 100)
                        
                        Text(profile.avatarEmoji)
                            .font(.system(size: DeviceLayout.scaledFont(50)))
                    }
                    
                    // Camera badge
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: DeviceLayout.scaled(28), height: DeviceLayout.scaled(28))
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: DeviceLayout.scaledFont(13)))
                                .foregroundColor(.white)
                        )
                        .offset(x: DeviceLayout.scaled(35), y: DeviceLayout.scaled(35))
                }
            }
            .onChange(of: selectedPhotoItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        profileUIImage = uiImage
                        profile.saveProfileImage(uiImage)
                    }
                }
            }
            .onAppear {
                profileUIImage = profile.profileImage
            }
            
            // Name
            VStack(spacing: 4) {
                Text(profile.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                if !appState.isKidsMode {
                    Text(profile.email ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Stats Row
            HStack(spacing: 30) {
                statItem(value: "\(analytics.currentStreak)", label: "Day Streak", icon: "🔥")
                statItem(value: "\(achievements.filter { $0.isEarned }.count)", label: "Badges", icon: "🏅")
                statItem(value: "\(analytics.lessonsCompleted)", label: "Lessons", icon: "📚")
            }
            
            if appState.isKidsMode {
                // Kids: Show stars
                HStack(spacing: 8) {
                    Text("⭐")
                        .font(.title2)
                    Text("\(245) Stars Collected!")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    private func statItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Text(icon)
                .font(.title2)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Section Selector
    
    private var sectionSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ProfileSection.allCases.filter { section in
                    // Filter sections based on mode
                    if appState.isKidsMode {
                        return section != .parentDashboard && section != .bookmarks
                    } else {
                        return true
                    }
                }, id: \.self) { section in
                    sectionButton(section)
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private func sectionButton(_ section: ProfileSection) -> some View {
        Button(action: { selectedSection = section }) {
            VStack(spacing: 8) {
                Image(systemName: section.icon)
                    .font(.title2)
                Text(section.rawValue)
                    .font(.caption)
            }
            .frame(width: 80, height: 70)
            .background(selectedSection == section ? section.color.opacity(0.2) : Color(.systemBackground))
            .foregroundColor(selectedSection == section ? section.color : .secondary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedSection == section ? section.color : Color.clear, lineWidth: 2)
            )
        }
    }
    
    // MARK: - Profile Settings Section
    
    private var profileSettingsSection: some View {
        VStack(spacing: 16) {
            // Language Settings
            settingsCard(title: "Language Settings", icon: "globe") {
                VStack(spacing: 12) {
                    settingsToggle(title: "Show Arabic Script", isOn: $profile.showArabicScript)
                    settingsToggle(title: "Show Transliteration", isOn: $profile.showTransliteration)
                    settingsToggle(title: "Show Translation", isOn: $profile.showTranslation)
                    
                    Divider()
                    
                    HStack {
                        Text("App Language")
                        Spacer()
                        Menu {
                            ForEach(AppLanguage.allCases, id: \.self) { language in
                                Button(action: { profile.preferredLanguage = language }) {
                                    HStack {
                                        Text(language.flag)
                                        Text(language.rawValue)
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(profile.preferredLanguage.flag)
                                Text(profile.preferredLanguage.rawValue)
                                Image(systemName: "chevron.down")
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
            }
            
            // Learning Preferences
            settingsCard(title: "Learning Preferences", icon: "slider.horizontal.3") {
                VStack(spacing: 12) {
                    HStack {
                        Text("Daily Goal")
                        Spacer()
                        Picker("Daily Goal", selection: $profile.dailyGoalMinutes) {
                            ForEach([10, 15, 20, 30, 45, 60], id: \.self) { mins in
                                Text("\(mins) min").tag(mins)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    settingsToggle(title: "Daily Reminders", isOn: $profile.remindersEnabled)
                    
                    if profile.remindersEnabled {
                        DatePicker("Reminder Time", selection: Binding(
                            get: { profile.reminderTime ?? Date() },
                            set: { profile.reminderTime = $0 }
                        ), displayedComponents: .hourAndMinute)
                    }
                }
            }
            
            // Mode Toggle
            settingsCard(title: "Learning Mode", icon: "person.2.fill") {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(appState.isKidsMode ? "Kids Mode" : "Adult Mode")
                                .font(.headline)
                            Text(appState.isKidsMode ? "Fun, visual, gamified" : "Detailed, scholarly")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { appState.isKidsMode },
                            set: { _ in appState.toggleMode() }
                        ))
                    }
                }
            }
        }
    }
    
    private func settingsCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.headline)
            }
            
            content()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func settingsToggle(title: String, isOn: Binding<Bool>) -> some View {
        Toggle(title, isOn: isOn)
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
    }
    
    // MARK: - Learning Goals Section
    
    private var learningGoalsSection: some View {
        VStack(spacing: 16) {
            // Add Goal Button
            Button(action: { showingAddGoal = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add New Goal")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor.opacity(0.1))
                .foregroundColor(.accentColor)
                .cornerRadius(12)
            }
            
            // Goals List
            ForEach(goals) { goal in
                goalCard(goal)
            }
        }
    }
    
    private func goalCard(_ goal: LearningGoal) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: goal.category.icon)
                    .foregroundColor(goal.category.color)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(goal.title)
                        .font(.headline)
                    Text("\(goal.currentValue)/\(goal.targetValue) \(goal.unit)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if goal.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(goal.category.color)
                        .frame(width: geometry.size.width * goal.progress, height: 8)
                }
            }
            .frame(height: 8)
            
            if let deadline = goal.deadline {
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Due: \(deadline, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Progress Analytics Section
    
    private var progressAnalyticsSection: some View {
        VStack(spacing: 16) {
            // Overview Stats
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                analyticsStatCard(
                    title: "This Week",
                    value: "\(analytics.totalMinutesThisWeek)",
                    unit: "minutes",
                    icon: "clock.fill",
                    color: .blue
                )
                analyticsStatCard(
                    title: "This Month",
                    value: "\(analytics.totalMinutesThisMonth)",
                    unit: "minutes",
                    icon: "calendar",
                    color: .green
                )
                analyticsStatCard(
                    title: "Daily Average",
                    value: String(format: "%.1f", analytics.averageMinutesPerDay),
                    unit: "min/day",
                    icon: "chart.bar.fill",
                    color: .orange
                )
                analyticsStatCard(
                    title: "Best Streak",
                    value: "\(analytics.longestStreak)",
                    unit: "days",
                    icon: "flame.fill",
                    color: .red
                )
            }
            
            // Weekly Chart
            VStack(alignment: .leading, spacing: 12) {
                Text("This Week")
                    .font(.headline)
                
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(analytics.dailyMinutes) { day in
                        VStack {
                            Text("\(day.minutes)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.accentColor)
                                .frame(width: 30, height: CGFloat(day.minutes) * 2)
                            
                            Text(day.day)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            // Category Progress
            VStack(alignment: .leading, spacing: 12) {
                Text("Progress by Category")
                    .font(.headline)
                
                ForEach(analytics.categoryProgress) { category in
                    HStack {
                        Image(systemName: category.category.icon)
                            .foregroundColor(category.category.color)
                            .frame(width: 30)
                        
                        Text(category.category.rawValue)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("\(Int(category.percentComplete * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(category.category.color)
                                .frame(width: geometry.size.width * category.percentComplete, height: 6)
                        }
                    }
                    .frame(height: 6)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
    
    private func analyticsStatCard(title: String, value: String, unit: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Bookmarks Section
    
    private var bookmarksSection: some View {
        VStack(spacing: 16) {
            if bookmarks.isEmpty {
                emptyStateView(
                    icon: "bookmark",
                    title: "No Bookmarks",
                    message: "Save your favorite surahs, ayahs, and lessons here"
                )
            } else {
                ForEach(bookmarks) { bookmark in
                    bookmarkCard(bookmark)
                }
            }
        }
    }
    
    private func bookmarkCard(_ bookmark: Bookmark) -> some View {
        HStack(spacing: 12) {
            Image(systemName: bookmark.category.icon)
                .font(.title2)
                .foregroundColor(bookmark.category.color)
                .frame(width: 40, height: 40)
                .background(bookmark.category.color.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bookmark.title)
                    .font(.headline)
                Text(bookmark.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let note = bookmark.note {
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Achievements Section
    
    private var achievementsSection: some View {
        VStack(spacing: 16) {
            // Summary
            HStack(spacing: 20) {
                achievementSummaryItem(
                    value: achievements.filter { $0.isEarned }.count,
                    total: achievements.count,
                    label: "Earned",
                    color: .yellow
                )
                achievementSummaryItem(
                    value: analytics.currentStreak,
                    total: nil,
                    label: "Day Streak",
                    color: .red
                )
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    achievementCategoryButton(nil, label: "All")
                    ForEach(AchievementCategory.allCases, id: \.self) { category in
                        achievementCategoryButton(category, label: category.rawValue)
                    }
                }
            }
            
            // Achievements Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(achievements) { achievement in
                    achievementBadge(achievement)
                }
            }
        }
    }
    
    private func achievementCategoryButton(_ category: AchievementCategory?, label: String) -> some View {
        Button(action: { selectedAchievementCategory = category }) {
            Text(label)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(selectedAchievementCategory == category ? Color.accentColor : Color(.systemGray5))
                .foregroundColor(selectedAchievementCategory == category ? .white : .primary)
                .cornerRadius(20)
        }
    }
    
    private func achievementSummaryItem(value: Int, total: Int?, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            if let total = total {
                Text("\(value)/\(total)")
                    .font(.title2)
                    .fontWeight(.bold)
            } else {
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func achievementBadge(_ achievement: Achievement) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(achievement.isEarned ? achievement.category.color.opacity(0.2) : Color(.systemGray5))
                    .frame(width: 60, height: 60)
                
                Text(achievement.icon)
                    .font(.system(size: 30))
                    .grayscale(achievement.isEarned ? 0 : 1)
                    .opacity(achievement.isEarned ? 1 : 0.5)
            }
            
            Text(achievement.title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            if achievement.isEarned {
                Image(systemName: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Parent Dashboard Section
    
    private var parentDashboardSection: some View {
        VStack(spacing: 16) {
            // Add Child Button
            Button(action: { showingAddChild = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Child Profile")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor.opacity(0.1))
                .foregroundColor(.accentColor)
                .cornerRadius(12)
            }
            
            // Children Cards
            ForEach(children) { child in
                childProgressCard(child)
            }
            
            // Quick Settings
            settingsCard(title: "Parental Controls", icon: "lock.shield.fill") {
                VStack(spacing: 12) {
                    Toggle("Content Filtering", isOn: .constant(true))
                    Toggle("Screen Time Limits", isOn: .constant(true))
                    Toggle("Progress Reports", isOn: .constant(true))
                }
            }
        }
    }
    
    private func childProgressCard(_ child: ChildProfile) -> some View {
        Button(action: { selectedChild = child }) {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text(child.avatarEmoji)
                        .font(.system(size: 40))
                    
                    VStack(alignment: .leading) {
                        Text(child.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("Age \(child.age)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Text("🔥")
                            Text("\(child.currentStreak)")
                                .fontWeight(.bold)
                        }
                        Text("day streak")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Today's Progress
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Today's Goal")
                            .font(.subheadline)
                        Spacer()
                        Text("\(child.todayMinutes)/\(child.dailyGoalMinutes) min")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(child.dailyGoalProgress >= 1.0 ? Color.green : Color.orange)
                                .frame(width: geometry.size.width * child.dailyGoalProgress, height: 8)
                        }
                    }
                    .frame(height: 8)
                }
                
                // Quick Stats
                HStack(spacing: 20) {
                    childStatItem(value: "\(child.surahsMemorized)", label: "Surahs", icon: "📖")
                    childStatItem(value: "\(child.arabicLettersLearned)", label: "Letters", icon: "أ")
                    childStatItem(value: "\(child.totalStars)", label: "Stars", icon: "⭐")
                    childStatItem(value: "\(child.totalBadges)", label: "Badges", icon: "🏅")
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func childStatItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Text(icon)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func emptyStateView(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Profile Sections

enum ProfileSection: String, CaseIterable {
    case profile = "Settings"
    case goals = "Goals"
    case progress = "Progress"
    case bookmarks = "Bookmarks"
    case achievements = "Badges"
    case parentDashboard = "Kids"
    
    var icon: String {
        switch self {
        case .profile: return "gearshape.fill"
        case .goals: return "target"
        case .progress: return "chart.bar.fill"
        case .bookmarks: return "bookmark.fill"
        case .achievements: return "star.fill"
        case .parentDashboard: return "person.2.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .profile: return .gray
        case .goals: return .green
        case .progress: return .blue
        case .bookmarks: return .orange
        case .achievements: return .yellow
        case .parentDashboard: return .purple
        }
    }
}

// MARK: - Supporting Sheets

struct EditProfileSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var profile: UserProfile
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var previewImage: UIImage?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Info") {
                    TextField("Name", text: $profile.name)
                    TextField("Display Name", text: $profile.displayName)
                    TextField("Email", text: Binding(
                        get: { profile.email ?? "" },
                        set: { profile.email = $0.isEmpty ? nil : $0 }
                    ))
                }
                
                Section("Profile Photo") {
                    HStack {
                        if let image = previewImage ?? profile.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(Text(profile.avatarEmoji).font(.title))
                        }
                        
                        Spacer()
                        
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Label("Choose Photo", systemImage: "photo.on.rectangle")
                        }
                    }
                    
                    if previewImage != nil || profile.profileImage != nil {
                        Button(role: .destructive) {
                            previewImage = nil
                            profile.removeProfileImage()
                        } label: {
                            Label("Remove Photo", systemImage: "trash")
                        }
                    }
                }
                .onChange(of: selectedPhotoItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            previewImage = uiImage
                        }
                    }
                }
                
                Section("Avatar Emoji (used when no photo)") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                        ForEach(["👨", "👩", "👦", "👧", "🧔", "👵", "👴", "🧕", "👳‍♂️", "👳‍♀️", "🙂", "😊"], id: \.self) { emoji in
                            Button(action: { profile.avatarEmoji = emoji }) {
                                Text(emoji)
                                    .font(.title)
                                    .padding(8)
                                    .background(profile.avatarEmoji == emoji ? Color.accentColor.opacity(0.2) : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let image = previewImage {
                            profile.saveProfileImage(image)
                        }
                        dismiss()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct AddChildSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var children: [ChildProfile]
    @State private var name = ""
    @State private var age = 6
    @State private var avatar = "👦"
    @State private var dailyGoal = 15
    @State private var screenTimeLimit = 30
    
    var body: some View {
        NavigationView {
            Form {
                Section("Child Info") {
                    TextField("Name", text: $name)
                    Picker("Age", selection: $age) {
                        ForEach(4...15, id: \.self) { age in
                            Text("\(age) years").tag(age)
                        }
                    }
                }
                
                Section("Avatar") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 10) {
                        ForEach(["👦", "👧", "🧒", "👶", "🧒🏽", "👦🏽", "👧🏽", "👦🏿", "👧🏿", "🧒🏻", "👦🏻", "👧🏻"], id: \.self) { emoji in
                            Button(action: { avatar = emoji }) {
                                Text(emoji)
                                    .font(.title)
                                    .padding(8)
                                    .background(avatar == emoji ? Color.accentColor.opacity(0.2) : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Section("Settings") {
                    Picker("Daily Goal", selection: $dailyGoal) {
                        ForEach([10, 15, 20, 30], id: \.self) { mins in
                            Text("\(mins) minutes").tag(mins)
                        }
                    }
                    
                    Picker("Screen Time Limit", selection: $screenTimeLimit) {
                        ForEach([15, 20, 30, 45, 60], id: \.self) { mins in
                            Text("\(mins) minutes/day").tag(mins)
                        }
                    }
                }
            }
            .navigationTitle("Add Child")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let newChild = ChildProfile(
                            id: UUID(),
                            name: name,
                            avatarEmoji: avatar,
                            age: age,

                            createdAt: Date(),
                            totalLearningMinutes: 0,
                            currentStreak: 0,
                            longestStreak: 0,
                            surahsMemorized: 0,
                            arabicLettersLearned: 0,
                            pillarsCompleted: 0,
                            prayerStepsLearned: 0,
                            dailyGoalMinutes: dailyGoal,
                            weeklyGoalMinutes: dailyGoal * 7,
                            todayMinutes: 0,
                            weekMinutes: 0,
                            screenTimeLimit: screenTimeLimit,
                            allowedCategories: [.quran, .arabic, .pillars, .prayer],
                            parentalControlsEnabled: true,
                            totalStars: 0,
                            totalBadges: 0,
                            achievements: []
                        )
                        children.append(newChild)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct AddGoalSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var goals: [LearningGoal]
    @State private var title = ""
    @State private var category: GoalCategory = .quran
    @State private var targetValue = 10
    @State private var hasDeadline = false
    @State private var deadline = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Goal Details") {
                    TextField("Goal Title", text: $title)
                    
                    Picker("Category", selection: $category) {
                        ForEach(GoalCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                    
                    Stepper("Target: \(targetValue)", value: $targetValue, in: 1...100)
                }
                
                Section("Deadline") {
                    Toggle("Set Deadline", isOn: $hasDeadline)
                    
                    if hasDeadline {
                        DatePicker("Due Date", selection: $deadline, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ChildDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let child: ChildProfile
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        Text(child.avatarEmoji)
                            .font(.system(size: 60))
                        Text(child.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Age \(child.age)")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Stats
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        detailStatCard(title: "Total Time", value: "\(child.totalLearningMinutes)", unit: "minutes", color: .blue)
                        detailStatCard(title: "Current Streak", value: "\(child.currentStreak)", unit: "days", color: .orange)
                        detailStatCard(title: "Surahs", value: "\(child.surahsMemorized)", unit: "memorized", color: .green)
                        detailStatCard(title: "Letters", value: "\(child.arabicLettersLearned)", unit: "learned", color: .purple)
                    }
                    .padding(.horizontal)
                    
                    // Achievements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Achievements")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(child.achievements.prefix(5)) { achievement in
                                    VStack {
                                        Text(achievement.icon)
                                            .font(.system(size: 30))
                                        Text(achievement.title)
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 80)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Child Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func detailStatCard(title: String, value: String, unit: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(title)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
