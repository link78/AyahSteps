//
//  SalahTrainerView.swift
//  DeenLearn
//
//  Phase 3 - Enhanced Salah Trainer
//  Step-by-step animated Salah learning experience
//

import SwiftUI

// MARK: - Main Salah Trainer View

struct SalahTrainerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var ttsService = TextToSpeechService.shared
    
    @State private var currentStepIndex: Int = 0
    @State private var isPlaying: Bool = false
    @State private var showArabic: Bool = true
    @State private var showTransliteration: Bool = true
    @State private var showTranslation: Bool = true
    @State private var audioSpeed: AudioSpeed = .normal
    @State private var isPracticeMode: Bool = false
    @State private var completedSteps: Set<Int> = []
    @State private var earnedStickers: Int = 0
    @State private var showCompletionSheet: Bool = false
    @State private var animationPhase: Double = 0
    
    let salahType: SalahType
    let steps: [EnhancedSalahStep]
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var currentStep: EnhancedSalahStep {
        steps[currentStepIndex]
    }
    
    var progress: Double {
        Double(currentStepIndex + 1) / Double(steps.count)
    }
    
    init(salahType: SalahType = .twoRakah) {
        self.salahType = salahType
        self.steps = EnhancedSalahStep.stepsFor(salahType)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                backgroundGradient
                
                VStack(spacing: 0) {
                    // Progress Bar
                    progressHeader
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Animation Area
                            animationArea
                            
                            // Step Info
                            stepInfoCard
                            
                            // Recitation Display (if any)
                            if let recitation = currentStep.recitation {
                                recitationCard(recitation)
                            }
                            
                            // Audio Controls
                            if !isKidsMode {
                                audioControlsCard
                            }
                            
                            // Display Toggles
                            displayTogglesCard
                            
                            // Tips Section
                            if !currentStep.tips.isEmpty {
                                tipsCard
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding()
                    }
                    
                    // Bottom Navigation
                    bottomNavigation
                }
            }
            .navigationTitle(isKidsMode ? "🕌 \(salahType.kidsName)" : salahType.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPracticeMode.toggle() }) {
                        Label(
                            isPracticeMode ? "Guided" : "Practice",
                            systemImage: isPracticeMode ? "play.fill" : "hand.tap"
                        )
                    }
                }
            }
            .sheet(isPresented: $showCompletionSheet) {
                completionView
            }
        }
    }
    
    // MARK: - Background
    
    var backgroundGradient: some View {
        LinearGradient(
            colors: isKidsMode ?
                [Color(hex: "FFF5E6"), Color(hex: "FFE4CC")] :
                [Color(hex: "f5f9f7"), Color(hex: "e8f5e9")],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Progress Header
    
    var progressHeader: some View {
        VStack(spacing: 8) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: isKidsMode ?
                                    [Color(hex: "FF6B6B"), Color(hex: "FFE66D")] :
                                    [Color(hex: "1a5f4a"), Color(hex: "2d8b6e")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.easeInOut, value: progress)
                }
            }
            .frame(height: 8)
            
            // Step counter
            HStack {
                if isKidsMode {
                    Text("Step \(currentStepIndex + 1) of \(steps.count)")
                        .font(.caption.bold())
                    
                    Spacer()
                    
                    // Stickers earned
                    HStack(spacing: 4) {
                        ForEach(0..<min(earnedStickers, 5), id: \.self) { _ in
                            Text("⭐")
                                .font(.caption)
                        }
                        if earnedStickers > 0 {
                            Text("+\(earnedStickers)")
                                .font(.caption.bold())
                                .foregroundColor(.orange)
                        }
                    }
                } else {
                    Text("Step \(currentStepIndex + 1) / \(steps.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))% Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    // MARK: - Animation Area
    
    var animationArea: some View {
        VStack(spacing: 16) {
            // Position indicator with animation
            ZStack {
                // Background circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: isKidsMode ?
                                [Color(hex: "FFE4CC"), Color(hex: "FFCBA4")] :
                                [Color(hex: "e8f5e9"), Color(hex: "c8e6c9")],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                
                // Animated position icon
                VStack(spacing: 8) {
                    // Position emoji/icon
                    Text(currentStep.positionEmoji)
                        .font(.system(size: isKidsMode ? 80 : 60))
                        .scaleEffect(isPlaying ? 1.1 : 1.0)
                        .animation(
                            isPlaying ?
                                .easeInOut(duration: 0.5).repeatForever(autoreverses: true) :
                                .default,
                            value: isPlaying
                        )
                    
                    // Position name
                    Text(currentStep.position.displayName)
                        .font(isKidsMode ? .headline.bold() : .subheadline)
                        .foregroundColor(isKidsMode ? .orange : .primary)
                }
            }
            
            // Kids "Copy Me" instruction
            if isKidsMode && isPracticeMode {
                HStack(spacing: 8) {
                    Text("👆")
                        .font(.title2)
                    Text("Copy me! Then tap Next!")
                        .font(.headline)
                        .foregroundColor(.orange)
                    Text("👆")
                        .font(.title2)
                }
                .padding()
                .background(Color.orange.opacity(0.2))
                .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Step Info Card
    
    var stepInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Step title
            HStack {
                Text(isKidsMode ? currentStep.kidsEmoji : "")
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentStep.name)
                        .font(.title3.bold())
                    
                    if !isKidsMode {
                        Text(currentStep.nameArabic)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Completion checkmark
                if completedSteps.contains(currentStepIndex) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            
            Divider()
            
            // Description
            Text(isKidsMode ? currentStep.kidsDescription : currentStep.description)
                .font(isKidsMode ? .body : .subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
            
            // Duration and repetitions
            HStack(spacing: 16) {
                Label("\(currentStep.duration)s", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if currentStep.repetitions > 1 {
                    Label("×\(currentStep.repetitions)", systemImage: "repeat")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
    
    // MARK: - Recitation Card
    
    func recitationCard(_ recitation: EnhancedRecitation) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.book.closed")
                    .foregroundColor(isKidsMode ? .orange : .green)
                Text("Recitation")
                    .font(.headline)
                Spacer()
            }
            
            Divider()
            
            VStack(alignment: .center, spacing: 12) {
                // Arabic
                if showArabic {
                    Text(recitation.arabic)
                        .font(.system(size: isKidsMode ? 24 : 28, design: .serif))
                        .multilineTextAlignment(.center)
                        .environment(\.layoutDirection, .rightToLeft)
                }
                
                // Transliteration
                if showTransliteration {
                    Text(recitation.transliteration)
                        .font(isKidsMode ? .body : .subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                        .multilineTextAlignment(.center)
                }
                
                // Translation
                if showTranslation {
                    Text(recitation.translation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
    
    // MARK: - Audio Controls Card
    
    var audioControlsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.green)
                Text("Gemini AI Voice")
                    .font(.headline)
                Spacer()
            }
            
            Divider()
            
            HStack(spacing: 16) {
                // Play button - uses Gemini AI voice for current recitation
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    if ttsService.isSpeaking {
                        ttsService.stop()
                    } else if let recitation = currentStep.recitation {
                        ttsService.speakArabic(recitation.arabic, rate: audioSpeed == .slow ? 0.25 : 0.35)
                    }
                }) {
                    HStack {
                        Image(systemName: ttsService.isSpeaking ? "stop.circle.fill" : "play.circle.fill")
                            .font(.title)
                        Text(ttsService.isSpeaking ? "Stop" : "Play")
                    }
                    .foregroundColor(ttsService.isSpeaking ? .orange : .green)
                }
                .disabled(currentStep.recitation == nil)
                
                Spacer()
                
                // Speed control
                Picker("Speed", selection: $audioSpeed) {
                    ForEach(AudioSpeed.allCases, id: \.self) { speed in
                        Text(speed.displayName).tag(speed)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 150)
            }
            
            Text("Powered by Gemini AI")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
    
    // MARK: - Display Toggles Card
    
    var displayTogglesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "textformat")
                    .foregroundColor(isKidsMode ? .orange : .green)
                Text("Display Options")
                    .font(.headline)
                Spacer()
            }
            
            Divider()
            
            VStack(spacing: 8) {
                Toggle("Arabic Script", isOn: $showArabic)
                Toggle("Transliteration", isOn: $showTransliteration)
                Toggle("Translation", isOn: $showTranslation)
            }
            .tint(isKidsMode ? .orange : .green)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
    
    // MARK: - Tips Card
    
    var tipsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.yellow)
                Text(isKidsMode ? "💡 Tips!" : "Tips & Corrections")
                    .font(.headline)
                Spacer()
            }
            
            Divider()
            
            ForEach(currentStep.tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 8) {
                    Text(isKidsMode ? "✨" : "•")
                    Text(tip)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
    
    // MARK: - Bottom Navigation
    
    var bottomNavigation: some View {
        HStack(spacing: 16) {
            // Previous button
            Button(action: previousStep) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Previous")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.primary)
                .cornerRadius(12)
            }
            .disabled(currentStepIndex == 0)
            .opacity(currentStepIndex == 0 ? 0.5 : 1)
            
            // Next/Complete button
            Button(action: nextStep) {
                HStack {
                    Text(currentStepIndex == steps.count - 1 ? "Complete!" : "Next")
                    Image(systemName: currentStepIndex == steps.count - 1 ? "checkmark" : "chevron.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: isKidsMode ?
                            [Color(hex: "FF6B6B"), Color(hex: "FF8E53")] :
                            [Color(hex: "1a5f4a"), Color(hex: "2d8b6e")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    // MARK: - Completion View
    
    var completionView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            if isKidsMode {
                Text("🎉")
                    .font(.system(size: 80))
                
                Text("Amazing Job!")
                    .font(.largeTitle.bold())
                    .foregroundColor(.orange)
                
                Text("You completed your prayer!")
                    .font(.title3)
                
                // Stickers earned
                VStack(spacing: 12) {
                    Text("Stickers Earned:")
                        .font(.headline)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { i in
                            Text(["⭐", "🌟", "✨", "🌙", "💫"][i])
                                .font(.system(size: 40))
                        }
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.2))
                .cornerRadius(16)
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                Text("Prayer Complete")
                    .font(.largeTitle.bold())
                
                Text("May Allah accept your salah")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Text("تقبل الله")
                    .font(.title2)
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            Button(action: {
                showCompletionSheet = false
                dismiss()
            }) {
                Text(isKidsMode ? "Yay! 🎊" : "Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isKidsMode ? Color.orange : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
        .padding()
    }
    
    // MARK: - Actions
    
    func previousStep() {
        withAnimation {
            if currentStepIndex > 0 {
                currentStepIndex -= 1
            }
        }
    }
    
    func nextStep() {
        withAnimation {
            completedSteps.insert(currentStepIndex)
            
            if isKidsMode {
                earnedStickers += 1
            }
            
            if currentStepIndex < steps.count - 1 {
                currentStepIndex += 1
            } else {
                // Completed all steps
                showCompletionSheet = true
            }
        }
    }
}

// MARK: - Audio Speed Enum

enum AudioSpeed: String, CaseIterable {
    case slow = "Slow"
    case normal = "Normal"
    
    var displayName: String {
        rawValue
    }
    
    var rate: Float {
        switch self {
        case .slow: return 0.5
        case .normal: return 1.0
        }
    }
}

// MARK: - Salah Type Enum

enum SalahType: String, CaseIterable {
    case twoRakah = "2 Rakah"
    case threeRakah = "3 Rakah"
    case fourRakah = "4 Rakah"
    
    var displayName: String {
        switch self {
        case .twoRakah: return "2 Rakah Prayer"
        case .threeRakah: return "3 Rakah Prayer"
        case .fourRakah: return "4 Rakah Prayer"
        }
    }
    
    var kidsName: String {
        switch self {
        case .twoRakah: return "Short Prayer"
        case .threeRakah: return "Medium Prayer"
        case .fourRakah: return "Long Prayer"
        }
    }
    
    var rakahCount: Int {
        switch self {
        case .twoRakah: return 2
        case .threeRakah: return 3
        case .fourRakah: return 4
        }
    }
}

// MARK: - Enhanced Salah Position

enum EnhancedSalahPosition: String, CaseIterable {
    case standing
    case raisingHands
    case bowing
    case risingFromBowing
    case prostrating
    case sittingBetweenSujud
    case finalSitting
    case turning
    
    var displayName: String {
        switch self {
        case .standing: return "Standing (Qiyam)"
        case .raisingHands: return "Raising Hands (Takbir)"
        case .bowing: return "Bowing (Ruku)"
        case .risingFromBowing: return "Rising from Ruku"
        case .prostrating: return "Prostration (Sujud)"
        case .sittingBetweenSujud: return "Sitting between Sujud"
        case .finalSitting: return "Final Sitting (Tashahhud)"
        case .turning: return "Turning (Tasleem)"
        }
    }
    
    var emoji: String {
        switch self {
        case .standing: return "🧍"
        case .raisingHands: return "🙌"
        case .bowing: return "🙇"
        case .risingFromBowing: return "🧍"
        case .prostrating: return "🙏"
        case .sittingBetweenSujud: return "🧎"
        case .finalSitting: return "🧎"
        case .turning: return "👋"
        }
    }
    
    var kidsEmoji: String {
        switch self {
        case .standing: return "🧍‍♂️"
        case .raisingHands: return "🙌"
        case .bowing: return "🙇‍♂️"
        case .risingFromBowing: return "⬆️"
        case .prostrating: return "🌟"
        case .sittingBetweenSujud: return "🧎‍♂️"
        case .finalSitting: return "🧎‍♂️"
        case .turning: return "👋"
        }
    }
}

// MARK: - Enhanced Recitation

struct EnhancedRecitation: Identifiable {
    let id: String
    let arabic: String
    let transliteration: String
    let translation: String
    let audioFileName: String?
    
    init(id: String = UUID().uuidString, arabic: String, transliteration: String, translation: String, audioFileName: String? = nil) {
        self.id = id
        self.arabic = arabic
        self.transliteration = transliteration
        self.translation = translation
        self.audioFileName = audioFileName
    }
}

// MARK: - Enhanced Salah Step

struct EnhancedSalahStep: Identifiable {
    let id: String
    let stepNumber: Int
    let name: String
    let nameArabic: String
    let description: String
    let kidsDescription: String
    let kidsEmoji: String
    let position: EnhancedSalahPosition
    let recitation: EnhancedRecitation?
    let duration: Int
    let repetitions: Int
    let tips: [String]
    let commonMistakes: [String]
    
    var positionEmoji: String {
        position.kidsEmoji
    }
    
    // Generate steps for a given salah type
    static func stepsFor(_ type: SalahType) -> [EnhancedSalahStep] {
        var steps: [EnhancedSalahStep] = []
        var stepNum = 1
        
        // Opening Takbir
        steps.append(EnhancedSalahStep(
            id: "step-\(stepNum)",
            stepNumber: stepNum,
            name: "Opening Takbir",
            nameArabic: "تكبيرة الإحرام",
            description: "Stand facing the Qiblah, raise your hands to ear level, and say 'Allahu Akbar'",
            kidsDescription: "Stand up tall and say 'Allahu Akbar' while lifting your hands! 🙌",
            kidsEmoji: "🙌",
            position: .raisingHands,
            recitation: EnhancedRecitation(
                arabic: "اللهُ أَكْبَرُ",
                transliteration: "Allahu Akbar",
                translation: "Allah is the Greatest"
            ),
            duration: 3,
            repetitions: 1,
            tips: [
                "Face the direction of Makkah (Qiblah)",
                "Keep your feet shoulder-width apart",
                "Raise hands to ear level or shoulder level",
                "Look at the place of prostration"
            ],
            commonMistakes: [
                "Not facing Qiblah",
                "Looking around instead of at sajdah spot"
            ]
        ))
        stepNum += 1
        
        // For each rakah
        for rakah in 1...type.rakahCount {
            let isFirstRakah = rakah == 1
            let isLastRakah = rakah == type.rakahCount
            
            // Standing with hands folded
            steps.append(EnhancedSalahStep(
                id: "step-\(stepNum)",
                stepNumber: stepNum,
                name: isFirstRakah ? "Recite Al-Fatiha & Surah" : "Recite Al-Fatiha",
                nameArabic: isFirstRakah ? "قراءة الفاتحة وسورة" : "قراءة الفاتحة",
                description: isFirstRakah ?
                    "Place right hand over left on chest, recite Opening Dua, then Al-Fatiha, then another Surah" :
                    "Recite Al-Fatiha quietly (in 3rd and 4th rakah)",
                kidsDescription: isFirstRakah ?
                    "Put your hands on your chest and read the Quran! 📖" :
                    "Read Al-Fatiha with your hands on your chest 📖",
                kidsEmoji: "📖",
                position: .standing,
                recitation: EnhancedRecitation(
                    arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
                    transliteration: "Bismillahir Rahmanir Raheem\nAlhamdu lillahi Rabbil 'Aalameen...",
                    translation: "In the name of Allah, the Most Gracious, the Most Merciful\nPraise be to Allah, Lord of all the worlds..."
                ),
                duration: isFirstRakah ? 60 : 30,
                repetitions: 1,
                tips: [
                    "Right hand over left, placed on chest",
                    "Recite slowly and clearly",
                    isFirstRakah ? "Add another short Surah after Al-Fatiha" : "Only Al-Fatiha in 3rd/4th rakah"
                ],
                commonMistakes: [
                    "Rushing through recitation",
                    "Not pronouncing letters correctly"
                ]
            ))
            stepNum += 1
            
            // Ruku
            steps.append(EnhancedSalahStep(
                id: "step-\(stepNum)",
                stepNumber: stepNum,
                name: "Bowing (Ruku)",
                nameArabic: "الركوع",
                description: "Say Takbir, bow with back straight, hands on knees, and say 'Subhana Rabbiyal Adheem' three times",
                kidsDescription: "Bow down and say 'Subhana Rabbiyal Adheem' three times! 🙇",
                kidsEmoji: "🙇",
                position: .bowing,
                recitation: EnhancedRecitation(
                    arabic: "سُبْحَانَ رَبِّيَ الْعَظِيمِ",
                    transliteration: "Subhana Rabbiyal Adheem",
                    translation: "Glory be to my Lord, the Most Great"
                ),
                duration: 10,
                repetitions: 3,
                tips: [
                    "Keep your back straight and flat",
                    "Hands firmly on knees",
                    "Head in line with back",
                    "Say the dhikr at least 3 times"
                ],
                commonMistakes: [
                    "Bending back instead of keeping it straight",
                    "Not holding position long enough"
                ]
            ))
            stepNum += 1
            
            // Rising from Ruku
            steps.append(EnhancedSalahStep(
                id: "step-\(stepNum)",
                stepNumber: stepNum,
                name: "Rising from Ruku",
                nameArabic: "الرفع من الركوع",
                description: "Rise saying 'Sami Allahu liman hamidah', then 'Rabbana wa lakal hamd'",
                kidsDescription: "Stand up straight and say 'Sami Allahu liman hamidah'! ⬆️",
                kidsEmoji: "⬆️",
                position: .risingFromBowing,
                recitation: EnhancedRecitation(
                    arabic: "سَمِعَ اللهُ لِمَنْ حَمِدَهُ\nرَبَّنَا وَلَكَ الْحَمْدُ",
                    transliteration: "Sami'Allahu liman hamidah\nRabbana wa lakal hamd",
                    translation: "Allah hears those who praise Him\nOur Lord, to You is all praise"
                ),
                duration: 5,
                repetitions: 1,
                tips: [
                    "Stand completely upright",
                    "Pause briefly before going to sujud"
                ],
                commonMistakes: [
                    "Not standing fully upright",
                    "Going to sujud too quickly"
                ]
            ))
            stepNum += 1
            
            // First Sujud
            steps.append(EnhancedSalahStep(
                id: "step-\(stepNum)",
                stepNumber: stepNum,
                name: "First Prostration",
                nameArabic: "السجدة الأولى",
                description: "Say Takbir, prostrate with 7 body parts on ground, say 'Subhana Rabbiyal A'la' three times",
                kidsDescription: "Go down and put your forehead on the ground! Say 'Subhana Rabbiyal A'la'! 🌟",
                kidsEmoji: "🌟",
                position: .prostrating,
                recitation: EnhancedRecitation(
                    arabic: "سُبْحَانَ رَبِّيَ الْأَعْلَى",
                    transliteration: "Subhana Rabbiyal A'la",
                    translation: "Glory be to my Lord, the Most High"
                ),
                duration: 10,
                repetitions: 3,
                tips: [
                    "7 body parts: forehead, nose, both hands, both knees, toes of both feet",
                    "Keep arms away from sides",
                    "This is the closest you are to Allah - make dua!"
                ],
                commonMistakes: [
                    "Elbows touching the ground",
                    "Feet not pointed toward Qiblah"
                ]
            ))
            stepNum += 1
            
            // Sitting between sujud
            steps.append(EnhancedSalahStep(
                id: "step-\(stepNum)",
                stepNumber: stepNum,
                name: "Sitting between Prostrations",
                nameArabic: "الجلسة بين السجدتين",
                description: "Rise saying Takbir, sit and say 'Rabbighfir li'",
                kidsDescription: "Sit up and ask Allah to forgive you! 🧎",
                kidsEmoji: "🧎",
                position: .sittingBetweenSujud,
                recitation: EnhancedRecitation(
                    arabic: "رَبِّ اغْفِرْ لِي",
                    transliteration: "Rabbighfir li",
                    translation: "My Lord, forgive me"
                ),
                duration: 5,
                repetitions: 1,
                tips: [
                    "Sit on your left foot",
                    "Right foot upright with toes facing Qiblah",
                    "Hands on thighs"
                ],
                commonMistakes: [
                    "Sitting incorrectly",
                    "Not pausing long enough"
                ]
            ))
            stepNum += 1
            
            // Second Sujud
            steps.append(EnhancedSalahStep(
                id: "step-\(stepNum)",
                stepNumber: stepNum,
                name: "Second Prostration",
                nameArabic: "السجدة الثانية",
                description: "Say Takbir, prostrate again, say 'Subhana Rabbiyal A'la' three times",
                kidsDescription: "Go down again and say 'Subhana Rabbiyal A'la'! 🌟",
                kidsEmoji: "🌟",
                position: .prostrating,
                recitation: EnhancedRecitation(
                    arabic: "سُبْحَانَ رَبِّيَ الْأَعْلَى",
                    transliteration: "Subhana Rabbiyal A'la",
                    translation: "Glory be to my Lord, the Most High"
                ),
                duration: 10,
                repetitions: 3,
                tips: [
                    "Same as first prostration",
                    "Make lots of dua in sujud"
                ],
                commonMistakes: [
                    "Rushing through this sujud"
                ]
            ))
            stepNum += 1
            
            // If end of even rakah, add Tashahhud
            if rakah % 2 == 0 {
                let isFinalTashahhud = isLastRakah
                
                steps.append(EnhancedSalahStep(
                    id: "step-\(stepNum)",
                    stepNumber: stepNum,
                    name: isFinalTashahhud ? "Final Tashahhud" : "First Tashahhud",
                    nameArabic: isFinalTashahhud ? "التشهد الأخير" : "التشهد الأول",
                    description: isFinalTashahhud ?
                        "Sit and recite Tashahhud, Salawat (Durood), and final duas" :
                        "Sit and recite the first part of Tashahhud",
                    kidsDescription: isFinalTashahhud ?
                        "Sit and read the special prayer! Almost done! 🧎" :
                        "Sit and read the Tashahhud! 🧎",
                    kidsEmoji: "🧎",
                    position: .finalSitting,
                    recitation: EnhancedRecitation(
                        arabic: "التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ\nالسَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ",
                        transliteration: "At-tahiyyatu lillahi was-salawatu wat-tayyibat\nAs-salamu 'alayka ayyuhan-nabiyyu wa rahmatullahi wa barakatuh...",
                        translation: "All compliments, prayers and pure words are due to Allah\nPeace be upon you, O Prophet, and the mercy of Allah and His blessings..."
                    ),
                    duration: isFinalTashahhud ? 30 : 15,
                    repetitions: 1,
                    tips: isFinalTashahhud ? [
                        "Sit on left hip (tawarruk)",
                        "Raise index finger when saying Shahada",
                        "Add Durood Ibrahim after Tashahhud",
                        "Make personal dua before tasleem"
                    ] : [
                        "Sit on left foot (iftirash)",
                        "Raise index finger during Shahada"
                    ],
                    commonMistakes: [
                        "Not raising index finger",
                        "Moving finger constantly instead of just raising it"
                    ]
                ))
                stepNum += 1
            }
        }
        
        // Tasleem (ending)
        steps.append(EnhancedSalahStep(
            id: "step-\(stepNum)",
            stepNumber: stepNum,
            name: "Tasleem (Ending)",
            nameArabic: "التسليم",
            description: "Turn head to the right saying 'Assalamu alaikum wa rahmatullah', then to the left",
            kidsDescription: "Turn your head right and left and say 'Assalamu alaikum'! You did it! 👋",
            kidsEmoji: "👋",
            position: .turning,
            recitation: EnhancedRecitation(
                arabic: "السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ",
                transliteration: "Assalamu alaikum wa rahmatullah",
                translation: "Peace be upon you and the mercy of Allah"
            ),
            duration: 5,
            repetitions: 2,
            tips: [
                "Turn head to right first, then left",
                "Some say you're greeting the angels on each side"
            ],
            commonMistakes: [
                "Not turning head far enough",
                "Rushing through tasleem"
            ]
        ))
        
        return steps
    }
}

// MARK: - Preview

struct SalahTrainerView_Previews: PreviewProvider {
    static var previews: some View {
        SalahTrainerView()
            .environmentObject(AppState())
    }
}
