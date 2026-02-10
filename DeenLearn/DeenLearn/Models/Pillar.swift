//
//  Pillar.swift
//  DeenLearn
//
//  Data models for the 5 Pillars of Islam
//

import SwiftUI

// MARK: - Pillar Model

struct Pillar: Identifiable {
    let id: String
    let number: Int
    let name: String
    let nameArabic: String
    let icon: String
    let color: Color
    let worldEmoji: String
    let description: String
    
    // Kids content
    let storyEpisodes: [StoryEpisode]
    let miniGames: [MiniGame]
    
    // Adults content
    let definition: String
    let quranEvidence: [Evidence]
    let hadithEvidence: [Evidence]
    let wisdom: String
    let practicalApplication: String
    let scenarios: [Scenario]
    let fiqhDifferences: [FiqhDifference]
    
    // Kids hadith content
    let kidsHadiths: [KidsHadith]
}

// MARK: - Story Episode (Kids)

struct StoryEpisode: Identifiable {
    let id: String
    let title: String
    let narrator: String
    let content: String
    let emoji: String
    let duration: Int // in minutes
}

// MARK: - Mini Game (Kids)

struct MiniGame: Identifiable {
    let id: String
    let title: String
    let type: MiniGameType
    let description: String
    let icon: String
}

enum MiniGameType {
    case matchPillarMeaning
    case fixBrokenPillar
    case orderThePillars
    case quizTime
}

// MARK: - Evidence (Adults)

struct Evidence: Identifiable {
    let id: String
    let arabic: String
    let translation: String
    let reference: String
}

// MARK: - Scenario (Adults)

struct Scenario: Identifiable {
    let id: String
    let question: String
    let answer: String
    let category: String
}

// MARK: - Fiqh Difference (Adults)

struct FiqhDifference: Identifiable {
    let id: String
    let topic: String
    let hanafi: String
    let maliki: String
    let shafii: String
    let hanbali: String
}

// MARK: - Kids Hadith

struct KidsHadith: Identifiable {
    let id: String
    let emoji: String
    let title: String
    let arabicText: String
    let simpleMeaning: String
    let funFact: String
    let collection: String      // e.g., "bukhari"
    let hadithNumber: Int       // API hadith number for enrichment
    let reference: String       // e.g., "Sahih al-Bukhari, Hadith 13"
}

// MARK: - Sample Data

extension Pillar {
    static let allPillars: [Pillar] = [
        // 1. Shahada
        Pillar(
            id: "shahada",
            number: 1,
            name: "Shahada",
            nameArabic: "الشهادة",
            icon: "heart.text.square.fill",
            color: Color(hex: "E74C3C"),
            worldEmoji: "❤️",
            description: "Declaration of Faith",
            storyEpisodes: [
                StoryEpisode(
                    id: "shahada-story-1",
                    title: "The Special Words",
                    narrator: "Grandma Fatima",
                    content: "Once upon a time, there was a little boy named Yusuf who asked his grandmother, 'What are the most important words in the world?' Grandma smiled and said, 'La ilaha illallah, Muhammadur Rasulullah - There is no god but Allah, and Muhammad is His messenger.' These words are so special that when you say them with your heart, you become part of a big, beautiful family of Muslims all around the world!",
                    emoji: "💫",
                    duration: 3
                ),
                StoryEpisode(
                    id: "shahada-story-2",
                    title: "Bilal's Brave Heart",
                    narrator: "Uncle Ahmad",
                    content: "Long ago, there was a man named Bilal who loved Allah so much. Even when people were mean to him, he kept saying 'Ahad! Ahad!' which means 'One! One!' - reminding everyone that Allah is One. His faith was so strong that he became the first person to call people to prayer. His beautiful voice would echo through Madinah!",
                    emoji: "🌟",
                    duration: 4
                )
            ],
            miniGames: [
                MiniGame(id: "shahada-game-1", title: "Complete the Shahada", type: .matchPillarMeaning, description: "Match the Arabic words with their meanings", icon: "puzzlepiece.fill"),
                MiniGame(id: "shahada-game-2", title: "Shahada Builder", type: .fixBrokenPillar, description: "Put the words of Shahada in the correct order", icon: "building.2.fill")
            ],
            definition: "The Shahada is the Islamic declaration of faith and the first of the Five Pillars of Islam. It consists of two parts: the testimony that there is no deity worthy of worship except Allah, and the testimony that Muhammad ﷺ is the Messenger of Allah.",
            quranEvidence: [
                Evidence(id: "shahada-quran-1", arabic: "فَاعْلَمْ أَنَّهُ لَا إِلَٰهَ إِلَّا اللَّهُ", translation: "So know that there is no deity except Allah", reference: "Quran 47:19"),
                Evidence(id: "shahada-quran-2", arabic: "مُحَمَّدٌ رَسُولُ اللَّهِ", translation: "Muhammad is the Messenger of Allah", reference: "Quran 48:29")
            ],
            hadithEvidence: [
                Evidence(id: "shahada-hadith-1", arabic: "بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ", translation: "Islam is built upon five pillars: testifying that there is no god but Allah and that Muhammad is the Messenger of Allah...", reference: "Bukhari & Muslim")
            ],
            wisdom: "The Shahada is not merely a verbal statement but a commitment that shapes one's entire worldview. It affirms the oneness of Allah (Tawhid) and acknowledges the prophethood of Muhammad ﷺ, establishing the foundation for all Islamic beliefs and practices.",
            practicalApplication: "Recite the Shahada with conviction daily. Reflect on its meaning during prayer. Live by its implications: worship Allah alone and follow the Sunnah of the Prophet ﷺ.",
            scenarios: [
                Scenario(id: "shahada-scenario-1", question: "Someone asks you 'What makes someone a Muslim?'", answer: "A person becomes a Muslim by sincerely declaring the Shahada, believing in its meaning, and committing to live by its implications.", category: "Basics"),
                Scenario(id: "shahada-scenario-2", question: "How should new Muslims approach learning after taking Shahada?", answer: "Start with the basics: learning to pray, understanding the pillars of faith, and gradually building knowledge. The community should support and guide them patiently.", category: "New Muslims")
            ],
            fiqhDifferences: [
                FiqhDifference(id: "shahada-fiqh-1", topic: "Conditions of Valid Shahada", hanafi: "Knowledge, certainty, sincerity, truthfulness, love, submission, acceptance", maliki: "Same conditions with emphasis on acting upon it", shafii: "Same conditions with specific rulings on pronunciation", hanbali: "Same conditions with emphasis on negating shirk completely")
            ],
            kidsHadiths: [
                KidsHadith(
                    id: "shahada-kids-hadith-1",
                    emoji: "🏗️",
                    title: "The Five Pillars",
                    arabicText: "بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ",
                    simpleMeaning: "Islam is built on five things — like a house needs five strong walls! The Shahada is the very first one.",
                    funFact: "Every Muslim around the world says the same Shahada — that's billions of people! 🌍",
                    collection: "bukhari",
                    hadithNumber: 8,
                    reference: "Sahih al-Bukhari, Hadith 8"
                ),
                KidsHadith(
                    id: "shahada-kids-hadith-2",
                    emoji: "💝",
                    title: "Love for Others",
                    arabicText: "لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ",
                    simpleMeaning: "You're not a true believer until you want good things for others just like you want for yourself!",
                    funFact: "Imagine if everyone followed this — the whole world would be so kind! 🤗",
                    collection: "bukhari",
                    hadithNumber: 13,
                    reference: "Sahih al-Bukhari, Hadith 13"
                )
            ]
        ),
        
        // 2. Salah
        Pillar(
            id: "salah",
            number: 2,
            name: "Salah",
            nameArabic: "الصلاة",
            icon: "person.fill",
            color: Color(hex: "27AE60"),
            worldEmoji: "🕌",
            description: "Five Daily Prayers",
            storyEpisodes: [
                StoryEpisode(
                    id: "salah-story-1",
                    title: "The Gift from Heaven",
                    narrator: "Grandpa Ibrahim",
                    content: "Did you know that Salah is a special gift? When Prophet Muhammad ﷺ traveled to the heavens on a miraculous night journey, Allah gave him this beautiful gift of prayer. At first it was 50 prayers, but through Prophet Musa's advice, it became 5 prayers with the reward of 50! Isn't that amazing?",
                    emoji: "🌙",
                    duration: 4
                ),
                StoryEpisode(
                    id: "salah-story-2",
                    title: "Little Amina's First Prayer",
                    narrator: "Mama Aisha",
                    content: "Little Amina watched her family pray every day. One day, she put on her tiny prayer dress and stood next to her mother. 'Allahu Akbar!' she said, feeling so grown up. Her heart felt warm and happy talking to Allah. From that day, Amina loved to pray, knowing Allah was always listening!",
                    emoji: "👧",
                    duration: 3
                )
            ],
            miniGames: [
                MiniGame(id: "salah-game-1", title: "Prayer Time Match", type: .matchPillarMeaning, description: "Match each prayer with its time", icon: "clock.fill"),
                MiniGame(id: "salah-game-2", title: "Build the Prayer", type: .fixBrokenPillar, description: "Put the prayer actions in order", icon: "figure.stand"),
                MiniGame(id: "salah-game-3", title: "Prayer Quiz", type: .quizTime, description: "Test your Salah knowledge", icon: "questionmark.circle.fill")
            ],
            definition: "Salah is the second pillar of Islam and refers to the five obligatory daily prayers. It is a direct connection between the worshipper and Allah, performed at specific times throughout the day.",
            quranEvidence: [
                Evidence(id: "salah-quran-1", arabic: "إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ", translation: "Indeed, prayer prohibits immorality and wrongdoing", reference: "Quran 29:45"),
                Evidence(id: "salah-quran-2", arabic: "أَقِمِ الصَّلَاةَ لِذِكْرِي", translation: "Establish prayer for My remembrance", reference: "Quran 20:14")
            ],
            hadithEvidence: [
                Evidence(id: "salah-hadith-1", arabic: "الصَّلاَةُ عِمَادُ الدِّينِ", translation: "Prayer is the pillar of the religion", reference: "Bayhaqi"),
                Evidence(id: "salah-hadith-2", arabic: "أَوَّلُ مَا يُحَاسَبُ بِهِ الْعَبْدُ يَوْمَ الْقِيَامَةِ الصَّلاَةُ", translation: "The first thing a person will be held accountable for on the Day of Judgment is prayer", reference: "Tirmidhi")
            ],
            wisdom: "Salah structures the Muslim's day around remembrance of Allah, creating regular intervals of spiritual connection. It teaches discipline, humility before the Creator, and reminds us of our purpose in life.",
            practicalApplication: "Pray all five daily prayers on time. Learn the meanings of what you recite. Strive for khushu (concentration). Use prayer times as anchors for your daily schedule.",
            scenarios: [
                Scenario(id: "salah-scenario-1", question: "What if I miss a prayer due to sleep or forgetfulness?", answer: "Make it up as soon as you remember. The Prophet ﷺ said: 'Whoever forgets a prayer, let him pray it when he remembers it.' There is no expiation except to perform it.", category: "Missed Prayer"),
                Scenario(id: "salah-scenario-2", question: "Can I combine prayers when traveling?", answer: "Yes, travelers may combine Dhuhr with Asr, and Maghrib with Isha. They may also shorten 4-rak'ah prayers to 2. The travel distance that permits this varies by madhab.", category: "Travel")
            ],
            fiqhDifferences: [
                FiqhDifference(id: "salah-fiqh-1", topic: "Raising Hands (Rafa' al-Yadayn)", hanafi: "Only at the opening takbeer", maliki: "Only at the opening takbeer", shafii: "At opening, before ruku', rising from ruku'", hanbali: "At opening, before ruku', rising from ruku'"),
                FiqhDifference(id: "salah-fiqh-2", topic: "Witr Prayer", hanafi: "3 rak'ahs obligatory (wajib)", maliki: "1 rak'ah, strongly recommended", shafii: "1-11 rak'ahs, sunnah mu'akkadah", hanbali: "1-11 rak'ahs, sunnah mu'akkadah")
            ],
            kidsHadiths: [
                KidsHadith(
                    id: "salah-kids-hadith-1",
                    emoji: "🌊",
                    title: "Prayer Cleans Your Heart",
                    arabicText: "أَرَأَيْتُمْ لَوْ أَنَّ نَهْرًا بِبَابِ أَحَدِكُمْ يَغْتَسِلُ مِنْهُ كُلَّ يَوْمٍ خَمْسَ مَرَّاتٍ",
                    simpleMeaning: "The Prophet ﷺ said: If you had a river at your door and bathed in it 5 times daily, would you be dirty? That's what the 5 prayers do for your heart!",
                    funFact: "That means every prayer washes away mistakes — like a spiritual shower! 🚿",
                    collection: "bukhari",
                    hadithNumber: 528,
                    reference: "Sahih al-Bukhari, Hadith 528"
                ),
                KidsHadith(
                    id: "salah-kids-hadith-2",
                    emoji: "🗝️",
                    title: "The Key to Paradise",
                    arabicText: "مِفْتَاحُ الْجَنَّةِ الصَّلاَةُ",
                    simpleMeaning: "The key to Paradise is prayer! Every time you pray, you're turning the key a little more.",
                    funFact: "Imagine holding a golden key — that's what every prayer is like! ✨",
                    collection: "tirmidhi",
                    hadithNumber: 4,
                    reference: "Jami' at-Tirmidhi, Hadith 4"
                )
            ]
        ),
        
        // 3. Zakat
        Pillar(
            id: "zakat",
            number: 3,
            name: "Zakat",
            nameArabic: "الزكاة",
            icon: "heart.fill",
            color: Color(hex: "F39C12"),
            worldEmoji: "💰",
            description: "Charitable Giving",
            storyEpisodes: [
                StoryEpisode(
                    id: "zakat-story-1",
                    title: "The Sharing Garden",
                    narrator: "Aunt Khadijah",
                    content: "Imagine you have a beautiful garden with 100 apples. Allah asks you to share just 2 or 3 apples with those who don't have any. That's what Zakat is! When we share, our garden grows even more beautiful, and everyone is happy. The more we give, the more Allah gives us!",
                    emoji: "🍎",
                    duration: 3
                ),
                StoryEpisode(
                    id: "zakat-story-2",
                    title: "The Generous Merchant",
                    narrator: "Uncle Omar",
                    content: "There was once a merchant named Abdul-Rahman who always gave his Zakat happily. One year, there was no rain and crops failed. But Abdul-Rahman had given so much Zakat that when he needed help, everyone wanted to help him back. 'Give,' he would say, 'and Allah will give you more!'",
                    emoji: "🤝",
                    duration: 4
                )
            ],
            miniGames: [
                MiniGame(id: "zakat-game-1", title: "Zakat Calculator Junior", type: .quizTime, description: "Learn how to calculate Zakat", icon: "percent"),
                MiniGame(id: "zakat-game-2", title: "Who Deserves Zakat?", type: .matchPillarMeaning, description: "Match people who can receive Zakat", icon: "person.3.fill")
            ],
            definition: "Zakat is the obligatory annual charity that every Muslim who meets the nisab (minimum wealth threshold) must pay. It is 2.5% of one's accumulated wealth and is distributed to eight categories of recipients mentioned in the Quran.",
            quranEvidence: [
                Evidence(id: "zakat-quran-1", arabic: "وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ", translation: "And establish prayer and give Zakat", reference: "Quran 2:43"),
                Evidence(id: "zakat-quran-2", arabic: "إِنَّمَا الصَّدَقَاتُ لِلْفُقَرَاءِ وَالْمَسَاكِينِ", translation: "Zakah expenditures are only for the poor and for the needy...", reference: "Quran 9:60")
            ],
            hadithEvidence: [
                Evidence(id: "zakat-hadith-1", arabic: "مَا نَقَصَتْ صَدَقَةٌ مِنْ مَالٍ", translation: "Charity does not decrease wealth", reference: "Muslim")
            ],
            wisdom: "Zakat purifies wealth and the soul from greed. It creates a circulation of wealth in society, reducing inequality and fostering brotherhood. It reminds us that all wealth ultimately belongs to Allah.",
            practicalApplication: "Calculate your Zakat annually. Keep records of your wealth. Pay Zakat promptly when due. Research trustworthy organizations or give directly to eligible recipients.",
            scenarios: [
                Scenario(id: "zakat-scenario-1", question: "How do I calculate Zakat on savings?", answer: "Calculate 2.5% of savings that have been held for one lunar year and exceed the nisab (approximately 85g of gold or 595g of silver in value). Include cash, gold, silver, investments, and business inventory.", category: "Calculation"),
                Scenario(id: "zakat-scenario-2", question: "Can I give Zakat to my relatives?", answer: "You can give Zakat to relatives who are eligible recipients, except those you are obligated to support (parents, children, spouse). Giving to relatives may earn double reward - for charity and maintaining family ties.", category: "Recipients")
            ],
            fiqhDifferences: [
                FiqhDifference(id: "zakat-fiqh-1", topic: "Nisab Calculation", hanafi: "Based on silver value (more inclusive)", maliki: "Based on gold value", shafii: "Based on gold value", hanbali: "Based on gold value"),
                FiqhDifference(id: "zakat-fiqh-2", topic: "Zakat on Jewelry", hanafi: "Zakat due on gold/silver jewelry", maliki: "No Zakat on personal jewelry", shafii: "No Zakat on personal jewelry", hanbali: "Zakat due on gold/silver jewelry")
            ],
            kidsHadiths: [
                KidsHadith(
                    id: "zakat-kids-hadith-1",
                    emoji: "🌱",
                    title: "Charity Makes Wealth Grow",
                    arabicText: "مَا نَقَصَتْ صَدَقَةٌ مِنْ مَالٍ",
                    simpleMeaning: "Giving charity never makes your money less — it actually makes it grow! Like planting a seed that becomes a big tree.",
                    funFact: "When you share your toys, Allah replaces them with even better blessings! 🎁",
                    collection: "muslim",
                    hadithNumber: 2588,
                    reference: "Sahih Muslim, Hadith 2588"
                ),
                KidsHadith(
                    id: "zakat-kids-hadith-2",
                    emoji: "😊",
                    title: "A Smile is Charity",
                    arabicText: "تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ",
                    simpleMeaning: "Even smiling at someone is charity! You don't need money to be generous — your smile counts too!",
                    funFact: "You have unlimited smiles to give — the easiest charity ever! 😁",
                    collection: "tirmidhi",
                    hadithNumber: 1956,
                    reference: "Jami' at-Tirmidhi, Hadith 1956"
                )
            ]
        ),
        
        // 4. Sawm (Fasting)
        Pillar(
            id: "sawm",
            number: 4,
            name: "Sawm",
            nameArabic: "الصوم",
            icon: "moon.stars.fill",
            color: Color(hex: "9B59B6"),
            worldEmoji: "🌙",
            description: "Fasting in Ramadan",
            storyEpisodes: [
                StoryEpisode(
                    id: "sawm-story-1",
                    title: "The Month of Blessings",
                    narrator: "Grandma Maryam",
                    content: "Every year, there's a special month called Ramadan when Muslims don't eat or drink from sunrise to sunset. 'But why?' asked little Hassan. 'To remember those who are hungry, to grow closer to Allah, and to be the best version of ourselves!' answered Grandma. 'And at the end, we have a big celebration called Eid!'",
                    emoji: "🎉",
                    duration: 3
                ),
                StoryEpisode(
                    id: "sawm-story-2",
                    title: "Suhoor & Iftar Fun",
                    narrator: "Baba",
                    content: "Ahmed woke up while it was still dark. 'Time for suhoor!' whispered Baba. They ate dates and drank water together before Fajr. All day, Ahmed played and helped mama. When the sun finally set, the whole family gathered for iftar. 'Allahu Akbar!' they said, and broke their fast with sweet dates. Ahmed felt so proud!",
                    emoji: "🌅",
                    duration: 4
                )
            ],
            miniGames: [
                MiniGame(id: "sawm-game-1", title: "Ramadan Daily Routine", type: .orderThePillars, description: "Put the fasting day activities in order", icon: "sunrise.fill"),
                MiniGame(id: "sawm-game-2", title: "What Breaks the Fast?", type: .quizTime, description: "Learn what breaks and doesn't break the fast", icon: "drop.fill")
            ],
            definition: "Sawm is the obligatory fasting during the month of Ramadan, from dawn (Fajr) to sunset (Maghrib). Muslims abstain from food, drink, and marital relations during fasting hours. It is also a time of increased worship, Quran recitation, and good deeds.",
            quranEvidence: [
                Evidence(id: "sawm-quran-1", arabic: "يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ", translation: "O you who believe, fasting is prescribed for you as it was prescribed for those before you", reference: "Quran 2:183"),
                Evidence(id: "sawm-quran-2", arabic: "شَهْرُ رَمَضَانَ الَّذِي أُنزِلَ فِيهِ الْقُرْآنُ", translation: "The month of Ramadan in which was revealed the Quran", reference: "Quran 2:185")
            ],
            hadithEvidence: [
                Evidence(id: "sawm-hadith-1", arabic: "مَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ", translation: "Whoever fasts Ramadan with faith and seeking reward, his previous sins will be forgiven", reference: "Bukhari & Muslim"),
                Evidence(id: "sawm-hadith-2", arabic: "الصِّيَامُ جُنَّةٌ", translation: "Fasting is a shield", reference: "Bukhari")
            ],
            wisdom: "Fasting teaches self-discipline, empathy for the less fortunate, and gratitude for Allah's blessings. It breaks the routine attachment to worldly needs and elevates spiritual consciousness.",
            practicalApplication: "Wake for suhoor (pre-dawn meal). Make intention before Fajr. Increase Quran recitation. Give charity. Avoid negative speech and actions. Break fast with dates and water.",
            scenarios: [
                Scenario(id: "sawm-scenario-1", question: "What if I accidentally eat or drink while fasting?", answer: "If you forget and eat or drink, your fast is still valid. The Prophet ﷺ said: 'If he forgets and eats or drinks, let him complete his fast, for Allah has fed him and given him drink.'", category: "Mistakes"),
                Scenario(id: "sawm-scenario-2", question: "Can I fast if I'm traveling?", answer: "Travelers have the option to not fast during Ramadan and make up the days later. However, if fasting doesn't cause hardship, many scholars consider it better to fast, as the Prophet ﷺ sometimes fasted while traveling.", category: "Travel")
            ],
            fiqhDifferences: [
                FiqhDifference(id: "sawm-fiqh-1", topic: "Using Inhaler While Fasting", hanafi: "Breaks the fast", maliki: "Breaks the fast", shafii: "Breaks the fast", hanbali: "Does not break the fast (some scholars)"),
                FiqhDifference(id: "sawm-fiqh-2", topic: "Brushing Teeth While Fasting", hanafi: "Permissible, but better to use miswak", maliki: "Permissible before noon only", shafii: "Permissible, but makruh after noon", hanbali: "Permissible anytime")
            ],
            kidsHadiths: [
                KidsHadith(
                    id: "sawm-kids-hadith-1",
                    emoji: "🛡️",
                    title: "Fasting is a Shield",
                    arabicText: "الصِّيَامُ جُنَّةٌ",
                    simpleMeaning: "Fasting is like a shield that protects you! Just like a superhero's shield blocks bad things, fasting protects your heart.",
                    funFact: "When you fast, angels cheer you on and write extra rewards! 📝",
                    collection: "bukhari",
                    hadithNumber: 1894,
                    reference: "Sahih al-Bukhari, Hadith 1894"
                ),
                KidsHadith(
                    id: "sawm-kids-hadith-2",
                    emoji: "🚪",
                    title: "The Special Gate of Paradise",
                    arabicText: "إِنَّ فِي الْجَنَّةِ بَابًا يُقَالُ لَهُ الرَّيَّانُ",
                    simpleMeaning: "There's a special gate in Paradise called Ar-Rayyan, and only people who fasted can enter through it! How cool is that?",
                    funFact: "Imagine your own VIP door to Paradise — that's what fasting earns you! 🌟",
                    collection: "bukhari",
                    hadithNumber: 1896,
                    reference: "Sahih al-Bukhari, Hadith 1896"
                )
            ]
        ),
        
        // 5. Hajj
        Pillar(
            id: "hajj",
            number: 5,
            name: "Hajj",
            nameArabic: "الحج",
            icon: "cube.fill",
            color: Color(hex: "3498DB"),
            worldEmoji: "🕋",
            description: "Pilgrimage to Makkah",
            storyEpisodes: [
                StoryEpisode(
                    id: "hajj-story-1",
                    title: "The Journey of a Lifetime",
                    narrator: "Grandfather Khalid",
                    content: "Imagine millions of people, all wearing simple white clothes, all walking together, all saying 'Labbayk Allahumma Labbayk!' - 'Here I am, O Allah, here I am!' They walk around the Kaaba, the house that Prophet Ibrahim built for Allah. Everyone is equal - rich and poor, kings and farmers - all worshipping Allah together!",
                    emoji: "🕋",
                    duration: 4
                ),
                StoryEpisode(
                    id: "hajj-story-2",
                    title: "The Story of Hajar and Zamzam",
                    narrator: "Mama Zahra",
                    content: "Long ago, Hajar and baby Ismail were alone in the desert. Baby Ismail was thirsty, and there was no water anywhere! Hajar ran between two hills, Safa and Marwa, seven times, looking for help. Allah saw her faith and made a spring burst from the ground - the blessed Zamzam water! Today, pilgrims walk between these same hills to remember her faith.",
                    emoji: "💧",
                    duration: 5
                )
            ],
            miniGames: [
                MiniGame(id: "hajj-game-1", title: "Hajj Journey Map", type: .orderThePillars, description: "Put the Hajj rituals in order", icon: "map.fill"),
                MiniGame(id: "hajj-game-2", title: "Pack for Hajj", type: .matchPillarMeaning, description: "Match what to bring and not bring", icon: "suitcase.fill")
            ],
            definition: "Hajj is the annual pilgrimage to Makkah that every Muslim must perform at least once in their lifetime if they are physically and financially able. It takes place during the month of Dhul Hijjah and includes specific rituals at sacred sites.",
            quranEvidence: [
                Evidence(id: "hajj-quran-1", arabic: "وَلِلَّهِ عَلَى النَّاسِ حِجُّ الْبَيْتِ مَنِ اسْتَطَاعَ إِلَيْهِ سَبِيلًا", translation: "And pilgrimage to the House is a duty owed to Allah by all people who are able to undertake it", reference: "Quran 3:97"),
                Evidence(id: "hajj-quran-2", arabic: "الْحَجُّ أَشْهُرٌ مَّعْلُومَاتٌ", translation: "Hajj is during well-known months", reference: "Quran 2:197")
            ],
            hadithEvidence: [
                Evidence(id: "hajj-hadith-1", arabic: "مَنْ حَجَّ لِلَّهِ فَلَمْ يَرْفُثْ وَلَمْ يَفْسُقْ رَجَعَ كَيَوْمَ وَلَدَتْهُ أُمُّهُ", translation: "Whoever performs Hajj for Allah and does not commit any obscenity or transgression will return [free from sins] as on the day his mother bore him", reference: "Bukhari & Muslim"),
                Evidence(id: "hajj-hadith-2", arabic: "الْحَجُّ الْمَبْرُورُ لَيْسَ لَهُ جَزَاءٌ إِلاَّ الْجَنَّةُ", translation: "An accepted Hajj has no reward except Paradise", reference: "Bukhari & Muslim")
            ],
            wisdom: "Hajj is a profound spiritual journey that symbolizes unity, equality, and submission to Allah. It commemorates the legacy of Prophet Ibrahim, his family, and reinforces the global Muslim brotherhood.",
            practicalApplication: "Save and plan for Hajj. Learn the rituals beforehand. Prepare spiritually through increased worship. Ensure all debts are settled. Make sincere tawbah (repentance). Enter ihram with pure intentions.",
            scenarios: [
                Scenario(id: "hajj-scenario-1", question: "Is Hajj obligatory even with family responsibilities?", answer: "Hajj becomes obligatory when one has the physical health and financial means, including being able to provide for dependents during absence. If these conditions aren't met, Hajj is not obligatory until they are.", category: "Obligation"),
                Scenario(id: "hajj-scenario-2", question: "Can someone perform Hajj on behalf of another?", answer: "Yes, Hajj can be performed on behalf of someone who has passed away, or for someone who is permanently unable to perform it due to old age or chronic illness, provided the person performing it has already completed their own obligatory Hajj.", category: "Proxy")
            ],
            fiqhDifferences: [
                FiqhDifference(id: "hajj-fiqh-1", topic: "Women Traveling for Hajj", hanafi: "Requires mahram for any distance", maliki: "Can travel with trustworthy group", shafii: "Can travel with trustworthy women", hanbali: "Requires mahram for any distance"),
                FiqhDifference(id: "hajj-fiqh-2", topic: "Shaving vs. Trimming Hair", hanafi: "Shaving preferred for men", maliki: "Shaving preferred for men", shafii: "Shaving preferred for men", hanbali: "Shaving preferred for men")
            ],
            kidsHadiths: [
                KidsHadith(
                    id: "hajj-kids-hadith-1",
                    emoji: "✨",
                    title: "Hajj Erases All Sins",
                    arabicText: "مَنْ حَجَّ فَلَمْ يَرْفُثْ وَلَمْ يَفْسُقْ رَجَعَ كَيَوْمِ وَلَدَتْهُ أُمُّهُ",
                    simpleMeaning: "Whoever does Hajj properly comes back as clean as the day they were born! Like hitting a reset button on all your mistakes.",
                    funFact: "Imagine being as pure as a newborn baby — that's the power of Hajj! 👶",
                    collection: "bukhari",
                    hadithNumber: 1521,
                    reference: "Sahih al-Bukhari, Hadith 1521"
                ),
                KidsHadith(
                    id: "hajj-kids-hadith-2",
                    emoji: "🤝",
                    title: "Everyone is Equal",
                    arabicText: "لاَ فَضْلَ لِعَرَبِيٍّ عَلَى أَعْجَمِيٍّ",
                    simpleMeaning: "No one is better than anyone else because of where they come from — only by being good! At Hajj, everyone wears the same clothes to show this.",
                    funFact: "During Hajj, even kings and presidents wear the same simple white clothes as everyone else! 👑➡️🤍",
                    collection: "ahmad",
                    hadithNumber: 23536,
                    reference: "Musnad Ahmad, Hadith 23536"
                )
            ]
        )
    ]
}
