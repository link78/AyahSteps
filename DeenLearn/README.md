# DeenLearn 📖

**Islamic Learning for Kids & Adults**

DeenLearn is a beautifully designed iOS app that makes learning Islam simple, visual, joyful, and accessible for every age — from a 6-year-old learning wudu to an adult memorizing Qur'an.

## ✨ Features

### 🎯 Dual Learning Modes
- **Kids Mode** 🌟: Fun, colorful interface with gamification (points, streaks, achievements)
- **Adults Mode** 📚: Clean, professional design with in-depth content

### 📚 Learning Modules
- **Wudu (الوضوء)** - Step-by-step ablution guide
- **Salah (الصلاة)** - Learn the five daily prayers
- **Quran (القرآن)** - Memorization with Arabic, transliteration, and translation
- **Islamic Manners (الأخلاق)** - Daily etiquette for kids
- **Pillars of Islam (أركان الإسلام)** - Core beliefs for adults

### 🕌 Quran Section
- Short surahs for memorization
- Arabic text with proper formatting
- Transliteration for pronunciation
- English translation

### 📊 Progress Tracking
- Points system for kids
- Lesson completion tracking
- Daily streaks
- Achievement badges

## 🛠️ Technical Details

### Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Architecture
- **SwiftUI** for the entire UI
- **MVVM** architecture pattern
- **UserDefaults** for local data persistence
- **Environment Objects** for state management

### Project Structure
```
DeenLearn/
├── DeenLearn.xcodeproj/
├── DeenLearn/
│   ├── DeenLearnApp.swift      # App entry point
│   ├── ContentView.swift        # Root view
│   ├── Models/
│   │   ├── AppState.swift       # Global app state
│   │   └── LearningModule.swift # Data models
│   ├── Views/
│   │   ├── WelcomeView.swift    # Mode selection
│   │   ├── MainTabView.swift    # Tab navigation
│   │   ├── HomeView.swift       # Dashboard
│   │   ├── ModulesView.swift    # Learning modules
│   │   ├── LessonView.swift     # Individual lessons
│   │   ├── QuranView.swift      # Quran section
│   │   ├── ProgressView.swift   # Progress tracking
│   │   └── SettingsView.swift   # App settings
│   └── Assets.xcassets/         # App icons & colors
```

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/link78/AyahSteps.git
   cd AyahSteps/DeenLearn
   ```

2. **Open in Xcode**
   ```bash
   open DeenLearn.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## 🎨 Design Philosophy

### Colors
- **Kids Mode**: Warm coral (`#FF6B6B`) with playful accents
- **Adults Mode**: Serene green (`#2d8b6e`) inspired by Islamic art
- **Quran Section**: Royal purple (`#6B5B95`) for elegance

### Typography
- Arabic text displayed prominently
- Clear hierarchy with SF Pro font
- Accessible font sizes for all ages

### Accessibility
- VoiceOver support
- Dynamic Type support
- High contrast colors
- Clear touch targets

## 📱 Screenshots

The app features:
- Beautiful welcome screen with mode selection
- Tab-based navigation
- Card-based lesson layouts
- Step-by-step learning guides
- Progress visualization

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is part of the AyahSteps initiative - Making Islamic learning accessible for everyone.

## 🙏 Acknowledgments

- Islamic scholars for content guidance
- The Muslim community for inspiration
- Apple for SwiftUI framework

---

**بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ**

*In the name of Allah, the Most Gracious, the Most Merciful*
