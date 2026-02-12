import Foundation

// MARK: - AI Question Generator Service
/// Generates dynamic quiz questions based on topic and difficulty
class AIQuestionGeneratorService: ObservableObject {
    static let shared = AIQuestionGeneratorService()
    
    @Published var currentQuiz: [QuizQuestion] = []
    @Published var isGenerating = false
    
    private init() {}
    
    // MARK: - Models
    struct QuizQuestion: Identifiable {
        let id = UUID()
        let question: String
        let options: [String]
        let correctAnswerIndex: Int
        let explanation: String
        let category: Category
        let difficulty: Difficulty
        let points: Int
    }
    
    enum Category: String, CaseIterable {
        case pillars = "Pillars of Islam"
        case salah = "Prayer"
        case quran = "Qur'an"
        case arabic = "Arabic"
        case prophets = "Prophets"
        case manners = "Islamic Manners"
    }
    
    enum Difficulty: String, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        
        var points: Int {
            switch self {
            case .easy: return 10
            case .medium: return 20
            case .hard: return 30
            }
        }
    }
    
    // MARK: - Generate Quiz
    func generateQuiz(category: Category, count: Int, difficulty: Difficulty, isKidsMode: Bool) async -> [QuizQuestion] {
        await MainActor.run {
            isGenerating = true
        }
        
        // Simulate generation delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        let questions = getQuestionsForCategory(category, count: count, difficulty: difficulty, isKidsMode: isKidsMode)
        
        await MainActor.run {
            currentQuiz = questions
            isGenerating = false
        }
        
        return questions
    }
    
    // MARK: - Get Questions by Category
    private func getQuestionsForCategory(_ category: Category, count: Int, difficulty: Difficulty, isKidsMode: Bool) -> [QuizQuestion] {
        let allQuestions = isKidsMode 
            ? getKidsQuestions(for: category) 
            : getAdultQuestions(for: category)
        
        return Array(allQuestions.shuffled().prefix(count))
    }
    
    // MARK: - Kids Questions
    private func getKidsQuestions(for category: Category) -> [QuizQuestion] {
        switch category {
        case .pillars:
            return [
                QuizQuestion(
                    question: "🌟 How many pillars of Islam are there?",
                    options: ["3️⃣ Three", "5️⃣ Five", "7️⃣ Seven", "4️⃣ Four"],
                    correctAnswerIndex: 1,
                    explanation: "There are 5 pillars of Islam! They are like 5 strong pillars holding up a beautiful building! 🏛️",
                    category: .pillars,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "🕌 What is the first pillar of Islam?",
                    options: ["Prayer", "Shahada", "Fasting", "Hajj"],
                    correctAnswerIndex: 1,
                    explanation: "The Shahada is saying 'There is no god but Allah, and Muhammad is His messenger!' 💫",
                    category: .pillars,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "🌙 During which month do Muslims fast?",
                    options: ["Rajab", "Ramadan", "Shawwal", "Dhul Hijjah"],
                    correctAnswerIndex: 1,
                    explanation: "Ramadan is the special month of fasting! Muslims don't eat or drink during the day! 🌟",
                    category: .pillars,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "🕋 What is the name of Allah's special house in Makkah?",
                    options: ["Masjid", "Kaaba", "Minaret", "Mihrab"],
                    correctAnswerIndex: 1,
                    explanation: "The Kaaba is Allah's special house! Muslims face it when they pray! 🕋",
                    category: .pillars,
                    difficulty: .medium,
                    points: 20
                ),
                QuizQuestion(
                    question: "💝 What pillar is about sharing with those in need?",
                    options: ["Salah", "Hajj", "Zakat", "Shahada"],
                    correctAnswerIndex: 2,
                    explanation: "Zakat is giving charity to help people who need it! It makes everyone happy! 🎁",
                    category: .pillars,
                    difficulty: .medium,
                    points: 20
                )
            ]
            
        case .salah:
            return [
                QuizQuestion(
                    question: "🌅 How many times do Muslims pray every day?",
                    options: ["3 times", "5 times", "7 times", "2 times"],
                    correctAnswerIndex: 1,
                    explanation: "Muslims pray 5 times a day! Fajr, Dhuhr, Asr, Maghrib, and Isha! 🕌",
                    category: .salah,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "💧 What do we do before prayer to get clean?",
                    options: ["Wudu", "Sleep", "Eat", "Play"],
                    correctAnswerIndex: 0,
                    explanation: "Wudu is washing to get clean before talking to Allah! We wash hands, face, arms, head, and feet! 💧",
                    category: .salah,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "🌄 What is the name of the morning prayer?",
                    options: ["Asr", "Maghrib", "Fajr", "Isha"],
                    correctAnswerIndex: 2,
                    explanation: "Fajr is the dawn prayer! We wake up early to pray when the sun starts to rise! 🌅",
                    category: .salah,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "🧎 What is it called when we put our forehead on the ground?",
                    options: ["Ruku", "Sujud", "Qiyam", "Tashahhud"],
                    correctAnswerIndex: 1,
                    explanation: "Sujud is when we bow down with our forehead on the ground! It shows love for Allah! 🤲",
                    category: .salah,
                    difficulty: .medium,
                    points: 20
                ),
                QuizQuestion(
                    question: "🧭 Which direction do Muslims face when praying?",
                    options: ["East", "Towards the Kaaba", "West", "North"],
                    correctAnswerIndex: 1,
                    explanation: "Muslims face the Kaaba in Makkah when they pray! It's called the Qibla! 🕋",
                    category: .salah,
                    difficulty: .medium,
                    points: 20
                )
            ]
            
        case .quran:
            return [
                QuizQuestion(
                    question: "📖 What is the holy book of Islam?",
                    options: ["Bible", "Qur'an", "Torah", "Vedas"],
                    correctAnswerIndex: 1,
                    explanation: "The Qur'an is Allah's special book sent to Prophet Muhammad ﷺ! 📖",
                    category: .quran,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "🌟 What is the first surah (chapter) of the Qur'an?",
                    options: ["Al-Nas", "Al-Fatihah", "Al-Ikhlas", "Al-Baqarah"],
                    correctAnswerIndex: 1,
                    explanation: "Al-Fatihah means 'The Opening'! It's the first chapter we read in every prayer! 🌟",
                    category: .quran,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "👼 Who brought the Qur'an to Prophet Muhammad ﷺ?",
                    options: ["Angel Mikail", "Angel Jibreel", "Angel Israfil", "Angel Azrael"],
                    correctAnswerIndex: 1,
                    explanation: "Angel Jibreel (Gabriel) brought Allah's words to Prophet Muhammad ﷺ! 👼",
                    category: .quran,
                    difficulty: .medium,
                    points: 20
                )
            ]
            
        case .arabic:
            return [
                QuizQuestion(
                    question: "🔤 How many letters are in the Arabic alphabet?",
                    options: ["26", "28", "30", "24"],
                    correctAnswerIndex: 1,
                    explanation: "The Arabic alphabet has 28 letters! Each one has a special sound! 🔤",
                    category: .arabic,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "✍️ Which direction do we write Arabic?",
                    options: ["Left to right", "Right to left", "Top to bottom", "Bottom to top"],
                    correctAnswerIndex: 1,
                    explanation: "Arabic is written from right to left! It's the opposite of English! ✍️",
                    category: .arabic,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "🅰️ What is the first letter of the Arabic alphabet?",
                    options: ["Ba (ب)", "Alif (ا)", "Ta (ت)", "Jim (ج)"],
                    correctAnswerIndex: 1,
                    explanation: "Alif (ا) is the first letter! It looks like a tall stick! 🅰️",
                    category: .arabic,
                    difficulty: .easy,
                    points: 10
                )
            ]
            
        case .prophets:
            return [
                QuizQuestion(
                    question: "🌟 Who is the last prophet in Islam?",
                    options: ["Prophet Isa", "Prophet Musa", "Prophet Muhammad ﷺ", "Prophet Ibrahim"],
                    correctAnswerIndex: 2,
                    explanation: "Prophet Muhammad ﷺ is the last and final prophet! He brought the complete message of Islam! 💚",
                    category: .prophets,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "🚢 Which prophet built a big boat called an ark?",
                    options: ["Prophet Musa", "Prophet Nuh", "Prophet Yunus", "Prophet Sulayman"],
                    correctAnswerIndex: 1,
                    explanation: "Prophet Nuh (Noah) built a big ark and saved the animals from the flood! 🚢",
                    category: .prophets,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "🌊 Which prophet crossed the sea when it split in two?",
                    options: ["Prophet Isa", "Prophet Musa", "Prophet Yusuf", "Prophet Dawud"],
                    correctAnswerIndex: 1,
                    explanation: "Prophet Musa (Moses) crossed the Red Sea when Allah split it in two! Amazing! 🌊",
                    category: .prophets,
                    difficulty: .medium,
                    points: 20
                )
            ]
            
        case .manners:
            return [
                QuizQuestion(
                    question: "🍽️ What do we say before eating?",
                    options: ["Alhamdulillah", "Bismillah", "SubhanAllah", "MashaAllah"],
                    correctAnswerIndex: 1,
                    explanation: "We say 'Bismillah' (In the name of Allah) before eating! 🍽️",
                    category: .manners,
                    difficulty: .easy,
                    points: 10
                ),
                QuizQuestion(
                    question: "😊 What do we say when someone thanks us?",
                    options: ["Bismillah", "JazakAllah Khair", "Alhamdulillah", "Wa iyyak"],
                    correctAnswerIndex: 3,
                    explanation: "We say 'Wa iyyak' which means 'And to you too'! It's polite! 😊",
                    category: .manners,
                    difficulty: .medium,
                    points: 20
                ),
                QuizQuestion(
                    question: "🤧 What do we say when someone sneezes?",
                    options: ["Alhamdulillah", "Yarhamukallah", "Bismillah", "SubhanAllah"],
                    correctAnswerIndex: 1,
                    explanation: "We say 'Yarhamukallah' (May Allah have mercy on you) when someone sneezes! 🤧",
                    category: .manners,
                    difficulty: .medium,
                    points: 20
                )
            ]
        }
    }
    
    // MARK: - Adult Questions
    private func getAdultQuestions(for category: Category) -> [QuizQuestion] {
        switch category {
        case .pillars:
            return [
                QuizQuestion(
                    question: "What is the minimum amount of wealth (Nisab) required for Zakat on gold?",
                    options: ["75 grams", "85 grams", "95 grams", "100 grams"],
                    correctAnswerIndex: 1,
                    explanation: "The Nisab for gold is approximately 85 grams (or 7.5 tolas), after which 2.5% Zakat becomes obligatory.",
                    category: .pillars,
                    difficulty: .hard,
                    points: 30
                ),
                QuizQuestion(
                    question: "Which of the following is NOT one of the eight categories of Zakat recipients mentioned in the Qur'an?",
                    options: ["Those in debt", "Orphans", "Those whose hearts need reconciliation", "Travelers in need"],
                    correctAnswerIndex: 1,
                    explanation: "The eight categories are: the poor, the needy, Zakat administrators, those whose hearts are to be reconciled, freeing slaves, those in debt, in the cause of Allah, and travelers. Orphans are not a specific category, though they may qualify under other categories.",
                    category: .pillars,
                    difficulty: .hard,
                    points: 30
                ),
                QuizQuestion(
                    question: "According to majority scholarly opinion, what is the essential pillar (rukn) of Hajj that cannot be compensated if missed?",
                    options: ["Tawaf al-Ifadah", "Standing at Arafat", "Sa'i between Safa and Marwah", "Stoning the Jamarat"],
                    correctAnswerIndex: 1,
                    explanation: "Standing at Arafat (Wuquf) is the essential pillar of Hajj. The Prophet ﷺ said: 'Hajj is Arafat.'",
                    category: .pillars,
                    difficulty: .hard,
                    points: 30
                )
            ]
            
        case .salah:
            return [
                QuizQuestion(
                    question: "What is the minimum number of rak'at for Witr prayer?",
                    options: ["1 rak'ah", "2 rak'at", "3 rak'at", "5 rak'at"],
                    correctAnswerIndex: 0,
                    explanation: "The minimum for Witr is 1 rak'ah, though 3 or more (odd number) is preferred. The Prophet ﷺ said: 'Make your last prayer of the night witr.'",
                    category: .salah,
                    difficulty: .medium,
                    points: 20
                ),
                QuizQuestion(
                    question: "In the Hanafi madhab, what invalidates wudu that doesn't in the Shafi'i madhab?",
                    options: ["Bleeding from the body", "Touching the opposite gender", "Laughing loudly in prayer", "Both A and C"],
                    correctAnswerIndex: 3,
                    explanation: "In Hanafi fiqh, bleeding and laughing loudly during prayer invalidate wudu, while these don't break wudu in Shafi'i fiqh.",
                    category: .salah,
                    difficulty: .hard,
                    points: 30
                )
            ]
            
        case .quran:
            return [
                QuizQuestion(
                    question: "How many years did the revelation of the Qur'an span?",
                    options: ["10 years", "13 years", "23 years", "25 years"],
                    correctAnswerIndex: 2,
                    explanation: "The Qur'an was revealed over approximately 23 years - 13 years in Makkah and 10 years in Madinah.",
                    category: .quran,
                    difficulty: .medium,
                    points: 20
                ),
                QuizQuestion(
                    question: "Which surah is known as 'The Heart of the Qur'an'?",
                    options: ["Al-Fatihah", "Al-Baqarah", "Ya-Sin", "Al-Rahman"],
                    correctAnswerIndex: 2,
                    explanation: "Surah Ya-Sin is referred to as 'The Heart of the Qur'an' in hadith literature due to its comprehensive message.",
                    category: .quran,
                    difficulty: .medium,
                    points: 20
                )
            ]
            
        case .arabic:
            return [
                QuizQuestion(
                    question: "What is the term for the short vowel marks in Arabic?",
                    options: ["Sukun", "Harakat", "Tanwin", "Shadda"],
                    correctAnswerIndex: 1,
                    explanation: "Harakat (حركات) refers to the short vowel marks: fatha, kasra, and damma.",
                    category: .arabic,
                    difficulty: .medium,
                    points: 20
                ),
                QuizQuestion(
                    question: "In Arabic grammar, what is the term for a definite noun?",
                    options: ["Nakirah", "Ma'rifah", "Ism", "Fi'l"],
                    correctAnswerIndex: 1,
                    explanation: "Ma'rifah (معرفة) refers to a definite noun, while Nakirah is an indefinite noun.",
                    category: .arabic,
                    difficulty: .hard,
                    points: 30
                )
            ]
            
        case .prophets, .manners:
            return [
                QuizQuestion(
                    question: "According to hadith, approximately how many prophets were sent throughout history?",
                    options: ["25", "124,000", "313", "1,000"],
                    correctAnswerIndex: 1,
                    explanation: "According to hadith narrations, approximately 124,000 prophets were sent, with 313 being messengers (rasul).",
                    category: .prophets,
                    difficulty: .hard,
                    points: 30
                )
            ]
        }
    }
    
    // MARK: - Generate Random Quiz
    func generateRandomQuiz(count: Int, isKidsMode: Bool) async -> [QuizQuestion] {
        await MainActor.run {
            isGenerating = true
        }
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        var allQuestions: [QuizQuestion] = []
        for category in Category.allCases {
            let questions = isKidsMode 
                ? getKidsQuestions(for: category)
                : getAdultQuestions(for: category)
            allQuestions.append(contentsOf: questions)
        }
        
        let selectedQuestions = Array(allQuestions.shuffled().prefix(count))
        
        await MainActor.run {
            currentQuiz = selectedQuestions
            isGenerating = false
        }
        
        return selectedQuestions
    }
}
