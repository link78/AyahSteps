//
//  PrayerView.swift
//  DeenLearn
//
//  Phase 1.3 - Prayer Tab: Salah & Wudu Trainer
//  Step-by-step guidance for wudu and salah
//

import SwiftUI

struct PrayerView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var ttsService = TextToSpeechService.shared
    @State private var selectedSection: PrayerSection = .wudu
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Tap to Listen Hint
                    TapToListenHint(isKidsMode: isKidsMode)
                        .padding(.horizontal)
                    
                    // Header
                    prayerHeader
                    
                    // Section Picker
                    sectionPicker
                    
                    // Content based on section
                    switch selectedSection {
                    case .wudu:
                        WuduSectionView(isKidsMode: isKidsMode)
                    case .salah:
                        SalahSectionView(isKidsMode: isKidsMode)
                    case .practice:
                        PracticeModeView(isKidsMode: isKidsMode)
                    case .mistakes:
                        MistakesSectionView(isKidsMode: isKidsMode)
                    case .duas:
                        DuasSectionView(isKidsMode: isKidsMode)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(isKidsMode ? "🕌 Prayer Time" : "Prayer")
        }
    }
    
    var prayerHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isKidsMode ? 
                                [Color(hex: "FF6B6B"), Color(hex: "FFE66D")] :
                                [Color(hex: "1a5f4a"), Color(hex: "2d8b6e")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "person.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            
            if isKidsMode {
                Text("🌟 Learn to Pray! 🌟")
                    .font(.title2.bold())
                
                Text("Follow along and earn stickers!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                // Arabic title with Tap to Listen
                SpeakableArabicText(
                    text: "الصلاة والوضوء",
                    font: .title2
                )
                
                Text("Salah & Wudu Trainer")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
    
    var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(PrayerSection.allCases, id: \.self) { section in
                    PrayerSectionButton(
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
            .padding(.horizontal)
        }
    }
}

enum PrayerSection: String, CaseIterable {
    case wudu = "Wudu"
    case salah = "Salah"
    case practice = "Practice"
    case mistakes = "Mistakes"
    case duas = "Duas"
    
    var icon: String {
        switch self {
        case .wudu: return "drop.fill"
        case .salah: return "person.fill"
        case .practice: return "play.circle.fill"
        case .mistakes: return "exclamationmark.triangle.fill"
        case .duas: return "hands.sparkles.fill"
        }
    }
    
    var kidsEmoji: String {
        switch self {
        case .wudu: return "💧"
        case .salah: return "🕌"
        case .practice: return "🎮"
        case .mistakes: return "❌"
        case .duas: return "🤲"
        }
    }
    
    var accessibilityDescription: String {
        switch self {
        case .wudu: return "Learn how to perform wudu, the Islamic ablution"
        case .salah: return "Learn how to perform the prayer step by step"
        case .practice: return "Practice wudu or prayer with guidance"
        case .mistakes: return "Learn about common mistakes and how to correct them"
        case .duas: return "Supplications to recite after prayer"
        }
    }
}

struct PrayerSectionButton: View {
    let section: PrayerSection
    let isSelected: Bool
    let isKidsMode: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if isKidsMode {
                    Text(section.kidsEmoji)
                        .font(.title)
                } else {
                    Image(systemName: section.icon)
                        .font(.title3)
                }
                
                Text(section.rawValue)
                    .font(.caption)
            }
            .frame(width: 70, height: 70)
            .background(isSelected ? 
                (isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e")) :
                Color(.systemBackground)
            )
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("\(section.rawValue) section")
        .accessibilityHint(section.accessibilityDescription)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Wudu Section

struct WuduSectionView: View {
    let isKidsMode: Bool
    @State private var showStepDetail: WuduStep?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                if isKidsMode {
                    Text("💧 Learn Wudu")
                        .font(.headline)
                } else {
                    HStack(spacing: 8) {
                        Text("Learn Wudu")
                            .font(.headline)
                        SpeakableArabicText(
                            text: "(الوضوء)",
                            font: .headline
                        )
                    }
                }
                Spacer()
                Text("\(WuduStep.allSteps.count) steps")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            ForEach(WuduStep.allSteps) { step in
                WuduStepCard(step: step, isKidsMode: isKidsMode) {
                    showStepDetail = step
                }
            }
        }
        .sheet(item: $showStepDetail) { step in
            StepDetailView(wuduStep: step, salahStep: nil, isKidsMode: isKidsMode)
        }
    }
}

struct WuduStepCard: View {
    let step: WuduStep
    let isKidsMode: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Step number
                ZStack {
                    Circle()
                        .fill(step.isSunnah ? Color.orange.opacity(0.2) : Color.blue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    if isKidsMode {
                        Text(step.kidsEmoji)
                            .font(.title2)
                    } else {
                        Text("\(step.stepNumber)")
                            .font(.headline)
                            .foregroundColor(step.isSunnah ? .orange : .blue)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(step.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if step.isSunnah {
                            Text("Sunnah")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(isKidsMode ? step.kidsDescription : step.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        Label("\(step.duration)s", systemImage: "clock")
                        if step.repetitions > 1 {
                            Label("×\(step.repetitions)", systemImage: "repeat")
                        }
                    }
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
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

// MARK: - Salah Section

struct SalahSectionView: View {
    let isKidsMode: Bool
    @State private var showStepDetail: SalahStep?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                if isKidsMode {
                    Text("🕌 Learn Salah")
                        .font(.headline)
                } else {
                    HStack(spacing: 8) {
                        Text("Learn Salah")
                            .font(.headline)
                        SpeakableArabicText(
                            text: "(الصلاة)",
                            font: .headline
                        )
                    }
                }
                Spacer()
                Text("2 Rakah Prayer")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Prayer positions legend
            if !isKidsMode {
                HStack(spacing: 16) {
                    PositionLegend(position: .standing, color: .blue)
                    PositionLegend(position: .bowing, color: .green)
                    PositionLegend(position: .prostrating, color: .purple)
                    PositionLegend(position: .sitting, color: .orange)
                }
                .padding(.horizontal)
            }
            
            ForEach(SalahStep.twoRakatSteps) { step in
                SalahStepCard(step: step, isKidsMode: isKidsMode) {
                    showStepDetail = step
                }
            }
        }
        .sheet(item: $showStepDetail) { step in
            StepDetailView(wuduStep: nil, salahStep: step, isKidsMode: isKidsMode)
        }
    }
}

struct PositionLegend: View {
    let position: SalahPosition
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(position.rawValue)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct SalahStepCard: View {
    let step: SalahStep
    let isKidsMode: Bool
    let action: () -> Void
    
    var positionColor: Color {
        switch step.position {
        case .standing: return .blue
        case .bowing: return .green
        case .prostrating: return .purple
        case .sitting: return .orange
        case .standingFromSujud: return .blue
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Step indicator
                ZStack {
                    Circle()
                        .fill(positionColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    if isKidsMode {
                        Text(step.kidsEmoji)
                            .font(.title2)
                    } else {
                        Text("\(step.stepNumber)")
                            .font(.headline)
                            .foregroundColor(positionColor)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(step.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if !isKidsMode {
                        SpeakableArabicText(
                            text: step.nameArabic,
                            font: .caption,
                            color: positionColor
                        )
                    }
                    
                    Text(isKidsMode ? step.kidsDescription : step.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(positionColor.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

// MARK: - Step Detail View

struct StepDetailView: View {
    let wuduStep: WuduStep?
    let salahStep: SalahStep?
    let isKidsMode: Bool
    
    @Environment(\.dismiss) var dismiss
    @State private var showArabic = true
    @State private var showTransliteration = true
    @State private var showTranslation = true
    @State private var showFiqhNotes = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    stepHeader
                    
                    // Main content
                    if isKidsMode {
                        kidsContent
                    } else {
                        adultsContent
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    var stepHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                if isKidsMode {
                    Text(wuduStep?.kidsEmoji ?? salahStep?.kidsEmoji ?? "🙏")
                        .font(.system(size: 50))
                } else {
                    Image(systemName: wuduStep != nil ? "drop.fill" : "person.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
            }
            
            Text(wuduStep?.name ?? salahStep?.name ?? "")
                .font(.title2.bold())
            
            // Arabic name with Tap to Listen
            SpeakableArabicText(
                text: wuduStep?.nameArabic ?? salahStep?.nameArabic ?? "",
                font: .title3,
                color: .secondary
            )
        }
    }
    
    var kidsContent: some View {
        VStack(spacing: 20) {
            // Cartoon instruction
            VStack(alignment: .leading, spacing: 12) {
                Text("📖 Copy Me!")
                    .font(.headline)
                
                Text(wuduStep?.kidsDescription ?? salahStep?.kidsDescription ?? "")
                    .font(.title3)
                    .padding()
                    .background(Color(hex: "FFE66D").opacity(0.3))
                    .cornerRadius(16)
            }
            
            // Duration and repetitions
            HStack(spacing: 20) {
                InfoBadge(icon: "clock", value: "\(wuduStep?.duration ?? salahStep?.duration ?? 0)s", label: "Time")
                
                if let reps = wuduStep?.repetitions ?? salahStep?.repetitions, reps > 1 {
                    InfoBadge(icon: "repeat", value: "×\(reps)", label: "Times")
                }
            }
            
            // Recitation for salah
            if let recitation = salahStep?.recitation {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("🗣️ What to Say")
                            .font(.headline)
                        Spacer()
                        Text("Tap to hear")
                            .font(.caption)
                            .foregroundColor(.purple)
                    }
                    
                    // Speakable Arabic recitation
                    SpeakableArabicText(
                        text: recitation.arabic,
                        font: .title2
                    )
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
                    
                    Text(recitation.transliteration)
                        .font(.body)
                        .foregroundColor(.purple)
                        .multilineTextAlignment(.center)
                    
                    Text(recitation.translation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
            }
            
            // Sticker reward
            VStack {
                Text("🌟 Complete this step to earn a sticker! 🌟")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    var adultsContent: some View {
        VStack(spacing: 20) {
            // Description
            VStack(alignment: .leading, spacing: 12) {
                Text("Description")
                    .font(.headline)
                
                Text(wuduStep?.description ?? salahStep?.description ?? "")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // Audio/Display toggles
            if salahStep?.recitation != nil {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Display Options")
                        .font(.headline)
                    
                    Toggle("Arabic", isOn: $showArabic)
                    Toggle("Transliteration", isOn: $showTransliteration)
                    Toggle("Translation", isOn: $showTranslation)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
            }
            
            // Recitation
            if let recitation = salahStep?.recitation {
                RecitationCard(recitation: recitation, showArabic: showArabic, showTransliteration: showTransliteration, showTranslation: showTranslation)
            }
            
            // Common mistakes
            if let mistakes = wuduStep?.commonMistakes ?? salahStep?.commonMistakes, !mistakes.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Common Mistakes")
                        .font(.headline)
                    
                    ForEach(mistakes, id: \.self) { mistake in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                            
                            Text(mistake)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
            }
            
            // Fiqh notes toggle
            if let fiqhNotes = wuduStep?.fiqhNotes ?? salahStep?.fiqhNotes {
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: { withAnimation { showFiqhNotes.toggle() }}) {
                        HStack {
                            Text("Fiqh Notes")
                                .font(.headline)
                            Spacer()
                            Image(systemName: showFiqhNotes ? "chevron.up" : "chevron.down")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if showFiqhNotes {
                        Text(fiqhNotes)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
            }
        }
    }
}

struct InfoBadge: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 80)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Recitation Card with TTS

struct RecitationCard: View {
    let recitation: Recitation
    let showArabic: Bool
    let showTransliteration: Bool
    let showTranslation: Bool
    
    @StateObject private var ttsService = TextToSpeechService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recitation")
                    .font(.headline)
                Spacer()
                
                // Play button
                Button(action: {
                    ttsService.speak(recitation.arabic, language: "ar-SA")
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: ttsService.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                            .symbolEffect(.variableColor, isActive: ttsService.isSpeaking)
                        Text("Listen")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
            }
            
            if showArabic {
                // Tappable Arabic text
                SpeakableArabicText(
                    text: recitation.arabic,
                    font: .title3
                )
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            if showTransliteration {
                Text(recitation.transliteration)
                    .font(.body)
                    .foregroundColor(.blue)
            }
            
            if showTranslation {
                Text(recitation.translation)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Speakable Arabic Text Component

struct SpeakableArabicText: View {
    let text: String
    let font: Font
    var color: Color = .primary
    
    @StateObject private var ttsService = TextToSpeechService.shared
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 6) {
            Text(text)
                .font(font)
                .foregroundColor(isPressed ? .orange : color)
            
            Image(systemName: ttsService.isSpeaking && ttsService.currentText == text ? "speaker.wave.3.fill" : "speaker.wave.2")
                .font(.caption)
                .foregroundColor(.blue)
                .symbolEffect(.variableColor, isActive: ttsService.isSpeaking && ttsService.currentText == text)
        }
        .onTapGesture {
            isPressed = true
            ttsService.speak(text, language: "ar-SA")
            
            // Reset visual feedback
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isPressed = false
            }
        }
        .sensoryFeedback(.impact(flexibility: .soft), trigger: isPressed)
    }
}

// MARK: - Practice Mode

struct PracticeModeView: View {
    let isKidsMode: Bool
    @State private var selectedPractice: PracticeType = .wudu
    @State private var currentStepIndex = 0
    @State private var isPracticing = false
    @State private var practiceCompleted = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Practice type selector
            Picker("Practice", selection: $selectedPractice) {
                Text("Wudu").tag(PracticeType.wudu)
                Text("2 Rakah").tag(PracticeType.twoRakah)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if isPracticing {
                practiceInProgress
            } else if practiceCompleted {
                practiceCompletedView
            } else {
                practiceStartView
            }
        }
    }
    
    var practiceStartView: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
            }
            
            Text(isKidsMode ? "Ready to Practice?" : "Start Practice Mode")
                .font(.title2.bold())
            
            Text(isKidsMode ? 
                "Tap 'Next' after each step. Follow along with me!" :
                "You'll be guided through each step. Tap 'Next' when ready to proceed."
            )
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            Button(action: startPractice) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Start Practice")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(16)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    var practiceInProgress: some View {
        VStack(spacing: 20) {
            // Progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Step \(currentStepIndex + 1) of \(totalSteps)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(progress * 100))%")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                        
                        Capsule()
                            .fill(Color.green)
                            .frame(width: geo.size.width * progress)
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal)
            
            // Current step
            currentStepView
            
            // Navigation buttons
            HStack(spacing: 16) {
                Button(action: previousStep) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(currentStepIndex > 0 ? .blue : .gray)
                        .frame(width: 50, height: 50)
                        .background(Color(.systemBackground))
                        .cornerRadius(25)
                }
                .disabled(currentStepIndex == 0)
                
                Button(action: nextStep) {
                    HStack {
                        Text(currentStepIndex == totalSteps - 1 ? "Complete" : "Next")
                        Image(systemName: currentStepIndex == totalSteps - 1 ? "checkmark" : "chevron.right")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(16)
                }
                
                Button(action: stopPractice) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.red)
                        .frame(width: 50, height: 50)
                        .background(Color(.systemBackground))
                        .cornerRadius(25)
                }
            }
            .padding(.horizontal)
        }
    }
    
    var currentStepView: some View {
        Group {
            if selectedPractice == .wudu {
                let step = WuduStep.allSteps[currentStepIndex]
                VStack(spacing: 16) {
                    Text(step.kidsEmoji)
                        .font(.system(size: 60))
                    
                    Text(step.name)
                        .font(.title2.bold())
                    
                    // Arabic name with TTS
                    SpeakableArabicText(
                        text: step.nameArabic,
                        font: .subheadline,
                        color: .secondary
                    )
                    
                    Text(isKidsMode ? step.kidsDescription : step.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Label("\(step.duration)s", systemImage: "clock")
                        if step.repetitions > 1 {
                            Label("×\(step.repetitions)", systemImage: "repeat")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            } else {
                let step = SalahStep.twoRakatSteps[currentStepIndex]
                VStack(spacing: 16) {
                    Text(step.kidsEmoji)
                        .font(.system(size: 60))
                    
                    Text(step.name)
                        .font(.title2.bold())
                    
                    // Arabic name with TTS
                    SpeakableArabicText(
                        text: step.nameArabic,
                        font: .subheadline,
                        color: .secondary
                    )
                    
                    Text(isKidsMode ? step.kidsDescription : step.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    if let recitation = step.recitation {
                        VStack(spacing: 8) {
                            // Speakable Arabic recitation
                            SpeakableArabicText(
                                text: recitation.arabic,
                                font: .title3
                            )
                            Text(recitation.transliteration)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    var practiceCompletedView: some View {
        VStack(spacing: 24) {
            if isKidsMode {
                Text("🎉")
                    .font(.system(size: 80))
                
                Text("Amazing Job!")
                    .font(.largeTitle.bold())
                
                Text("You completed your \(selectedPractice == .wudu ? "Wudu" : "Prayer") practice!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("⭐️ ⭐️ ⭐️")
                    .font(.largeTitle)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Practice Complete")
                    .font(.title.bold())
                
                Text("Well done! Consistency in practice leads to perfection.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Button(action: resetPractice) {
                Text("Practice Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(16)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    var totalSteps: Int {
        selectedPractice == .wudu ? WuduStep.allSteps.count : SalahStep.twoRakatSteps.count
    }
    
    var progress: Double {
        Double(currentStepIndex + 1) / Double(totalSteps)
    }
    
    func startPractice() {
        currentStepIndex = 0
        isPracticing = true
        practiceCompleted = false
    }
    
    func nextStep() {
        if currentStepIndex < totalSteps - 1 {
            currentStepIndex += 1
        } else {
            isPracticing = false
            practiceCompleted = true
        }
    }
    
    func previousStep() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
        }
    }
    
    func stopPractice() {
        isPracticing = false
    }
    
    func resetPractice() {
        currentStepIndex = 0
        practiceCompleted = false
    }
}

enum PracticeType {
    case wudu
    case twoRakah
}

// MARK: - Mistakes Section

struct MistakesSectionView: View {
    let isKidsMode: Bool
    @State private var selectedCategory: MistakeCategory = .wudu
    
    var filteredMistakes: [PrayerMistake] {
        PrayerMistake.commonMistakes.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(isKidsMode ? "❌ Don't Make These Mistakes!" : "Common Mistakes & Corrections")
                .font(.headline)
                .padding(.horizontal)
            
            // Category picker
            Picker("Category", selection: $selectedCategory) {
                ForEach(MistakeCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            ForEach(filteredMistakes) { mistake in
                MistakeCard(mistake: mistake, isKidsMode: isKidsMode)
            }
        }
    }
}

struct MistakeCard: View {
    let mistake: PrayerMistake
    let isKidsMode: Bool
    @State private var showCorrection = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                
                Text(mistake.title)
                    .font(.headline)
            }
            
            Text(mistake.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: { withAnimation { showCorrection.toggle() }}) {
                HStack {
                    Text(showCorrection ? "Hide Fix" : "Show Fix")
                    Image(systemName: showCorrection ? "chevron.up" : "chevron.down")
                }
                .font(.caption)
                .foregroundColor(.green)
            }
            
            if showCorrection {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    Text(mistake.correction)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Duas Section

struct DuasSectionView: View {
    let isKidsMode: Bool
    
    var body: some View {
        if isKidsMode {
            DuaKidsView(isKidsMode: true)
        } else {
            VStack(spacing: 16) {
                Text("Adhkar After Prayer")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(DuaAfterPrayer.allDuas) { dua in
                    DuaCard(dua: dua, isKidsMode: isKidsMode)
                }
            }
        }
    }
}

struct DuaCard: View {
    let dua: DuaAfterPrayer
    let isKidsMode: Bool
    @State private var isExpanded = false
    @StateObject private var ttsService = TextToSpeechService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { isExpanded.toggle() }}) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dua.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Image(systemName: "repeat")
                                .font(.caption)
                            Text(dua.timesToRecite == 1 ? "Once" : "×\(dua.timesToRecite)")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    // Speakable Arabic dua
                    HStack {
                        Spacer()
                        SpeakableArabicText(
                            text: dua.arabic,
                            font: .title3
                        )
                    }
                    
                    Text(dua.transliteration)
                        .font(.body)
                        .foregroundColor(.blue)
                    
                    Text(dua.translation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                    
                    Divider()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(dua.benefit)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Listen button
                    Button(action: {
                        ttsService.speak(dua.arabic, language: "ar-SA")
                    }) {
                        HStack {
                            Image(systemName: ttsService.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                                .symbolEffect(.variableColor, isActive: ttsService.isSpeaking)
                            Text("Listen to Dua")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview("Kids Mode") {
    let appState = AppState()
    appState.userMode = .kids
    return PrayerView()
        .environmentObject(appState)
}

#Preview("Adults Mode") {
    let appState = AppState()
    appState.userMode = .adults
    return PrayerView()
        .environmentObject(appState)
}
