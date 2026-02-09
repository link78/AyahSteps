# DeenLearn - Islamic Learning App for All Ages

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS-blue" alt="Platform iOS">
  <img src="https://img.shields.io/badge/Swift-5.0-orange" alt="Swift 5.0">
  <img src="https://img.shields.io/badge/SwiftUI-✓-green" alt="SwiftUI">
  <img src="https://img.shields.io/badge/License-MIT-lightgrey" alt="License MIT">
</p>

## 🌟 Purpose

**DeenLearn** is a comprehensive Islamic education app designed to make learning about Islam engaging, accessible, and age-appropriate for everyone—from young children to adults. The app combines beautiful visuals, interactive content, and gamification to create a meaningful learning experience.

### Why DeenLearn?

- 📚 **Comprehensive Islamic Education**: Cover all five pillars of Islam, Qur'an reading and memorization, Arabic language, and daily prayers
- 👨‍👩‍👧‍👦 **Family-Friendly**: Kids mode with games and rewards, plus in-depth adult content with scholarly references
- 🎮 **Engaging & Interactive**: Learn through adventure maps, tracing games, matching activities, and more
- 🕌 **Authentic Content**: Based on Qur'an and Hadith with proper scholarly references
- 📊 **Progress Tracking**: Track your journey, set goals, and earn achievements

---

## ✨ Features

### 🏠 Home Tab
- Daily goal cards for Qur'an, Salah, and Arabic
- Progress rings showing mastery levels
- Quick actions for instant access to key features
- Prayer time reminders

### 🕋 Five Pillars of Islam
- **Shahada**: Declaration of faith with meaning and significance
- **Salah**: Interactive prayer trainer with step-by-step guidance
- **Zakat**: Calculator and understanding of charitable giving
- **Sawm**: Fasting guidance and Ramadan features
- **Hajj**: Pilgrimage journey exploration

#### Kids Mode
- Story-based worlds (Shahada Island, Salah City, Zakat Village, etc.)
- Animated character guides (Captain Iman, Mayor Salim, etc.)
- Mini-games and puzzles
- Star collection and badge rewards

### 🙏 Salah Trainer
- Step-by-step prayer animations
- Wudu (ablution) guide with 13 steps
- Arabic recitations with transliteration
- Practice mode with tap-to-advance
- Mistake correction tips

#### Adult Mode
- Fiqh details (optional)
- Differences between Islamic schools (Hanafi, Maliki, Shafi'i, Hanbali)
- Common mistakes & corrections

### 📖 Qur'an Module

#### Reading
- Mushaf-style view
- Word-by-word audio playback
- Color-coded Tajwīd rules
- Tap any word → hear pronunciation + see meaning + root word

#### Memorization
- Ayah looping (1-10x or infinite)
- Call-and-response mode
- Progress tracking per surah
- Chunking system for easier memorization

#### Kids Mode
- Juz Amma adventure map
- 16 surahs as island locations
- Character guide: Qari the Parrot 🦜
- Rewards for consistency

### 🔤 Arabic Language

#### Letters
- All 28 Arabic letters
- Four forms: Isolated, Initial, Medial, Final
- Pronunciation guides
- Finger tracing practice
- Example words with icons

#### Vocabulary
- 6 themed word packs (Animals, Colors, Family, etc.)
- Visual flashcards
- Audio pronunciation

#### Games
- Letter matching
- Sound recognition
- Word building

### 👨‍👩‍👧‍👦 Family Features

#### Parent Dashboard
- Track multiple children's progress
- Set daily learning goals
- Content controls and screen time
- Weekly progress reports

#### Adult Progress
- Learning goals with deadlines
- Achievement badges (12 total)
- Streak tracking
- Analytics and charts

#### Reminders
- Prayer time notifications
- Daily learning reminders
- Gentle, customizable alerts

---

## 🎯 Age-Appropriate Content

| Age Group | Features |
|-----------|----------|
| **4-6 years** | Simple words, colorful visuals, 5-min sessions |
| **7-9 years** | Interactive elements, rewards, 10-min sessions |
| **10-12 years** | More detail, Arabic terms, 15-min sessions |
| **13-17 years** | Scholarly elements, fiqh basics, 20-min sessions |
| **18+ years** | Full scholarly content, flexible sessions |

---

## 🛠 Technical Stack

- **Platform**: iOS 17+
- **Language**: Swift 5
- **UI Framework**: SwiftUI
- **Architecture**: MVVM with Observable patterns
- **Build System**: Xcode 16

---

## 📁 Project Structure

```
DeenLearn/
├── DeenLearn.xcodeproj/
├── DeenLearn/
│   ├── DeenLearnApp.swift          # App entry point
│   ├── ContentView.swift           # Root view
│   ├── Extensions.swift            # Swift extensions
│   ├── Assets.xcassets/            # Images and colors
│   ├── Models/
│   │   ├── AppState.swift          # App-wide state
│   │   ├── LearningModule.swift    # Module definitions
│   │   ├── Pillar.swift            # Five pillars data
│   │   ├── Prayer.swift            # Salah models
│   │   ├── Quran.swift             # Qur'an data models
│   │   ├── Arabic.swift            # Arabic letters/vocab
│   │   └── Profile.swift           # User profiles
│   └── Views/
│       ├── WelcomeView.swift       # Onboarding
│       ├── MainTabView.swift       # Tab navigation
│       ├── HomeView.swift          # Home screen
│       ├── PillarsView.swift       # Five pillars
│       ├── PillarsKidsWorldView.swift  # Kids adventure
│       ├── PrayerView.swift        # Prayer learning
│       ├── SalahTrainerView.swift  # Interactive trainer
│       ├── QuranView.swift         # Qur'an reading
│       ├── ArabicView.swift        # Arabic learning
│       └── ProfileView.swift       # User profile
└── .github/
    └── workflows/
        └── ios-build.yml           # CI/CD pipeline
```

---

## 🚀 Getting Started

### Prerequisites
- macOS 13.0+
- Xcode 16.0+
- iOS 17.0+ device or simulator

### Build & Run

1. Clone the repository:
   ```bash
   git clone https://github.com/link78/AyahSteps.git
   cd AyahSteps
   ```

2. Open in Xcode:
   ```bash
   open DeenLearn/DeenLearn.xcodeproj
   ```

3. Select a simulator or device and press `Cmd + R` to run

---

## 🏗 CI/CD

The project uses GitHub Actions for continuous integration:

- **Trigger**: Push to `main` or `copilot/*` branches, or pull requests
- **Runner**: macOS with Xcode 16
- **Build**: iOS Simulator (iPhone 15)

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- Qur'anic content based on authentic sources
- Hadith references from Sahih collections
- Tajwīd rules following traditional methodology
- Arabic letter forms following standard calligraphy

---

<p align="center">
  <strong>بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ</strong><br>
  <em>In the name of Allah, the Most Gracious, the Most Merciful</em>
</p>
