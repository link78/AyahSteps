//
//  DuaKidsView.swift
//  DeenLearn
//
//  Interactive Dua module for Kids Mode under Prayer tab
//  Story mode, characters, visual learning, quizzes, and mini-games
//

import SwiftUI

// MARK: - Dua Kids Data Models

struct DuaStoryPage: Identifiable {
    let id = UUID()
    let text: String
    let emoji: String
    let isDuaGlowMoment: Bool
}

struct DuaLearningCard: Identifiable {
    let id = UUID()
    let question: String
    let emoji: String
    let options: [String]
    let correctAnswer: Int
}

struct KidsDuaStory: Identifiable {
    let id: String
    let duaName: String
    let arabic: String
    let transliteration: String
    let translation: String
    let storyTitle: String
    let character: String
    let characterEmoji: String
    let storyPages: [DuaStoryPage]
    let moralLesson: String
    let learningCards: [DuaLearningCard]
    let situationEmoji: String
    let timesToRecite: Int
    let relatedHadithCollection: String
    let relatedHadithNumber: Int
}

struct DuaQuiz: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

enum DuaMiniGameType: String, CaseIterable {
    case duaMatch = "Dua Match"
    case wordComplete = "Word Complete"
    case situationPicker = "Situation Picker"

    var emoji: String {
        switch self {
        case .duaMatch: return "🔗"
        case .wordComplete: return "📝"
        case .situationPicker: return "🎯"
        }
    }
}

// MARK: - Static Dua Data

struct DuaKidsData {
    static let stories: [KidsDuaStory] = [
        // MARK: Dua 1 - Astaghfirullah
        KidsDuaStory(
            id: "dua_kids_1",
            duaName: "Astaghfirullah",
            arabic: "أَسْتَغْفِرُ اللَّهَ",
            transliteration: "Astaghfirullah",
            translation: "I seek forgiveness from Allah",
            storyTitle: "Sami's Eraser of Mistakes",
            character: "Sami",
            characterEmoji: "👦",
            storyPages: [
                DuaStoryPage(text: "Sami had a rough day. He accidentally said something mean to his friend, forgot to help Mama, and didn't finish his homework. He felt a heavy weight in his heart.", emoji: "😔", isDuaGlowMoment: false),
                DuaStoryPage(text: "Noor the lantern noticed Sami was sad. 'What's wrong, Sami?' she asked gently. 'I made so many mistakes today,' Sami sighed. 'I wish I could erase them all.'", emoji: "🏮", isDuaGlowMoment: false),
                DuaStoryPage(text: "Grandpa Kareem sat beside Sami and said: 'Allah gave us a magical eraser! After every prayer, say Astaghfirullah three times. It cleans your heart like rain cleans the earth.'", emoji: "👴", isDuaGlowMoment: false),
                DuaStoryPage(text: "Sami closed his eyes after prayer and said: 'Astaghfirullah, Astaghfirullah, Astaghfirullah.' He felt the heaviness lift away! Noor glowed bright and warm. Allah loves to forgive — and He never runs out of forgiveness!", emoji: "✨", isDuaGlowMoment: true)
            ],
            moralLesson: "No matter how many mistakes we make, Allah always forgives us when we sincerely ask. Astaghfirullah is like a magical eraser for our hearts!",
            learningCards: [
                DuaLearningCard(question: "What does Astaghfirullah mean?", emoji: "🤔", options: ["Thank you Allah", "I seek forgiveness from Allah", "Allah is great", "Praise be to Allah"], correctAnswer: 1),
                DuaLearningCard(question: "How many times do we say it after prayer?", emoji: "🔢", options: ["Once", "Twice", "Three times", "Ten times"], correctAnswer: 2),
                DuaLearningCard(question: "What did Grandpa compare it to?", emoji: "🌧️", options: ["A magic wand", "An eraser", "A toy", "A book"], correctAnswer: 1)
            ],
            situationEmoji: "🤲",
            timesToRecite: 3,
            relatedHadithCollection: "muslim",
            relatedHadithNumber: 591
        ),

        // MARK: Dua 2 - SubhanAllah
        KidsDuaStory(
            id: "dua_kids_2",
            duaName: "SubhanAllah",
            arabic: "سُبْحَانَ اللَّهِ",
            transliteration: "SubhanAllah",
            translation: "Glory be to Allah",
            storyTitle: "Amina Discovers Allah's Wonders",
            character: "Amina",
            characterEmoji: "👧",
            storyPages: [
                DuaStoryPage(text: "Amina was walking in the garden after Dhuhr prayer. She noticed a tiny caterpillar on a leaf, slowly munching away. 'SubhanAllah!' she whispered, amazed at its tiny feet.", emoji: "🐛", isDuaGlowMoment: false),
                DuaStoryPage(text: "Then she looked up and saw a butterfly with the most beautiful wings — orange, blue, and gold! 'That caterpillar will become THIS?' she gasped. 'SubhanAllah!'", emoji: "🦋", isDuaGlowMoment: false),
                DuaStoryPage(text: "Grandpa Kareem was gardening nearby. He smiled and said: 'Amina, when we say SubhanAllah 33 times after prayer, each one is like planting a seed of light in our hearts!'", emoji: "🌱", isDuaGlowMoment: false),
                DuaStoryPage(text: "That evening, Amina said SubhanAllah 33 times after Maghrib prayer, thinking of every amazing thing Allah created. Noor glowed with each count! The Prophet ﷺ said this fills the scale of good deeds. SubhanAllah!", emoji: "✨", isDuaGlowMoment: true)
            ],
            moralLesson: "SubhanAllah means we recognize how perfect and amazing Allah is. Every creation — from tiny caterpillars to beautiful butterflies — shows Allah's glory!",
            learningCards: [
                DuaLearningCard(question: "What does SubhanAllah mean?", emoji: "🌟", options: ["Hello", "Glory be to Allah", "Good morning", "Thank you"], correctAnswer: 1),
                DuaLearningCard(question: "How many times after prayer?", emoji: "🔢", options: ["3 times", "10 times", "33 times", "100 times"], correctAnswer: 2),
                DuaLearningCard(question: "What amazed Amina in the garden?", emoji: "🦋", options: ["A car", "A caterpillar and butterfly", "A phone", "A ball"], correctAnswer: 1)
            ],
            situationEmoji: "🌺",
            timesToRecite: 33,
            relatedHadithCollection: "muslim",
            relatedHadithNumber: 597
        ),

        // MARK: Dua 3 - Alhamdulillah
        KidsDuaStory(
            id: "dua_kids_3",
            duaName: "Alhamdulillah",
            arabic: "الْحَمْدُ لِلَّهِ",
            transliteration: "Alhamdulillah",
            translation: "All praise is due to Allah",
            storyTitle: "Zayd's Gratitude Adventure",
            character: "Zayd",
            characterEmoji: "😄",
            storyPages: [
                DuaStoryPage(text: "Zayd woke up and stretched. 'Another boring day,' he mumbled. But then Noor appeared: 'Boring? Let's count your blessings, Zayd!' A golden list appeared in the air.", emoji: "📜", isDuaGlowMoment: false),
                DuaStoryPage(text: "'You can SEE this beautiful sunrise — Alhamdulillah! You can HEAR the birds singing — Alhamdulillah! You can WALK to the masjid — Alhamdulillah!' The list kept growing and growing!", emoji: "☀️", isDuaGlowMoment: false),
                DuaStoryPage(text: "By the time Zayd reached the masjid for Fajr, he had counted 33 blessings! His friend said: 'Why are you smiling so much?' Zayd laughed: 'Because I'm the richest person in the world!'", emoji: "😊", isDuaGlowMoment: false),
                DuaStoryPage(text: "After prayer, Zayd said Alhamdulillah 33 times with his whole heart. Each one felt like a warm hug from Allah. The Prophet ﷺ said: Alhamdulillah fills the scales of good deeds! Zayd's day was no longer boring — it was blessed!", emoji: "✨", isDuaGlowMoment: true)
            ],
            moralLesson: "When we say Alhamdulillah, we thank Allah for every single blessing. Even things we think are 'normal' — like seeing, hearing, and walking — are amazing gifts!",
            learningCards: [
                DuaLearningCard(question: "What does Alhamdulillah mean?", emoji: "🙏", options: ["I'm sorry", "All praise is due to Allah", "Goodbye", "Good night"], correctAnswer: 1),
                DuaLearningCard(question: "What did Zayd learn?", emoji: "💡", options: ["Life is boring", "He has many blessings to be grateful for", "He should sleep more", "Nothing important"], correctAnswer: 1),
                DuaLearningCard(question: "How many times after prayer?", emoji: "🔢", options: ["3 times", "33 times", "7 times", "Once"], correctAnswer: 1)
            ],
            situationEmoji: "🌈",
            timesToRecite: 33,
            relatedHadithCollection: "muslim",
            relatedHadithNumber: 597
        ),

        // MARK: Dua 4 - Allahu Akbar
        KidsDuaStory(
            id: "dua_kids_4",
            duaName: "Allahu Akbar",
            arabic: "اللَّهُ أَكْبَرُ",
            transliteration: "Allahu Akbar",
            translation: "Allah is the Greatest",
            storyTitle: "Sami Faces the Big Test",
            character: "Sami",
            characterEmoji: "👦",
            storyPages: [
                DuaStoryPage(text: "Sami was nervous. Tomorrow was the biggest Quran recitation test at school. His hands were shaking. 'What if I forget everything?' he worried.", emoji: "😰", isDuaGlowMoment: false),
                DuaStoryPage(text: "Noor floated beside him and said: 'Sami, when you feel small and scared, remember something BIG — Allahu Akbar! Allah is greater than any problem or fear you have.'", emoji: "🏮", isDuaGlowMoment: false),
                DuaStoryPage(text: "Sami prayed Isha that night and said Allahu Akbar 33 times after prayer. With each one, his worries got smaller and smaller. Allah is bigger than any test!", emoji: "🌙", isDuaGlowMoment: false),
                DuaStoryPage(text: "The next day, Sami walked in confident. He recited beautifully! Noor glowed with pride. Sami whispered: 'Allahu Akbar — Allah helped me because He is the Greatest!' The whole class clapped.", emoji: "✨", isDuaGlowMoment: true)
            ],
            moralLesson: "When we say Allahu Akbar, we remember that Allah is greater than any problem, any fear, and any challenge. With Allah on our side, we can do anything!",
            learningCards: [
                DuaLearningCard(question: "What does Allahu Akbar mean?", emoji: "🌟", options: ["Hello friend", "Allah is the Greatest", "Thank you", "Good morning"], correctAnswer: 1),
                DuaLearningCard(question: "What was Sami afraid of?", emoji: "📖", options: ["A monster", "His Quran recitation test", "The dark", "Swimming"], correctAnswer: 1),
                DuaLearningCard(question: "How did Sami feel after saying Allahu Akbar?", emoji: "💪", options: ["More scared", "Confident and brave", "Sleepy", "Hungry"], correctAnswer: 1)
            ],
            situationEmoji: "🕌",
            timesToRecite: 33,
            relatedHadithCollection: "muslim",
            relatedHadithNumber: 597
        ),

        // MARK: Dua 5 - Ayatul Kursi
        KidsDuaStory(
            id: "dua_kids_5",
            duaName: "Ayatul Kursi",
            arabic: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ",
            transliteration: "Allahu la ilaha illa huwal-Hayyul-Qayyum...",
            translation: "Allah — there is no deity except Him, the Ever-Living, the Sustainer of existence.",
            storyTitle: "Amina's Shield of Light",
            character: "Amina",
            characterEmoji: "👧",
            storyPages: [
                DuaStoryPage(text: "It was a stormy night. Thunder crashed and lightning lit up the sky. Amina pulled the blanket over her head. 'I'm scared,' she whispered.", emoji: "⛈️", isDuaGlowMoment: false),
                DuaStoryPage(text: "Grandpa Kareem came to her room. 'Amina, do you know about the most powerful ayah in the Quran? It's called Ayatul Kursi — the Verse of the Throne. It's like a shield of light!'", emoji: "👴", isDuaGlowMoment: false),
                DuaStoryPage(text: "He taught her to recite it after every prayer. 'The Prophet ﷺ said whoever recites Ayatul Kursi after every prayer, nothing prevents them from entering Paradise except death.'", emoji: "📖", isDuaGlowMoment: false),
                DuaStoryPage(text: "Amina recited Ayatul Kursi. Suddenly, she felt wrapped in a warm, glowing shield. Noor shone brighter than ever! The storm didn't seem scary anymore — Allah's protection was bigger than any storm!", emoji: "✨", isDuaGlowMoment: true)
            ],
            moralLesson: "Ayatul Kursi is the most powerful verse in the Quran. Reciting it after every prayer is like putting on a shield of light — Allah's protection!",
            learningCards: [
                DuaLearningCard(question: "What is Ayatul Kursi?", emoji: "📖", options: ["A story", "The most powerful verse in the Quran", "A song", "A game"], correctAnswer: 1),
                DuaLearningCard(question: "When should we recite it?", emoji: "🕌", options: ["Only on Fridays", "After every prayer", "Only at night", "Once a year"], correctAnswer: 1),
                DuaLearningCard(question: "What did Grandpa compare it to?", emoji: "🛡️", options: ["A sword", "A shield of light", "A toy", "A blanket"], correctAnswer: 1)
            ],
            situationEmoji: "🛡️",
            timesToRecite: 1,
            relatedHadithCollection: "nasai",
            relatedHadithNumber: 9928
        ),

        // MARK: Dua 6 - Allahumma Antas-Salam
        KidsDuaStory(
            id: "dua_kids_6",
            duaName: "Allahumma Antas-Salam",
            arabic: "اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ",
            transliteration: "Allahumma antas-salam wa minkas-salam, tabarakta ya dhal-jalali wal-ikram",
            translation: "O Allah, You are Peace and from You comes peace. Blessed are You, O Owner of majesty and honor.",
            storyTitle: "Zayd Finds Inner Peace",
            character: "Zayd",
            characterEmoji: "😄",
            storyPages: [
                DuaStoryPage(text: "Zayd and his friend got into a big argument at school. They said mean things to each other, and now Zayd felt terrible. His heart was racing and he couldn't concentrate.", emoji: "😤", isDuaGlowMoment: false),
                DuaStoryPage(text: "At Dhuhr prayer time, Zayd prayed with his class. After finishing, he remembered Grandpa Kareem's words: 'Always say the peace dua first — before anything else after prayer.'", emoji: "🕌", isDuaGlowMoment: false),
                DuaStoryPage(text: "Zayd whispered: 'Allahumma antas-salam wa minkas-salam...' He asked Allah — the Source of all Peace — to fill his heart with peace too.", emoji: "🤲", isDuaGlowMoment: false),
                DuaStoryPage(text: "A wave of calm washed over Zayd. Noor glowed gently. Zayd walked over to his friend and said: 'Assalamu Alaikum — I'm sorry.' His friend smiled. Peace from Allah filled both their hearts!", emoji: "✨", isDuaGlowMoment: true)
            ],
            moralLesson: "Allah is As-Salam — the Source of Peace. When we feel upset or angry, we can ask Allah for peace, and He will calm our hearts!",
            learningCards: [
                DuaLearningCard(question: "What does As-Salam mean?", emoji: "☮️", options: ["The Strong", "The Peace", "The King", "The Creator"], correctAnswer: 1),
                DuaLearningCard(question: "When do we say this dua?", emoji: "⏰", options: ["Before prayer", "Right after finishing prayer", "At bedtime", "At breakfast"], correctAnswer: 1),
                DuaLearningCard(question: "What did Zayd do after feeling peaceful?", emoji: "🤝", options: ["Ignored his friend", "Apologized to his friend", "Went home", "Got angry again"], correctAnswer: 1)
            ],
            situationEmoji: "☮️",
            timesToRecite: 1,
            relatedHadithCollection: "muslim",
            relatedHadithNumber: 591
        ),

        // MARK: Dua 7 - La ilaha illallah
        KidsDuaStory(
            id: "dua_kids_7",
            duaName: "La ilaha illallah",
            arabic: "لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ",
            transliteration: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd...",
            translation: "There is no deity but Allah alone, with no partner. To Him belongs the dominion and all praise.",
            storyTitle: "Grandpa Kareem's Greatest Treasure",
            character: "Grandpa Kareem",
            characterEmoji: "👴",
            storyPages: [
                DuaStoryPage(text: "One evening, all the children gathered around Grandpa Kareem. 'Grandpa, what's the most valuable thing in the whole world?' asked Sami. 'Is it gold? Diamonds? A rocket ship?'", emoji: "💎", isDuaGlowMoment: false),
                DuaStoryPage(text: "Grandpa Kareem laughed warmly. 'None of those, my dear children! The most valuable treasure is these words: La ilaha illallah — There is no god but Allah.' The children leaned in closer.", emoji: "👴", isDuaGlowMoment: false),
                DuaStoryPage(text: "'After completing SubhanAllah, Alhamdulillah, and Allahu Akbar — 33 each — we say this beautiful declaration once. It completes 100 praises! And the reward? All your minor sins are forgiven!'", emoji: "💯", isDuaGlowMoment: false),
                DuaStoryPage(text: "All the children said it together: 'La ilaha illallahu wahdahu la sharika lah...' Noor glowed with a light brighter than the sun! These words are the key to Jannah — the greatest treasure of all!", emoji: "✨", isDuaGlowMoment: true)
            ],
            moralLesson: "La ilaha illallah is the most important sentence in Islam. Saying it with understanding and love after prayer completes our remembrance of Allah!",
            learningCards: [
                DuaLearningCard(question: "What does La ilaha illallah mean?", emoji: "🌟", options: ["Good morning", "There is no god but Allah", "Thank you", "See you later"], correctAnswer: 1),
                DuaLearningCard(question: "How many total praises do we complete?", emoji: "💯", options: ["33", "50", "99", "100"], correctAnswer: 3),
                DuaLearningCard(question: "What did Grandpa call these words?", emoji: "💎", options: ["A game", "The greatest treasure", "A joke", "A secret"], correctAnswer: 1)
            ],
            situationEmoji: "🔑",
            timesToRecite: 1,
            relatedHadithCollection: "muslim",
            relatedHadithNumber: 597
        )
    ]

    static let quizzes: [DuaQuiz] = [
        DuaQuiz(question: "After prayer, what do we say 3 times first?", options: ["SubhanAllah", "Astaghfirullah", "Allahu Akbar", "Alhamdulillah"], correctAnswer: 1, explanation: "We say Astaghfirullah 3 times first, asking Allah's forgiveness for any mistakes in our prayer."),
        DuaQuiz(question: "What comes after the peace dua?", options: ["Sleeping", "SubhanAllah 33 times", "Eating", "Playing"], correctAnswer: 1, explanation: "After the peace dua, we say SubhanAllah 33 times, then Alhamdulillah 33 times, then Allahu Akbar 33 times!"),
        DuaQuiz(question: "What is the most powerful verse in the Quran?", options: ["Al-Fatiha", "Ayatul Kursi", "Al-Ikhlas", "Al-Falaq"], correctAnswer: 1, explanation: "Ayatul Kursi (The Verse of the Throne) is the most powerful verse. Recite it after every prayer!"),
        DuaQuiz(question: "How many total adhkar make up the post-prayer count?", options: ["33", "66", "99", "100"], correctAnswer: 3, explanation: "SubhanAllah (33) + Alhamdulillah (33) + Allahu Akbar (33) + La ilaha illallah (1) = 100!"),
        DuaQuiz(question: "What does As-Salam mean?", options: ["The Creator", "The Peace", "The King", "The Powerful"], correctAnswer: 1, explanation: "As-Salam means 'The Peace' — Allah is the source of all peace in the world!"),
        DuaQuiz(question: "What reward does Ayatul Kursi after prayer give?", options: ["Extra recess", "Nothing prevents Paradise except death", "A new toy", "Good grades"], correctAnswer: 1, explanation: "The Prophet ﷺ said whoever recites Ayatul Kursi after every prayer, nothing prevents them from entering Paradise except death!")
    ]
}

// MARK: - DuaKidsView

struct DuaKidsView: View {
    let isKidsMode: Bool
    @State private var selectedStory: KidsDuaStory?
    @State private var showQuiz = false
    @State private var showMiniGame = false
    @State private var selectedMiniGame: DuaMiniGameType = .duaMatch
    @State private var earnedStars = 0
    @StateObject private var ttsService = TextToSpeechService.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                duaHeader

                // Star counter
                starCounter

                // Story Cards
                duaStoriesSection

                // Quiz Section
                quizButton

                // Mini-Games Section
                miniGamesSection
            }
            .padding(.bottom, 40)
        }
        .sheet(item: $selectedStory) { story in
            DuaStoryPlayerView(story: story, earnedStars: $earnedStars)
        }
        .sheet(isPresented: $showQuiz) {
            DuaQuizGameView(earnedStars: $earnedStars)
        }
        .sheet(isPresented: $showMiniGame) {
            DuaMiniGameView(gameType: selectedMiniGame, earnedStars: $earnedStars)
        }
    }

    // MARK: - Header

    private var duaHeader: some View {
        VStack(spacing: 12) {
            Text("🤲")
                .font(.system(size: 50))

            Text("Dua Stories World")
                .font(.title2.bold())
                .foregroundColor(Color(hex: "FF6B6B"))

            Text("Learn beautiful duas after prayer through fun stories!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Order guide
            HStack(spacing: 8) {
                ForEach(["Astaghfir", "Peace Dua", "SubhanAllah", "Alhamdulillah", "Allahu Akbar", "Complete", "Ayatul Kursi"], id: \.self) { step in
                    VStack(spacing: 2) {
                        Circle()
                            .fill(Color(hex: "FF6B6B").opacity(0.3))
                            .frame(width: 8, height: 8)
                        Text(step)
                            .font(.system(size: 7))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .padding()
    }

    // MARK: - Star Counter

    private var starCounter: some View {
        HStack {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
            Text("\(earnedStars) Stars Earned")
                .font(.headline)
                .foregroundColor(Color(hex: "FF6B6B"))
            Spacer()
            Text("Keep learning! 🌟")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    // MARK: - Dua Stories Section

    private var duaStoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📖 Dua Stories")
                .font(.headline)
                .padding(.horizontal)

            ForEach(DuaKidsData.stories) { story in
                Button(action: { selectedStory = story }) {
                    HStack(spacing: 12) {
                        // Character emoji
                        Text(story.characterEmoji)
                            .font(.system(size: 36))
                            .frame(width: 50, height: 50)
                            .background(Color(hex: "FF6B6B").opacity(0.1))
                            .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(story.storyTitle)
                                .font(.subheadline.bold())
                                .foregroundColor(.primary)

                            HStack(spacing: 4) {
                                Text(story.situationEmoji)
                                Text(story.duaName)
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "FF6B6B"))
                            }

                            Text(story.translation)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()

                        VStack(spacing: 2) {
                            Text("×\(story.timesToRecite)")
                                .font(.caption.bold())
                                .foregroundColor(Color(hex: "FF6B6B"))
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Quiz Button

    private var quizButton: some View {
        Button(action: { showQuiz = true }) {
            HStack {
                Text("❓")
                    .font(.title)
                VStack(alignment: .leading) {
                    Text("Dua Quiz Challenge")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Test your knowledge and earn stars!")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(colors: [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")], startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }

    // MARK: - Mini-Games Section

    private var miniGamesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎮 Mini-Games")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(DuaMiniGameType.allCases, id: \.rawValue) { game in
                        Button(action: {
                            selectedMiniGame = game
                            showMiniGame = true
                        }) {
                            VStack(spacing: 8) {
                                Text(game.emoji)
                                    .font(.system(size: 30))
                                Text(game.rawValue)
                                    .font(.caption.bold())
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 100, height: 90)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Story Player View

struct DuaStoryPlayerView: View {
    let story: KidsDuaStory
    @Binding var earnedStars: Int
    @Environment(\.dismiss) var dismiss
    @State private var currentPage = 0
    @State private var showLearningCards = false
    @State private var glowAnimation = false
    @StateObject private var ttsService = TextToSpeechService.shared

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color(hex: "FFF5F5"), Color(hex: "FFE8E8")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if showLearningCards {
                    learningCardsView
                } else {
                    storyContentView
                }
            }
            .navigationTitle(story.storyTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var storyContentView: some View {
        VStack(spacing: 20) {
            // Character
            VStack(spacing: 4) {
                Text(story.characterEmoji)
                    .font(.system(size: 60))
                Text(story.character)
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "FF6B6B"))
            }

            // Story page
            let page = story.storyPages[currentPage]
            VStack(spacing: 16) {
                Text(page.emoji)
                    .font(.system(size: 50))
                    .scaleEffect(page.isDuaGlowMoment && glowAnimation ? 1.3 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: glowAnimation)

                Text(page.text)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()

                if page.isDuaGlowMoment {
                    // Dua Glow Moment — show Arabic
                    VStack(spacing: 8) {
                        Text("✨ Dua Light ✨")
                            .font(.caption.bold())
                            .foregroundColor(Color(hex: "FF6B6B"))

                        Button(action: {
                            ttsService.speak(story.arabic, language: "ar-SA")
                        }) {
                            Text(story.arabic)
                                .font(.title3)
                                .foregroundColor(Color(hex: "1a5f4a"))
                                .padding()
                                .background(Color.yellow.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text(story.transliteration)
                            .font(.caption)
                            .foregroundColor(.blue)

                        Text(story.translation)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
            .padding(.horizontal)

            // Page indicator
            HStack(spacing: 8) {
                ForEach(0..<story.storyPages.count, id: \.self) { i in
                    Circle()
                        .fill(i == currentPage ? Color(hex: "FF6B6B") : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
            }

            // Navigation
            HStack(spacing: 20) {
                if currentPage > 0 {
                    Button(action: { withAnimation { currentPage -= 1 } }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.headline)
                        .foregroundColor(Color(hex: "FF6B6B"))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color(hex: "FF6B6B").opacity(0.1))
                        .cornerRadius(12)
                    }
                }

                if currentPage < story.storyPages.count - 1 {
                    Button(action: { withAnimation { currentPage += 1 } }) {
                        HStack {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color(hex: "FF6B6B"))
                        .cornerRadius(12)
                    }
                } else {
                    Button(action: {
                        earnedStars += 1
                        withAnimation { showLearningCards = true }
                    }) {
                        HStack {
                            Text("Learning Cards")
                            Image(systemName: "rectangle.stack.fill")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
        .onAppear { glowAnimation = true }
    }

    private var learningCardsView: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("📚 What Did You Learn?")
                    .font(.title2.bold())
                    .foregroundColor(Color(hex: "FF6B6B"))

                Text(story.moralLesson)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)

                ForEach(story.learningCards) { card in
                    DuaLearningCardView(card: card, earnedStars: $earnedStars)
                }
            }
            .padding()
        }
    }
}

// MARK: - Learning Card View

struct DuaLearningCardView: View {
    let card: DuaLearningCard
    @Binding var earnedStars: Int
    @State private var selectedAnswer: Int?
    @State private var showResult = false

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(card.emoji)
                    .font(.title2)
                Text(card.question)
                    .font(.subheadline.bold())
            }

            ForEach(card.options.indices, id: \.self) { index in
                Button(action: {
                    if !showResult {
                        selectedAnswer = index
                        showResult = true
                        if index == card.correctAnswer {
                            earnedStars += 1
                        }
                    }
                }) {
                    HStack {
                        Text(card.options[index])
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        Spacer()
                        if showResult && index == card.correctAnswer {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else if showResult && index == selectedAnswer && index != card.correctAnswer {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(
                        showResult && index == card.correctAnswer ? Color.green.opacity(0.1) :
                        showResult && index == selectedAnswer ? Color.red.opacity(0.1) :
                        Color(.secondarySystemGroupedBackground)
                    )
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(showResult)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        .padding(.horizontal)
    }
}

// MARK: - Quiz Game View

struct DuaQuizGameView: View {
    @Binding var earnedStars: Int
    @Environment(\.dismiss) var dismiss
    @State private var currentQuestion = 0
    @State private var selectedAnswer: Int?
    @State private var showExplanation = false
    @State private var correctCount = 0

    private let quizzes = DuaKidsData.quizzes

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if currentQuestion < quizzes.count {
                    // Progress
                    SwiftUI.ProgressView(value: Double(currentQuestion), total: Double(quizzes.count))
                        .tint(Color(hex: "FF6B6B"))
                        .padding(.horizontal)

                    Text("Question \(currentQuestion + 1) of \(quizzes.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    let quiz = quizzes[currentQuestion]

                    Text(quiz.question)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .padding()

                    ForEach(quiz.options.indices, id: \.self) { index in
                        Button(action: {
                            if !showExplanation {
                                selectedAnswer = index
                                showExplanation = true
                                if index == quiz.correctAnswer {
                                    correctCount += 1
                                    earnedStars += 1
                                }
                            }
                        }) {
                            HStack {
                                Text(quiz.options[index])
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Spacer()
                                if showExplanation && index == quiz.correctAnswer {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else if showExplanation && index == selectedAnswer && index != quiz.correctAnswer {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(
                                showExplanation && index == quiz.correctAnswer ? Color.green.opacity(0.1) :
                                showExplanation && index == selectedAnswer ? Color.red.opacity(0.1) :
                                Color(.secondarySystemGroupedBackground)
                            )
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(showExplanation)
                        .padding(.horizontal)
                    }

                    if showExplanation {
                        Text(quiz.explanation)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(Color.blue.opacity(0.05))
                            .cornerRadius(10)
                            .padding(.horizontal)

                        Button(action: {
                            selectedAnswer = nil
                            showExplanation = false
                            currentQuestion += 1
                        }) {
                            Text("Next Question ➡️")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "FF6B6B"))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    // Results
                    VStack(spacing: 16) {
                        Text("🎉")
                            .font(.system(size: 60))
                        Text("Quiz Complete!")
                            .font(.title.bold())
                        Text("You got \(correctCount) out of \(quizzes.count) correct!")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("⭐ +\(correctCount) Stars")
                            .font(.title2.bold())
                            .foregroundColor(.yellow)

                        Button(action: { dismiss() }) {
                            Text("Done")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .navigationTitle("Dua Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Mini-Game View

struct DuaMiniGameView: View {
    let gameType: DuaMiniGameType
    @Binding var earnedStars: Int
    @Environment(\.dismiss) var dismiss
    @State private var score = 0
    @State private var matchedPairs = Set<String>()
    @State private var selectedDua: String?
    @State private var wordTiles: [String] = []
    @State private var selectedTiles: [String] = []
    @State private var situationIndex = 0
    @State private var showResult = false

    // Dua Match data
    private let duaSituations: [(dua: String, situation: String, emoji: String)] = [
        ("Astaghfirullah", "After making a mistake", "😔"),
        ("SubhanAllah", "Seeing something amazing", "🦋"),
        ("Alhamdulillah", "Receiving a blessing", "🎁"),
        ("Allahu Akbar", "Feeling scared or worried", "💪"),
        ("Ayatul Kursi", "For protection after prayer", "🛡️"),
        ("Allahumma Antas-Salam", "Seeking inner peace", "☮️")
    ]

    // Situation Picker data
    private let situations: [(scenario: String, correctDua: String, options: [String], emoji: String)] = [
        ("You just finished praying. What do you say first?", "Astaghfirullah", ["SubhanAllah", "Astaghfirullah", "Bismillah"], "🕌"),
        ("You see a beautiful rainbow. What do you say?", "SubhanAllah", ["Astaghfirullah", "SubhanAllah", "Allahu Akbar"], "🌈"),
        ("You passed your test! What do you say?", "Alhamdulillah", ["Alhamdulillah", "Astaghfirullah", "La ilaha illallah"], "📝"),
        ("You feel nervous before a big event. What helps?", "Allahu Akbar", ["SubhanAllah", "Alhamdulillah", "Allahu Akbar"], "😰"),
        ("You want protection before sleeping. What do you recite?", "Ayatul Kursi", ["SubhanAllah", "Ayatul Kursi", "Astaghfirullah"], "🌙")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text(gameType.emoji)
                        .font(.system(size: 50))

                    Text(gameType.rawValue)
                        .font(.title2.bold())
                        .foregroundColor(Color(hex: "FF6B6B"))

                    Text("Score: \(score) ⭐")
                        .font(.headline)
                        .foregroundColor(.yellow)

                    switch gameType {
                    case .duaMatch:
                        duaMatchGame
                    case .wordComplete:
                        wordCompleteGame
                    case .situationPicker:
                        situationPickerGame
                    }
                }
                .padding()
            }
            .navigationTitle(gameType.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        earnedStars += score
                        dismiss()
                    }
                }
            }
            .onAppear {
                if wordTiles.isEmpty {
                    wordTiles = Self.correctWordOrder.shuffled()
                }
            }
        }
    }

    // MARK: - Dua Match Game

    private var duaMatchGame: some View {
        VStack(spacing: 12) {
            Text("Match each dua to its situation!")
                .font(.subheadline)
                .foregroundColor(.secondary)

            ForEach(duaSituations, id: \.dua) { item in
                let isMatched = matchedPairs.contains(item.dua)

                HStack {
                    // Dua button
                    Button(action: {
                        if !isMatched { selectedDua = item.dua }
                    }) {
                        Text(item.dua)
                            .font(.caption.bold())
                            .foregroundColor(selectedDua == item.dua ? .white : .primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                isMatched ? Color.green.opacity(0.3) :
                                selectedDua == item.dua ? Color(hex: "FF6B6B") :
                                Color(.secondarySystemGroupedBackground)
                            )
                            .cornerRadius(8)
                    }
                    .disabled(isMatched)

                    Spacer()

                    // Situation button
                    Button(action: {
                        if selectedDua == item.dua && !isMatched {
                            matchedPairs.insert(item.dua)
                            selectedDua = nil
                            score += 1
                        } else if selectedDua != nil {
                            selectedDua = nil
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(item.emoji)
                            Text(item.situation)
                                .font(.caption)
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            isMatched ? Color.green.opacity(0.3) :
                            Color(.secondarySystemGroupedBackground)
                        )
                        .cornerRadius(8)
                    }
                    .disabled(isMatched)
                }
            }

            if matchedPairs.count == duaSituations.count {
                Text("🎉 All matched! Great job!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
            }
        }
    }

    // MARK: - Word Complete Game

    private static let correctWordOrder = ["SubhanAllah", "Alhamdulillah", "Allahu", "Akbar"]

    private var wordCompleteGame: some View {
        VStack(spacing: 16) {
            Text("Build the dua word by word!")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Arrange these words in the correct dhikr order:")
                .font(.caption)
                .foregroundColor(.secondary)

            // Selected tiles
            HStack(spacing: 8) {
                ForEach(selectedTiles, id: \.self) { tile in
                    Button(action: {
                        selectedTiles.removeAll { $0 == tile }
                    }) {
                        Text(tile)
                            .font(.subheadline.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(hex: "FF6B6B"))
                            .cornerRadius(8)
                    }
                }
            }
            .frame(minHeight: 44)
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)

            // Available tiles
            HStack(spacing: 8) {
                ForEach(wordTiles, id: \.self) { word in
                    if !selectedTiles.contains(word) {
                        Button(action: {
                            selectedTiles.append(word)
                            if selectedTiles.count == Self.correctWordOrder.count {
                                if selectedTiles == Self.correctWordOrder {
                                    score += 3
                                    showResult = true
                                }
                            }
                        }) {
                            Text(word)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.tertiarySystemGroupedBackground))
                                .cornerRadius(8)
                        }
                    }
                }
            }

            if showResult {
                Text("✅ Correct! That's the order of dhikr after prayer!")
                    .font(.subheadline)
                    .foregroundColor(.green)
            } else if selectedTiles.count == Self.correctWordOrder.count && selectedTiles != Self.correctWordOrder {
                VStack(spacing: 8) {
                    Text("❌ Not quite! Try again.")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    Button("Reset") {
                        selectedTiles = []
                        wordTiles = Self.correctWordOrder.shuffled()
                    }
                    .font(.caption)
                }
            }
        }
    }

    // MARK: - Situation Picker Game

    private var situationPickerGame: some View {
        VStack(spacing: 16) {
            if situationIndex < situations.count {
                let situation = situations[situationIndex]

                Text(situation.emoji)
                    .font(.system(size: 50))

                Text(situation.scenario)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                ForEach(situation.options, id: \.self) { option in
                    Button(action: {
                        if option == situation.correctDua {
                            score += 1
                            situationIndex += 1
                        }
                    }) {
                        Text(option)
                            .font(.body)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            } else {
                VStack(spacing: 12) {
                    Text("🎉")
                        .font(.system(size: 50))
                    Text("All situations complete!")
                        .font(.headline)
                    Text("Score: \(score)/\(situations.count) ⭐")
                        .font(.title2.bold())
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Dua Kids View") {
    DuaKidsView(isKidsMode: true)
        .environmentObject(AppState())
}
