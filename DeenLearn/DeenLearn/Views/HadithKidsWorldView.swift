//
//  HadithKidsWorldView.swift
//  DeenLearn
//
//  Hadith Stories World - Kids Mode
//

import SwiftUI

// MARK: - Data Models

enum HadithMiniGameType: String, CaseIterable {
    case intentionGlow = "Intention Glow"
    case helpNeighbor = "Help a Neighbor"
    case honestySorting = "Honesty Sorting"
    case prayerPuzzle = "Prayer Puzzle"
    case kindnessCatcher = "Kindness Catcher"

    var emoji: String {
        switch self {
        case .intentionGlow: return "\u{2728}"
        case .helpNeighbor: return "\u{1F91D}"
        case .honestySorting: return "\u{2696}\u{FE0F}"
        case .prayerPuzzle: return "\u{1F9E9}"
        case .kindnessCatcher: return "\u{1F496}"
        }
    }
}

struct StoryPage: Identifiable {
    let id = UUID()
    let text: String
    let emoji: String
    let isHadithGlowMoment: Bool
}

struct LearningCard: Identifiable {
    let id = UUID()
    let question: String
    let emoji: String
    let options: [String]
    let correctAnswer: Int
}

struct KidsHadithStory: Identifiable {
    let id = UUID()
    let hadith: KidsHadith
    let storyTitle: String
    let character: String
    let characterEmoji: String
    let storyPages: [StoryPage]
    let moralLesson: String
    let learningCards: [LearningCard]
}

struct HadithQuiz: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

struct HadithZone: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let color: Color
    let gradient: [Color]
    let description: String
    let hadiths: [KidsHadithStory]
    let quizzes: [HadithQuiz]
    let miniGame: HadithMiniGameType
}

// MARK: - Static Data

struct HadithWorldData {
    static let zones: [HadithZone] = [
        // MARK: Zone 1 - Kindness Valley
        HadithZone(
            name: "Kindness Valley",
            emoji: "💝",
            color: Color(hex: "FF69B4"),
            gradient: [Color(hex: "FFB6C1"), Color(hex: "FF69B4")],
            description: "A magical valley where kindness blooms like flowers!",
            hadiths: [
                KidsHadithStory(
                    hadith: KidsHadith(
                        id: "kindness_1",
                        emoji: "\u{2764}\u{FE0F}",
                        title: "Love for Your Brother",
                        arabicText: "\u{0644}\u{0627} \u{064A}\u{0624}\u{0645}\u{0646} \u{0623}\u{062D}\u{062F}\u{0643}\u{0645} \u{062D}\u{062A}\u{0649} \u{064A}\u{062D}\u{0628} \u{0644}\u{0623}\u{062E}\u{064A}\u{0647} \u{0645}\u{0627} \u{064A}\u{062D}\u{0628} \u{0644}\u{0646}\u{0641}\u{0633}\u{0647}",
                        simpleMeaning: "None of you truly believes until he loves for his brother what he loves for himself.",
                        funFact: "This hadith teaches us that real faith means caring about others just like we care about ourselves!",
                        collection: "bukhari",
                        hadithNumber: 13,
                        reference: "Sahih al-Bukhari 13"
                    ),
                    storyTitle: "Sami Shares at the Masjid",
                    character: "Sami",
                    characterEmoji: "\u{1F466}",
                    storyPages: [
                        StoryPage(text: "Sami walked into the masjid carrying his favorite bag of toys. He saw a new boy sitting alone in the corner, looking sad. The boy had just moved to town and didn't know anyone yet.", emoji: "\u{1F3E0}", isHadithGlowMoment: false),
                        StoryPage(text: "Sami's little lantern friend, Noor, whispered: 'Look at that boy, Sami. He looks like he could use a friend!' Sami felt a warm tug in his heart.", emoji: "\u{1F31F}", isHadithGlowMoment: false),
                        StoryPage(text: "Sami sat down next to the boy and said: 'Assalamu Alaikum! I'm Sami. Want to play with my toys?' The boy's eyes lit up with joy. 'Really? You'd share with me?' he asked.", emoji: "\u{1F604}", isHadithGlowMoment: false),
                        StoryPage(text: "As Sami shared his toys with a sincere heart, Noor the lantern began to glow brighter and brighter! The Prophet \u{FDFA} said: 'None of you truly believes until he loves for his brother what he loves for himself.' Sami understood \u{2014} true faith means sharing happiness!", emoji: "\u{2728}", isHadithGlowMoment: true)
                    ],
                    moralLesson: "True faith means wanting good things for others just like you want them for yourself. Sharing with a sincere heart makes everyone happy!",
                    learningCards: [
                        LearningCard(question: "What did Sami do when he saw the new boy?", emoji: "\u{1F914}", options: ["Ignored him", "Shared his toys", "Took his seat", "Left the masjid"], correctAnswer: 1),
                        LearningCard(question: "What happened to Noor when Sami shared?", emoji: "\u{1F4A1}", options: ["Noor turned off", "Noor ran away", "Noor glowed brighter", "Nothing happened"], correctAnswer: 2),
                        LearningCard(question: "What does the hadith teach us?", emoji: "\u{2764}\u{FE0F}", options: ["Keep everything", "Love for others what you love for yourself", "Only share sometimes", "Be selfish"], correctAnswer: 1)
                    ]
                ),
                KidsHadithStory(
                    hadith: KidsHadith(
                        id: "kindness_2",
                        emoji: "\u{1F60A}",
                        title: "A Smile is Charity",
                        arabicText: "\u{062A}\u{0628}\u{0633}\u{0645}\u{0643} \u{0641}\u{064A} \u{0648}\u{062C}\u{0647} \u{0623}\u{062E}\u{064A}\u{0643} \u{0644}\u{0643} \u{0635}\u{062F}\u{0642}\u{0629}",
                        simpleMeaning: "Your smiling in the face of your brother is charity.",
                        funFact: "Did you know that smiling uses fewer muscles than frowning? Allah made it easy for us to do good!",
                        collection: "tirmidhi",
                        hadithNumber: 1956,
                        reference: "Jami' at-Tirmidhi 1956"
                    ),
                    storyTitle: "Amina's Sunshine Smiles",
                    character: "Amina",
                    characterEmoji: "\u{1F467}",
                    storyPages: [
                        StoryPage(text: "Amina woke up feeling wonderful! She decided today would be a 'Smile Day.' She would smile at everyone she met and see what happens.", emoji: "\u{2600}\u{FE0F}", isHadithGlowMoment: false),
                        StoryPage(text: "At school, Amina smiled at her teacher, her classmates, and even the grumpy janitor. Something amazing happened \u{2014} everyone started smiling back! The whole school felt warmer.", emoji: "\u{1F3EB}", isHadithGlowMoment: false),
                        StoryPage(text: "Her friend Layla was having a bad day and almost cried. But when Amina gave her the biggest, warmest smile, Layla couldn't help but smile too. 'Thank you, Amina,' she said. 'I really needed that.'", emoji: "\u{1F917}", isHadithGlowMoment: false),
                        StoryPage(text: "That evening, Amina learned a beautiful hadith: 'Your smiling in the face of your brother is charity.' She realized that every single smile she gave was like giving a gift \u{2014} a sadaqah! And the best part? Smiles are free and never run out!", emoji: "\u{2728}", isHadithGlowMoment: true)
                    ],
                    moralLesson: "A simple smile is an act of charity in Islam. It costs nothing but can brighten someone's entire day!",
                    learningCards: [
                        LearningCard(question: "What did Amina decide to do?", emoji: "\u{1F60A}", options: ["Stay home", "Have a Smile Day", "Be grumpy", "Skip school"], correctAnswer: 1),
                        LearningCard(question: "What is a smile considered in Islam?", emoji: "\u{1F31F}", options: ["Nothing special", "A waste of time", "Charity (sadaqah)", "Only for friends"], correctAnswer: 2),
                        LearningCard(question: "How did Layla feel after Amina smiled?", emoji: "\u{1F496}", options: ["Angry", "Scared", "Better and happier", "Confused"], correctAnswer: 2)
                    ]
                )
            ],
            quizzes: [
                HadithQuiz(question: "What does the Prophet \u{FDFA} say about loving for your brother?", options: ["It doesn't matter", "Love for him what you love for yourself", "Only love family", "Keep things to yourself"], correctAnswer: 1, explanation: "The Prophet taught us that true faith includes wanting good for others!"),
                HadithQuiz(question: "Is smiling at someone an act of charity?", options: ["No, only money is charity", "Yes! A smile is sadaqah", "Only sometimes", "Only in Ramadan"], correctAnswer: 1, explanation: "Every smile you share is counted as charity. SubhanAllah!"),
                HadithQuiz(question: "What is the best way to show kindness?", options: ["Only when people are watching", "With a sincere heart", "Only to rich people", "Never"], correctAnswer: 1, explanation: "Kindness should come from a sincere heart, wanting to please Allah!")
            ],
            miniGame: .intentionGlow
        ),

        // MARK: Zone 2 - Honesty Hills
        HadithZone(
            name: "Honesty Hills",
            emoji: "\u{26F0}\u{FE0F}",
            color: Color(hex: "4682B4"),
            gradient: [Color(hex: "87CEEB"), Color(hex: "4682B4")],
            description: "Climb the hills of truth where honest hearts shine bright!",
            hadiths: [
                KidsHadithStory(
                    hadith: KidsHadith(
                        id: "honesty_1",
                        emoji: "\u{2B50}",
                        title: "Truthfulness Leads to Goodness",
                        arabicText: "\u{0625}\u{0646} \u{0627}\u{0644}\u{0635}\u{062F}\u{0642} \u{064A}\u{0647}\u{062F}\u{064A} \u{0625}\u{0644}\u{0649} \u{0627}\u{0644}\u{0628}\u{0631}",
                        simpleMeaning: "Truthfulness leads to righteousness, and righteousness leads to Paradise.",
                        funFact: "Being honest is like building a road that leads straight to Jannah!",
                        collection: "bukhari",
                        hadithNumber: 6094,
                        reference: "Sahih al-Bukhari 6094"
                    ),
                    storyTitle: "Zayd and the Broken Vase",
                    character: "Zayd",
                    characterEmoji: "\u{1F604}",
                    storyPages: [
                        StoryPage(text: "Zayd was playing ball inside the house when \u{2014} CRASH! \u{2014} he accidentally knocked over Mama's favorite vase. It shattered into pieces on the floor. Oh no!", emoji: "\u{1F625}", isHadithGlowMoment: false),
                        StoryPage(text: "Zayd's heart was pounding. He thought about hiding the pieces or blaming the cat. But something inside him said: 'A Muslim is always honest, even when it's hard.'", emoji: "\u{1F431}", isHadithGlowMoment: false),
                        StoryPage(text: "Zayd took a deep breath and went to his mother. 'Mama, I'm sorry. I broke your vase while playing ball inside. I know I shouldn't have.' Mama hugged him tight.", emoji: "\u{1F917}", isHadithGlowMoment: false),
                        StoryPage(text: "Mama smiled and said: 'Zayd, I'm so proud of you for telling the truth! The Prophet \u{FDFA} said: Truthfulness leads to righteousness, and righteousness leads to Paradise. You chose the path to Jannah today!' Zayd felt a warm glow in his heart.", emoji: "\u{2728}", isHadithGlowMoment: true)
                    ],
                    moralLesson: "Being honest, even when it's scary, is the bravest thing you can do. Truth always leads to goodness!",
                    learningCards: [
                        LearningCard(question: "What did Zayd break?", emoji: "\u{1FAE3}", options: ["A window", "Mama's vase", "His toy", "A plate"], correctAnswer: 1),
                        LearningCard(question: "What did Zayd decide to do?", emoji: "\u{1F4AA}", options: ["Blame the cat", "Hide the pieces", "Tell the truth", "Run away"], correctAnswer: 2),
                        LearningCard(question: "Where does truthfulness lead according to the hadith?", emoji: "\u{1F31F}", options: ["Trouble", "Nowhere", "Righteousness and Paradise", "Sadness"], correctAnswer: 2)
                    ]
                ),
                KidsHadithStory(
                    hadith: KidsHadith(
                        id: "honesty_2",
                        emoji: "\u{1F50D}",
                        title: "Leave What Makes You Doubt",
                        arabicText: "\u{062F}\u{0639} \u{0645}\u{0627} \u{064A}\u{0631}\u{064A}\u{0628}\u{0643} \u{0625}\u{0644}\u{0649} \u{0645}\u{0627} \u{0644}\u{0627} \u{064A}\u{0631}\u{064A}\u{0628}\u{0643}",
                        simpleMeaning: "Leave that which makes you doubt for that which does not make you doubt.",
                        funFact: "Your heart is like a compass \u{2014} it knows the right direction if you listen carefully!",
                        collection: "tirmidhi",
                        hadithNumber: 2518,
                        reference: "Jami' at-Tirmidhi 2518"
                    ),
                    storyTitle: "Sami's Honest Find",
                    character: "Sami",
                    characterEmoji: "\u{1F466}",
                    storyPages: [
                        StoryPage(text: "Sami found a shiny watch on the playground. 'Wow, finders keepers!' he thought. But then his heart felt funny \u{2014} like something wasn't quite right.", emoji: "\u{231A}", isHadithGlowMoment: false),
                        StoryPage(text: "His friend said: 'Just keep it! Nobody will know.' But Sami remembered what his teacher said about listening to your heart when you feel unsure.", emoji: "\u{1F914}", isHadithGlowMoment: false),
                        StoryPage(text: "Sami brought the watch to the school office. The next day, a boy came running up to him with the biggest smile: 'You found my watch! My grandpa gave it to me. Thank you SO much!'", emoji: "\u{1F60D}", isHadithGlowMoment: false),
                        StoryPage(text: "Sami remembered the hadith: 'Leave that which makes you doubt for that which does not make you doubt.' His heart felt peaceful and light. Doing the right thing always feels best!", emoji: "\u{2728}", isHadithGlowMoment: true)
                    ],
                    moralLesson: "When something feels wrong in your heart, choose the path that gives you peace. Your heart knows!",
                    learningCards: [
                        LearningCard(question: "What did Sami find?", emoji: "\u{231A}", options: ["A ball", "A watch", "Money", "A book"], correctAnswer: 1),
                        LearningCard(question: "What did Sami's heart tell him?", emoji: "\u{2764}\u{FE0F}", options: ["Keep it", "Something wasn't right", "Throw it away", "Nothing"], correctAnswer: 1),
                        LearningCard(question: "What should you do when you feel doubt?", emoji: "\u{1F31F}", options: ["Ignore it", "Choose what gives you peace", "Do it anyway", "Ask no one"], correctAnswer: 1)
                    ]
                )
            ],
            quizzes: [
                HadithQuiz(question: "What does truthfulness lead to?", options: ["Problems", "Righteousness and Paradise", "Nothing", "Trouble"], correctAnswer: 1, explanation: "The Prophet \u{FDFA} taught that truthfulness leads to righteousness, which leads to Jannah!"),
                HadithQuiz(question: "When you feel doubt about something, what should you do?", options: ["Do it anyway", "Leave it for what doesn't cause doubt", "Ignore your feelings", "Ask a stranger"], correctAnswer: 1, explanation: "The hadith teaches us to leave doubtful things and choose what gives us peace."),
                HadithQuiz(question: "Why was Mama proud of Zayd?", options: ["He cleaned his room", "He told the truth about the vase", "He got good grades", "He ate his vegetables"], correctAnswer: 1, explanation: "Zayd was brave enough to tell the truth even though he was scared!")
            ],
            miniGame: .honestySorting
        ),

        // MARK: Zone 3 - Prayer Garden
        HadithZone(
            name: "Prayer Garden",
            emoji: "\u{1F338}",
            color: Color(hex: "2E8B57"),
            gradient: [Color(hex: "98FB98"), Color(hex: "2E8B57")],
            description: "A beautiful garden where prayers bloom like flowers!",
            hadiths: [
                KidsHadithStory(
                    hadith: KidsHadith(
                        id: "prayer_1",
                        emoji: "\u{1F511}",
                        title: "The Key to Paradise",
                        arabicText: "\u{0645}\u{0641}\u{062A}\u{0627}\u{062D} \u{0627}\u{0644}\u{062C}\u{0646}\u{0629} \u{0627}\u{0644}\u{0635}\u{0644}\u{0627}\u{0629}",
                        simpleMeaning: "The key to Paradise is prayer.",
                        funFact: "Imagine prayer as a golden key that opens the most beautiful garden you've ever seen!",
                        collection: "tirmidhi",
                        hadithNumber: 4,
                        reference: "Jami' at-Tirmidhi 4"
                    ),
                    storyTitle: "Amina's Prayer Garden",
                    character: "Amina",
                    characterEmoji: "\u{1F467}",
                    storyPages: [
                        StoryPage(text: "Amina loved her little garden. She watered the flowers every day, talked to them, and watched them grow. One day, her grandmother said: 'Did you know your prayers are like a garden too?'", emoji: "\u{1F33A}", isHadithGlowMoment: false),
                        StoryPage(text: "'Every time you pray,' Grandma explained, 'it's like planting a beautiful flower in your garden of good deeds. The more you pray with love, the more your garden grows!'", emoji: "\u{1F331}", isHadithGlowMoment: false),
                        StoryPage(text: "Amina started praying with more focus and love. She imagined each prayer adding a new flower to her special garden. Fajr was a sunrise flower, Dhuhr a sunflower, Asr a daisy, Maghrib a rose, and Isha a moonflower!", emoji: "\u{1F33C}", isHadithGlowMoment: false),
                        StoryPage(text: "Grandma smiled and told her: 'The Prophet \u{FDFA} said: The key to Paradise is prayer. Your prayers are the key that opens the gate to the most beautiful garden of all \u{2014} Jannah!' Amina's heart bloomed with joy.", emoji: "\u{2728}", isHadithGlowMoment: true)
                    ],
                    moralLesson: "Prayer is the key to Paradise. Each prayer is like planting a beautiful flower in your garden of good deeds!",
                    learningCards: [
                        LearningCard(question: "What is the key to Paradise?", emoji: "\u{1F511}", options: ["Money", "Prayer", "Toys", "Food"], correctAnswer: 1),
                        LearningCard(question: "How many daily prayers are there?", emoji: "\u{1F54C}", options: ["Three", "Four", "Five", "Six"], correctAnswer: 2),
                        LearningCard(question: "What did Amina compare each prayer to?", emoji: "\u{1F33A}", options: ["A toy", "A flower", "A star", "A book"], correctAnswer: 1)
                    ]
                ),
                KidsHadithStory(
                    hadith: KidsHadith(
                        id: "prayer_2",
                        emoji: "\u{1F4CB}",
                        title: "Prayer Comes First",
                        arabicText: "\u{0625}\u{0646} \u{0623}\u{0648}\u{0644} \u{0645}\u{0627} \u{064A}\u{062D}\u{0627}\u{0633}\u{0628} \u{0628}\u{0647} \u{0627}\u{0644}\u{0639}\u{0628}\u{062F} \u{064A}\u{0648}\u{0645} \u{0627}\u{0644}\u{0642}\u{064A}\u{0627}\u{0645}\u{0629} \u{0627}\u{0644}\u{0635}\u{0644}\u{0627}\u{0629}",
                        simpleMeaning: "The first thing a person will be asked about on the Day of Judgment is prayer.",
                        funFact: "Prayer is so important that it's the very first thing Allah will ask about!",
                        collection: "nasai",
                        hadithNumber: 465,
                        reference: "Sunan an-Nasa'i 465"
                    ),
                    storyTitle: "Grandpa Kareem's Prayer Lesson",
                    character: "Grandpa Kareem",
                    characterEmoji: "\u{1F474}",
                    storyPages: [
                        StoryPage(text: "Grandpa Kareem sat on his favorite chair with little Sami and Amina around him. 'Grandpa, why do we pray five times every day?' asked Sami curiously.", emoji: "\u{1F474}", isHadithGlowMoment: false),
                        StoryPage(text: "Grandpa smiled. 'Imagine you have a best friend. Would you only talk to them once a year? No! You'd want to talk every day! Prayer is our conversation with Allah, our Creator and Best Friend.'", emoji: "\u{1F4AC}", isHadithGlowMoment: false),
                        StoryPage(text: "'But what if I'm playing and don't want to stop?' asked Amina. Grandpa said: 'Even playing feels better after prayer. It's like charging your heart-battery! A charged heart plays better.'", emoji: "\u{1F50B}", isHadithGlowMoment: false),
                        StoryPage(text: "Grandpa's eyes sparkled: 'The Prophet \u{FDFA} said: The first thing a person will be asked about is prayer. So let's make our prayers beautiful, because they're the first thing Allah sees!' Both kids nodded with big smiles.", emoji: "\u{2728}", isHadithGlowMoment: true)
                    ],
                    moralLesson: "Prayer is our daily conversation with Allah. It's the most important thing we do, and it charges our hearts!",
                    learningCards: [
                        LearningCard(question: "What is prayer compared to in the story?", emoji: "\u{1F4AC}", options: ["A chore", "A conversation with Allah", "Homework", "A game"], correctAnswer: 1),
                        LearningCard(question: "What is the first thing we'll be asked about?", emoji: "\u{2753}", options: ["School grades", "How much money we had", "Our prayers", "Our toys"], correctAnswer: 2),
                        LearningCard(question: "What does prayer do for your heart?", emoji: "\u{1F50B}", options: ["Makes it tired", "Charges it like a battery", "Nothing", "Makes it heavy"], correctAnswer: 1)
                    ]
                )
            ],
            quizzes: [
                HadithQuiz(question: "What is the key to Paradise?", options: ["Gold", "Prayer", "Sleeping", "Playing"], correctAnswer: 1, explanation: "The Prophet \u{FDFA} taught us that prayer is the key that opens the door to Jannah!"),
                HadithQuiz(question: "How many times do Muslims pray each day?", options: ["Three", "Five", "Seven", "Once"], correctAnswer: 1, explanation: "Muslims pray five daily prayers: Fajr, Dhuhr, Asr, Maghrib, and Isha."),
                HadithQuiz(question: "What is prayer compared to in Grandpa's story?", options: ["A chore", "Talking to your best friend", "Exercise", "Reading"], correctAnswer: 1, explanation: "Prayer is like talking to Allah, our Creator and Best Friend, every day!")
            ],
            miniGame: .prayerPuzzle
        ),

        // MARK: Zone 4 - Sharing Village
        HadithZone(
            name: "Sharing Village",
            emoji: "\u{1F3D8}\u{FE0F}",
            color: Color(hex: "FF8C00"),
            gradient: [Color(hex: "FFD700"), Color(hex: "FF8C00")],
            description: "A cheerful village where sharing makes everyone richer!",
            hadiths: [
                KidsHadithStory(
                    hadith: KidsHadith(
                        id: "sharing_1",
                        emoji: "\u{1F49B}",
                        title: "Give Charity Quickly",
                        arabicText: "\u{0628}\u{0627}\u{062F}\u{0631}\u{0648}\u{0627} \u{0628}\u{0627}\u{0644}\u{0635}\u{062F}\u{0642}\u{0629}",
                        simpleMeaning: "Give charity without delay, for it stands in the way of calamity.",
                        funFact: "Charity is like a shield that protects you. The faster you give, the faster the protection!",
                        collection: "tirmidhi",
                        hadithNumber: 589,
                        reference: "Jami' at-Tirmidhi 589"
                    ),
                    storyTitle: "Zayd's Charity Drive",
                    character: "Zayd",
                    characterEmoji: "\u{1F604}",
                    storyPages: [
                        StoryPage(text: "Zayd heard that a family in his neighborhood lost their home in a storm. He felt sad but then had a brilliant idea: 'Let's collect things to help them!'", emoji: "\u{1F4A1}", isHadithGlowMoment: false),
                        StoryPage(text: "Zayd went door to door with his wagon. Mrs. Ahmad gave blankets, Uncle Bilal gave food, and the kids on his street donated toys and clothes. The wagon was overflowing!", emoji: "\u{1F6D2}", isHadithGlowMoment: false),
                        StoryPage(text: "When they delivered everything to the family, the children's eyes lit up like stars. The mother had tears of joy: 'May Allah bless you all!' Zayd felt something special in his heart.", emoji: "\u{1F60D}", isHadithGlowMoment: false),
                        StoryPage(text: "Papa told Zayd: 'The Prophet \u{FDFA} said: Give charity without delay! You didn't wait, Zayd. You acted right away, and look how many people you helped!' Zayd's heart felt as big as the sky.", emoji: "\u{2728}", isHadithGlowMoment: true)
                    ],
                    moralLesson: "Don't wait to help others! When you see someone in need, act quickly. Every little bit of charity makes a big difference!",
                    learningCards: [
                        LearningCard(question: "What did Zayd do when he heard about the family?", emoji: "\u{1F4A1}", options: ["Nothing", "Organized a charity drive", "Complained", "Watched TV"], correctAnswer: 1),
                        LearningCard(question: "What does the hadith say about charity?", emoji: "\u{1F49B}", options: ["Wait until later", "Give without delay", "Only give money", "Don't give at all"], correctAnswer: 1),
                        LearningCard(question: "What can be given as charity?", emoji: "\u{1F381}", options: ["Only money", "Blankets, food, toys, and more!", "Nothing", "Only food"], correctAnswer: 1)
                    ]
                ),
                KidsHadithStory(
                    hadith: KidsHadith(
                        id: "sharing_2",
                        emoji: "\u{1F91C}",
                        title: "The Giving Hand",
                        arabicText: "\u{0627}\u{0644}\u{064A}\u{062F} \u{0627}\u{0644}\u{0639}\u{0644}\u{064A}\u{0627} \u{062E}\u{064A}\u{0631} \u{0645}\u{0646} \u{0627}\u{0644}\u{064A}\u{062F} \u{0627}\u{0644}\u{0633}\u{0641}\u{0644}\u{0649}",
                        simpleMeaning: "The upper hand (the giving hand) is better than the lower hand (the receiving hand).",
                        funFact: "Being generous doesn't make you poorer \u{2014} it actually makes your blessings grow!",
                        collection: "bukhari",
                        hadithNumber: 1427,
                        reference: "Sahih al-Bukhari 1427"
                    ),
                    storyTitle: "Sami Learns About Generosity",
                    character: "Sami",
                    characterEmoji: "\u{1F466}",
                    storyPages: [
                        StoryPage(text: "Sami saved up his allowance for weeks to buy a big toy. But when Grandpa Kareem took him to the store, Sami noticed a boy looking at toys through the window with sad eyes.", emoji: "\u{1F6CD}\u{FE0F}", isHadithGlowMoment: false),
                        StoryPage(text: "Grandpa Kareem whispered: 'What do you think, Sami? You could buy your toy, or...' Sami looked at the boy again. His heart made the decision before his brain did.", emoji: "\u{2764}\u{FE0F}", isHadithGlowMoment: false),
                        StoryPage(text: "Sami walked up to the boy and said: 'Hey, pick any toy you want \u{2014} it's on me!' The boy couldn't believe it. His smile was the biggest Sami had ever seen!", emoji: "\u{1F604}", isHadithGlowMoment: false),
                        StoryPage(text: "Grandpa Kareem hugged Sami and said: 'The Prophet \u{FDFA} said: The upper hand is better than the lower hand. The giving hand is always better! And Allah will replace what you gave with something even better.' Sami felt richer than ever!", emoji: "\u{2728}", isHadithGlowMoment: true)
                    ],
                    moralLesson: "Being the one who gives is always better than being the one who receives. Generosity makes your heart rich!",
                    learningCards: [
                        LearningCard(question: "What did Sami do with his allowance?", emoji: "\u{1F4B0}", options: ["Bought himself a toy", "Bought a toy for another boy", "Threw it away", "Saved more"], correctAnswer: 1),
                        LearningCard(question: "Which hand is better according to the hadith?", emoji: "\u{270B}", options: ["The lower hand", "The upper (giving) hand", "The left hand", "Neither"], correctAnswer: 1),
                        LearningCard(question: "What did Grandpa say Allah will do?", emoji: "\u{1F31F}", options: ["Nothing", "Be angry", "Replace it with something better", "Take more away"], correctAnswer: 2)
                    ]
                )
            ],
            quizzes: [
                HadithQuiz(question: "What should you do when you see someone in need?", options: ["Walk away", "Help without delay", "Wait for someone else", "Ignore them"], correctAnswer: 1, explanation: "The Prophet taught us to give charity without delay when we see someone in need!"),
                HadithQuiz(question: "Which hand is better \u{2014} the giving or receiving?", options: ["The receiving hand", "The giving hand", "Both are the same", "Neither"], correctAnswer: 1, explanation: "The upper (giving) hand is better than the lower (receiving) hand."),
                HadithQuiz(question: "What kinds of things count as charity?", options: ["Only money", "Money, food, clothes, toys, smiles, and more!", "Only food", "Nothing you have"], correctAnswer: 1, explanation: "Charity includes anything you share to help others \u{2014} even a smile!")
            ],
            miniGame: .helpNeighbor
        ),

        // MARK: Zone 5 - Respect Forest
        HadithZone(
            name: "Respect Forest",
            emoji: "\u{1F332}",
            color: Color(hex: "228B22"),
            gradient: [Color(hex: "8B4513"), Color(hex: "228B22")],
            description: "A peaceful forest where respect for others grows tall like trees!",
            hadiths: [
                KidsHadithStory(
                    hadith: KidsHadith(
                        id: "respect_1",
                        emoji: "\u{1F475}",
                        title: "Mercy and Respect",
                        arabicText: "\u{0644}\u{064A}\u{0633} \u{0645}\u{0646}\u{0627} \u{0645}\u{0646} \u{0644}\u{0645} \u{064A}\u{0631}\u{062D}\u{0645} \u{0635}\u{063A}\u{064A}\u{0631}\u{0646}\u{0627} \u{0648}\u{064A}\u{0648}\u{0642}\u{0631} \u{0643}\u{0628}\u{064A}\u{0631}\u{0646}\u{0627}",
                        simpleMeaning: "He is not one of us who does not show mercy to our young ones and respect to our elders.",
                        funFact: "In Islam, respecting elders and being kind to younger kids are both equally important!",
                        collection: "tirmidhi",
                        hadithNumber: 1921,
                        reference: "Jami' at-Tirmidhi 1921"
                    ),
                    storyTitle: "Amina Helps Aunty Fatima",
                    character: "Amina",
                    characterEmoji: "\u{1F467}",
                    storyPages: [
                        StoryPage(text: "Amina noticed that Aunty Fatima next door was struggling to carry her grocery bags. Aunty Fatima was old and her back hurt. Amina ran over right away: 'Aunty, let me help you!'", emoji: "\u{1F6CD}\u{FE0F}", isHadithGlowMoment: false),
                        StoryPage(text: "Amina carried the bags inside, helped put everything away, and even made Aunty Fatima a cup of tea. Aunty Fatima's eyes filled with happy tears: 'You are such a blessing, dear.'", emoji: "\u{2615}", isHadithGlowMoment: false),
                        StoryPage(text: "Every week after that, Amina would visit Aunty Fatima. They would read Quran together, share stories, and laugh. Amina loved hearing about the old days, and Aunty Fatima loved having a young friend.", emoji: "\u{1F4D6}", isHadithGlowMoment: false),
                        StoryPage(text: "Mama told Amina: 'The Prophet \u{FDFA} said: He is not one of us who does not show mercy to our young ones and respect our elders. You're being a true Muslim, Amina!' Amina felt proud and grateful.", emoji: "\u{2728}", isHadithGlowMoment: true)
                    ],
                    moralLesson: "Respecting elders and being kind to younger children is part of being a true Muslim!",
                    learningCards: [
                        LearningCard(question: "What did Amina do for Aunty Fatima?", emoji: "\u{1F6CD}\u{FE0F}", options: ["Nothing", "Helped carry groceries and made tea", "Ran away", "Asked for money"], correctAnswer: 1),
                        LearningCard(question: "What does the hadith say about elders?", emoji: "\u{1F474}", options: ["Ignore them", "Respect them", "Avoid them", "Only visit on Eid"], correctAnswer: 1),
                        LearningCard(question: "What should we show to young children?", emoji: "\u{1F476}", options: ["Anger", "Mercy and kindness", "Strictness only", "Nothing"], correctAnswer: 1)
                    ]
                ),
                KidsHadithStory(
                    hadith: KidsHadith(
                        id: "respect_2",
                        emoji: "\u{1F469}",
                        title: "Paradise and Your Mother",
                        arabicText: "\u{0627}\u{0644}\u{062C}\u{0646}\u{0629} \u{062A}\u{062D}\u{062A} \u{0623}\u{0642}\u{062F}\u{0627}\u{0645} \u{0627}\u{0644}\u{0623}\u{0645}\u{0647}\u{0627}\u{062A}",
                        simpleMeaning: "Paradise lies at the feet of your mother.",
                        funFact: "Mothers hold the most special place in Islam. Making your mom happy is a shortcut to Jannah!",
                        collection: "nasai",
                        hadithNumber: 3104,
                        reference: "Sunan an-Nasa'i 3104"
                    ),
                    storyTitle: "Sami's Breakfast Surprise",
                    character: "Sami",
                    characterEmoji: "\u{1F466}",
                    storyPages: [
                        StoryPage(text: "Sami woke up extra early on Saturday. Instead of watching cartoons, he tiptoed to the kitchen. Today, he was going to make breakfast for Mama! She always did everything for the family.", emoji: "\u{1F373}", isHadithGlowMoment: false),
                        StoryPage(text: "Sami carefully made toast (only slightly burnt!), poured juice, and picked a flower from the garden. He arranged everything on a tray and wrote a note: 'For the best Mama in the world!'", emoji: "\u{1F33B}", isHadithGlowMoment: false),
                        StoryPage(text: "When Mama woke up and saw the breakfast tray, she laughed and cried happy tears at the same time. 'Oh Sami, this is the most beautiful thing anyone has ever done for me!' She hugged him so tight.", emoji: "\u{1F917}", isHadithGlowMoment: false),
                        StoryPage(text: "Papa joined them and said: 'Sami, the Prophet \u{FDFA} said: Paradise lies at the feet of your mother. By making Mama happy, you're building your path to Jannah!' Sami decided he would do this every week!", emoji: "\u{2728}", isHadithGlowMoment: true)
                    ],
                    moralLesson: "Making your mother happy is one of the greatest things you can do. Paradise is connected to how you treat her!",
                    learningCards: [
                        LearningCard(question: "What did Sami do for his mother?", emoji: "\u{1F373}", options: ["Nothing", "Made her breakfast", "Broke something", "Went to play"], correctAnswer: 1),
                        LearningCard(question: "Where does Paradise lie according to the hadith?", emoji: "\u{1F3D4}\u{FE0F}", options: ["In the sky", "At the feet of your mother", "In school", "Underground"], correctAnswer: 1),
                        LearningCard(question: "How did Mama react?", emoji: "\u{1F60D}", options: ["She was angry", "She didn't care", "She was very happy", "She was confused"], correctAnswer: 2)
                    ]
                )
            ],
            quizzes: [
                HadithQuiz(question: "What should we show to our elders?", options: ["Disrespect", "Respect and honor", "Ignore them", "Only talk on holidays"], correctAnswer: 1, explanation: "The Prophet \u{FDFA} taught us that respecting our elders is part of our faith!"),
                HadithQuiz(question: "Where does Paradise lie?", options: ["Under a rainbow", "At the feet of your mother", "In a cave", "On a mountain"], correctAnswer: 1, explanation: "Making your mother happy is a path to Paradise. Treat her with love!"),
                HadithQuiz(question: "What does mercy to young ones mean?", options: ["Being strict always", "Being kind and gentle", "Ignoring them", "Scaring them"], correctAnswer: 1, explanation: "Showing mercy means being kind, gentle, and caring to children younger than you.")
            ],
            miniGame: .kindnessCatcher
        )
    ]
}


// MARK: - HadithKidsWorldView (Main Entry Point)

struct HadithKidsWorldView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var dataService = HadithKidsDataService.shared
    @State private var selectedZone: HadithZone?

    private let zones = HadithWorldData.zones

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "E8F5E9"), Color(hex: "FFF3E0"), Color(hex: "F3E5F5")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        headerView
                        ForEach(Array(zones.enumerated()), id: \.element.id) { index, zone in
                            NavigationLink(value: zone.id) {
                                zoneCard(zone: zone, index: index)
                            }
                            .buttonStyle(.plain)
                        }
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: UUID.self) { zoneId in
                if let zone = zones.first(where: { $0.id == zoneId }) {
                    HadithZoneView(zone: zone)
                }
            }
            .task {
                await dataService.prefetchAllZoneHadiths()
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 8) {
            Text("\u{2601}\u{FE0F} Hadith Stories World \u{2601}\u{FE0F}")
                .font(.largeTitle.bold())
                .foregroundStyle(
                    LinearGradient(colors: [Color(hex: "FF6B6B"), Color(hex: "FFD93D")],
                                   startPoint: .leading, endPoint: .trailing)
                )

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("\(appState.totalStars) Stars Earned")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }

            Text("Explore magical zones and learn beautiful hadiths!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
    }

    private func zoneCard(zone: HadithZone, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(zone.emoji)
                    .font(.system(size: 44))
                VStack(alignment: .leading, spacing: 4) {
                    Text(zone.name)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text(zone.description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }
                Spacer()
                VStack(spacing: 2) {
                    Text("\(zone.hadiths.count)")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Text("Stories")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }

            HStack(spacing: 12) {
                Label("\(zone.hadiths.count) Stories", systemImage: "book.fill")
                Label("\(zone.quizzes.count) Quizzes", systemImage: "questionmark.circle.fill")
                Label("1 Game", systemImage: "gamecontroller.fill")
            }
            .font(.caption)
            .foregroundColor(.white.opacity(0.9))
        }
        .padding(20)
        .background(
            LinearGradient(colors: zone.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(20)
        .shadow(color: zone.color.opacity(0.4), radius: 10, y: 5)
    }
}

// MARK: - HadithZoneView

struct HadithZoneView: View {
    @EnvironmentObject var appState: AppState
    let zone: HadithZone

    var body: some View {
        ZStack {
            LinearGradient(colors: zone.gradient.map { $0.opacity(0.3) },
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    zoneHeader
                    storiesSection
                    quizSection
                    miniGameSection
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle(zone.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var zoneHeader: some View {
        VStack(spacing: 8) {
            Text(zone.emoji)
                .font(.system(size: 60))
            Text(zone.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }

    private var storiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\u{1F4D6} Stories")
                .font(.title3.bold())

            ForEach(zone.hadiths) { story in
                NavigationLink {
                    HadithStoryView(story: story, zoneGradient: zone.gradient)
                } label: {
                    storyCard(story: story)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func storyCard(story: KidsHadithStory) -> some View {
        HStack(spacing: 16) {
            Text(story.characterEmoji)
                .font(.system(size: 40))

            VStack(alignment: .leading, spacing: 4) {
                Text(story.storyTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("with \(story.character)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(story.hadith.reference)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right.circle.fill")
                .font(.title3)
                .foregroundColor(zone.color)
        }
        .padding(16)
        .background(Color.white.opacity(0.9))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }

    private var quizSection: some View {
        NavigationLink {
            HadithQuizView(quizzes: zone.quizzes, zoneName: zone.name, zoneGradient: zone.gradient)
        } label: {
            HStack {
                Text("\u{1F3AF}")
                    .font(.system(size: 32))
                VStack(alignment: .leading) {
                    Text("Zone Quiz")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(zone.quizzes.count) questions")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding(16)
            .background(
                LinearGradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                               startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }

    private var miniGameSection: some View {
        NavigationLink {
            HadithMiniGameView(gameType: zone.miniGame, zoneGradient: zone.gradient)
        } label: {
            HStack {
                Text(zone.miniGame.emoji)
                    .font(.system(size: 32))
                VStack(alignment: .leading) {
                    Text(zone.miniGame.rawValue)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Mini Game")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                Image(systemName: "gamecontroller.fill")
                    .foregroundColor(.white)
            }
            .padding(16)
            .background(
                LinearGradient(colors: [Color(hex: "f093fb"), Color(hex: "f5576c")],
                               startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - HadithStoryView

struct HadithStoryView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject private var ttsService = TextToSpeechService.shared
    @StateObject private var dataService = HadithKidsDataService.shared
    let story: KidsHadithStory
    let zoneGradient: [Color]

    @State private var currentPage = 0
    @State private var showLearningCards = false
    @State private var glowAnimation = false

    var body: some View {
        ZStack {
            LinearGradient(colors: zoneGradient.map { $0.opacity(0.2) },
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            if showLearningCards {
                HadithLearningCardsView(
                    cards: story.learningCards,
                    storyTitle: story.storyTitle,
                    zoneGradient: zoneGradient
                )
            } else {
                storyContent
            }
        }
        .navigationTitle(story.storyTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            _ = await dataService.fetchArabicText(
                collection: story.hadith.collection,
                number: story.hadith.hadithNumber
            )
        }
        .onDisappear {
            ttsService.stop()
        }
    }

    private var storyContent: some View {
        VStack(spacing: 16) {
            characterHeader
            pageContent
            pageNavigation
        }
        .padding(.horizontal, 16)
    }

    private var characterHeader: some View {
        HStack(spacing: 8) {
            Text(story.characterEmoji)
                .font(.system(size: 40))
            Text(story.character)
                .font(.title3.bold())
                .foregroundColor(.primary)
            Spacer()
            Text("\(currentPage + 1)/\(story.storyPages.count)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
        }
        .padding(.top, 8)
    }

    private var pageContent: some View {
        let page = story.storyPages[currentPage]

        return VStack(spacing: 16) {
            Text(page.emoji)
                .font(.system(size: 64))
                .padding(.top, 8)

            if page.isHadithGlowMoment {
                hadithGlowContent(page: page)
            } else {
                regularContent(page: page)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.white.opacity(0.9))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            ttsService.speakEnglish(page.text, rate: 0.4)
        }
    }

    private func regularContent(page: StoryPage) -> some View {
        VStack(spacing: 12) {
            Text(page.text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .lineSpacing(6)

            if ttsService.isSpeaking {
                HStack(spacing: 4) {
                    Image(systemName: "speaker.wave.2.fill")
                    Text("Listening...")
                }
                .font(.caption)
                .foregroundColor(.blue)
            } else {
                HStack(spacing: 4) {
                    Image(systemName: "sparkles")
                    Text("Tap for AI voice")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
    }

    private func hadithGlowContent(page: StoryPage) -> some View {
        VStack(spacing: 16) {
            Text(page.text)
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .lineSpacing(6)

            Divider()

            VStack(spacing: 12) {
                Text("\u{2728} Hadith Glow Moment \u{2728}")
                    .font(.headline)
                    .foregroundColor(Color(hex: "FFD700"))

                let arabicDisplay = dataService.arabicText(for: story.hadith)
                Text(arabicDisplay)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "FFD700"))
                    .shadow(color: Color(hex: "FFD700").opacity(glowAnimation ? 0.8 : 0.3), radius: glowAnimation ? 15 : 5)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(16)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            glowAnimation = true
                        }
                    }
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        ttsService.speakArabic(arabicDisplay, rate: 0.35)
                    }

                Text(story.moralLesson)
                    .font(.body.italic())
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
        }
    }

    private var pageNavigation: some View {
        VStack(spacing: 12) {
            HStack {
                if currentPage > 0 {
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        ttsService.stop()
                        withAnimation { currentPage -= 1 }
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.gray)
                        .cornerRadius(25)
                    }
                }

                Spacer()

                if currentPage < story.storyPages.count - 1 {
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        ttsService.stop()
                        withAnimation { currentPage += 1 }
                    } label: {
                        HStack {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                    }
                } else {
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        ttsService.stop()
                        withAnimation { showLearningCards = true }
                    } label: {
                        HStack {
                            Text("Learning Time!")
                            Image(systemName: "star.fill")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                    }
                }
            }

            // Page dots
            HStack(spacing: 8) {
                ForEach(0..<story.storyPages.count, id: \.self) { i in
                    Circle()
                        .fill(i == currentPage ? Color.primary : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(.bottom, 8)
    }
}

// MARK: - HadithLearningCardsView

struct HadithLearningCardsView: View {
    @EnvironmentObject var appState: AppState
    let cards: [LearningCard]
    let storyTitle: String
    let zoneGradient: [Color]

    @State private var currentCard = 0
    @State private var selectedOption: Int?
    @State private var starsEarned = 0
    @State private var showCompletion = false
    @State private var answered = false

    var body: some View {
        VStack(spacing: 20) {
            if showCompletion {
                completionView
            } else {
                cardContent
            }
        }
        .padding(16)
    }

    private var cardContent: some View {
        let card = cards[currentCard]

        return VStack(spacing: 20) {
            Text("Card \(currentCard + 1) of \(cards.count)")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(card.emoji)
                .font(.system(size: 50))

            Text(card.question)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)

            VStack(spacing: 12) {
                ForEach(Array(card.options.enumerated()), id: \.offset) { index, option in
                    Button {
                        guard !answered else { return }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        selectedOption = index
                        answered = true
                        if index == card.correctAnswer {
                            starsEarned += 1
                        }
                    } label: {
                        HStack {
                            Text(option)
                                .font(.body)
                                .foregroundColor(optionTextColor(index: index, card: card))
                                .multilineTextAlignment(.leading)
                            Spacer()
                            if answered {
                                if index == card.correctAnswer {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else if index == selectedOption {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(16)
                        .background(optionBackground(index: index, card: card))
                        .cornerRadius(12)
                    }
                    .disabled(answered)
                }
            }

            if answered {
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if currentCard < cards.count - 1 {
                        withAnimation {
                            currentCard += 1
                            selectedOption = nil
                            answered = false
                        }
                    } else {
                        withAnimation {
                            appState.completeLesson("hadith_story_\(storyTitle)", points: starsEarned * 5)
                            showCompletion = true
                        }
                    }
                } label: {
                    Text(currentCard < cards.count - 1 ? "Next Card \u{27A1}\u{FE0F}" : "See Results \u{2B50}")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                }
            }
        }
        .padding(24)
        .background(Color.white.opacity(0.95))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
    }

    private var completionView: some View {
        VStack(spacing: 20) {
            Text("\u{1F389}")
                .font(.system(size: 64))

            Text("Great Job!")
                .font(.largeTitle.bold())

            HStack(spacing: 4) {
                ForEach(0..<starsEarned, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.title)
                }
                ForEach(0..<(cards.count - starsEarned), id: \.self) { _ in
                    Image(systemName: "star")
                        .foregroundColor(.gray.opacity(0.3))
                        .font(.title)
                }
            }

            Text("You earned \(starsEarned) out of \(cards.count) stars!")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("MashaAllah! Keep learning beautiful hadiths!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .background(Color.white.opacity(0.95))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
    }

    private func optionTextColor(index: Int, card: LearningCard) -> Color {
        guard answered else { return .primary }
        if index == card.correctAnswer { return .green }
        if index == selectedOption { return .red }
        return .primary.opacity(0.5)
    }

    private func optionBackground(index: Int, card: LearningCard) -> Color {
        guard answered else { return Color.gray.opacity(0.1) }
        if index == card.correctAnswer { return Color.green.opacity(0.15) }
        if index == selectedOption { return Color.red.opacity(0.15) }
        return Color.gray.opacity(0.05)
    }
}

// MARK: - HadithQuizView

struct HadithQuizView: View {
    @EnvironmentObject var appState: AppState
    let quizzes: [HadithQuiz]
    let zoneName: String
    let zoneGradient: [Color]

    @State private var currentQuestion = 0
    @State private var selectedOption: Int?
    @State private var score = 0
    @State private var answered = false
    @State private var showResult = false

    var body: some View {
        ZStack {
            LinearGradient(colors: zoneGradient.map { $0.opacity(0.2) },
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            if showResult {
                quizResultView
            } else {
                quizContent
            }
        }
        .navigationTitle("\(zoneName) Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var quizContent: some View {
        let quiz = quizzes[currentQuestion]

        return VStack(spacing: 20) {
            Text("Question \(currentQuestion + 1) of \(quizzes.count)")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("\u{1F3AF}")
                .font(.system(size: 44))

            Text(quiz.question)
                .font(.title3.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(Array(quiz.options.enumerated()), id: \.offset) { index, option in
                    Button {
                        guard !answered else { return }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        selectedOption = index
                        answered = true
                        if index == quiz.correctAnswer {
                            score += 1
                        }
                    } label: {
                        HStack {
                            Text(option)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            if answered && index == quiz.correctAnswer {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else if answered && index == selectedOption && index != quiz.correctAnswer {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(16)
                        .foregroundColor(quizOptionColor(index: index, quiz: quiz))
                        .background(quizOptionBg(index: index, quiz: quiz))
                        .cornerRadius(12)
                    }
                    .disabled(answered)
                }
            }
            .padding(.horizontal)

            if answered {
                Text(quiz.explanation)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    if currentQuestion < quizzes.count - 1 {
                        withAnimation {
                            currentQuestion += 1
                            selectedOption = nil
                            answered = false
                        }
                    } else {
                        withAnimation {
                            appState.completeLesson("hadith_quiz_\(zoneName)", points: score * 5)
                            showResult = true
                        }
                    }
                } label: {
                    Text(currentQuestion < quizzes.count - 1 ? "Next Question" : "See Score")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(24)
        .padding(.horizontal, 16)
    }

    private var quizResultView: some View {
        VStack(spacing: 20) {
            Text(score == quizzes.count ? "\u{1F3C6}" : "\u{2B50}")
                .font(.system(size: 64))

            Text(score == quizzes.count ? "Perfect Score!" : "Great Effort!")
                .font(.largeTitle.bold())

            Text("\(score) / \(quizzes.count)")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(
                    LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing)
                )

            Text("You earned \(score * 5) points!")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("MashaAllah! Keep learning and growing!")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(32)
        .background(Color.white.opacity(0.95))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        .padding(.horizontal, 16)
    }

    private func quizOptionColor(index: Int, quiz: HadithQuiz) -> Color {
        guard answered else { return .primary }
        if index == quiz.correctAnswer { return .green }
        if index == selectedOption { return .red }
        return .primary.opacity(0.5)
    }

    private func quizOptionBg(index: Int, quiz: HadithQuiz) -> Color {
        guard answered else { return Color.gray.opacity(0.1) }
        if index == quiz.correctAnswer { return Color.green.opacity(0.15) }
        if index == selectedOption { return Color.red.opacity(0.15) }
        return Color.gray.opacity(0.05)
    }
}


// MARK: - HadithMiniGameView

struct HadithMiniGameView: View {
    @EnvironmentObject var appState: AppState
    let gameType: HadithMiniGameType
    let zoneGradient: [Color]

    var body: some View {
        ZStack {
            LinearGradient(colors: zoneGradient.map { $0.opacity(0.2) },
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            switch gameType {
            case .intentionGlow:
                IntentionGlowGame(zoneGradient: zoneGradient)
            case .helpNeighbor:
                HelpNeighborGame(zoneGradient: zoneGradient)
            case .honestySorting:
                HonestySortingGame(zoneGradient: zoneGradient)
            case .prayerPuzzle:
                PrayerPuzzleGame(zoneGradient: zoneGradient)
            case .kindnessCatcher:
                KindnessCatcherGame(zoneGradient: zoneGradient)
            }
        }
        .navigationTitle(gameType.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Intention Glow Game

struct IntentionGlowGame: View {
    @EnvironmentObject var appState: AppState
    let zoneGradient: [Color]

    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var items: [GlowItem] = []
    @State private var gameOver = false
    @State private var timerActive = false

    struct GlowItem: Identifiable {
        let id = UUID()
        let emoji: String
        let isGood: Bool
        var position: CGPoint
        var visible: Bool = true
    }

    private let goodItems = ["\u{2764}\u{FE0F}", "\u{1F91D}", "\u{1F64F}", "\u{1F31F}", "\u{1F60A}", "\u{1F33B}", "\u{1F496}"]
    private let badItems = ["\u{1F620}", "\u{1F4B0}", "\u{1F621}", "\u{1F44E}", "\u{1F630}"]

    var body: some View {
        VStack(spacing: 16) {
            if gameOver {
                gameOverView
            } else {
                gameHeader
                gameArea
                startOrStatusView
            }
        }
        .padding()
        .onAppear { generateItems() }
    }

    private var gameHeader: some View {
        HStack {
            Label("\(score)", systemImage: "star.fill")
                .foregroundColor(.yellow)
                .font(.headline)
            Spacer()
            Label("\(timeRemaining)s", systemImage: "clock.fill")
                .foregroundColor(timeRemaining <= 10 ? .red : .primary)
                .font(.headline)
        }
    }

    private var gameArea: some View {
        VStack(spacing: 8) {
            Text("\u{2728} Tap items with good intentions! \u{2728}")
                .font(.subheadline.bold())
                .foregroundColor(.secondary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(items.filter { $0.visible }) { item in
                    Button {
                        handleTap(item)
                    } label: {
                        Text(item.emoji)
                            .font(.system(size: 36))
                            .frame(width: 60, height: 60)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
                    }
                    .disabled(!timerActive)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
    }

    private var startOrStatusView: some View {
        Group {
            if !timerActive && !gameOver {
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    startGame()
                } label: {
                    Text("\u{1F3AE} Start Game!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25)
                }
            } else {
                Text("Tap \u{2764}\u{FE0F} good intentions, avoid \u{1F620} bad ones!")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var gameOverView: some View {
        VStack(spacing: 20) {
            Text(score >= 5 ? "\u{1F31F}" : "\u{1F4AA}")
                .font(.system(size: 64))
            Text("Game Over!")
                .font(.largeTitle.bold())
            Text("Score: \(score)")
                .font(.title.bold())
                .foregroundStyle(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
            Text("Good intentions make your heart glow!")
                .font(.body)
                .foregroundColor(.secondary)

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                resetGame()
            } label: {
                Text("Play Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(25)
            }
        }
        .padding(32)
        .background(Color.white.opacity(0.95))
        .cornerRadius(24)
    }

    private func generateItems() {
        var newItems: [GlowItem] = []
        for _ in 0..<8 {
            let emoji = goodItems.randomElement()!
            newItems.append(GlowItem(emoji: emoji, isGood: true, position: .zero))
        }
        for _ in 0..<4 {
            let emoji = badItems.randomElement()!
            newItems.append(GlowItem(emoji: emoji, isGood: false, position: .zero))
        }
        items = newItems.shuffled()
    }

    private func handleTap(_ item: GlowItem) {
        if item.isGood {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            score += 1
        } else {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            score = max(0, score - 1)
        }
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx].visible = false
        }
        if items.filter({ $0.visible }).isEmpty {
            generateItems()
        }
    }

    private func startGame() {
        timerActive = true
        score = 0
        timeRemaining = 30
        generateItems()
        startTimer()
    }

    private func resetGame() {
        gameOver = false
        startGame()
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                timerActive = false
                appState.completeLesson("minigame_intention_glow", points: score * 2)
                withAnimation { gameOver = true }
            }
        }
    }
}

// MARK: - Help Neighbor Game

struct HelpNeighborGame: View {
    @EnvironmentObject var appState: AppState
    let zoneGradient: [Color]

    struct MatchPair: Identifiable {
        let id = UUID()
        let helper: String
        let helperLabel: String
        let person: String
        let personLabel: String
    }

    @State private var pairs: [MatchPair] = [
        MatchPair(helper: "\u{1F6D2}", helperLabel: "Groceries", person: "\u{1F475}", personLabel: "Elderly lady"),
        MatchPair(helper: "\u{1F4DA}", helperLabel: "Books", person: "\u{1F466}", personLabel: "Student"),
        MatchPair(helper: "\u{1F37D}\u{FE0F}", helperLabel: "Food", person: "\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}", personLabel: "Family"),
        MatchPair(helper: "\u{1FA79}", helperLabel: "Bandage", person: "\u{1F935}", personLabel: "Injured person"),
        MatchPair(helper: "\u{1F9F9}", helperLabel: "Cleaning", person: "\u{1F54C}", personLabel: "Masjid")
    ]

    @State private var selectedHelper: Int?
    @State private var matches: Set<UUID> = []
    @State private var score = 0
    @State private var wrongMatch = false

    var body: some View {
        VStack(spacing: 20) {
            Text("\u{1F91D} Match the helper to who needs help!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Matches: \(score)/\(pairs.count)")
                    .font(.subheadline.bold())
            }

            if score == pairs.count {
                completionView
            } else {
                gameBoard
            }
        }
        .padding()
    }

    private var gameBoard: some View {
        HStack(spacing: 24) {
            VStack(spacing: 12) {
                Text("Helpers")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                ForEach(Array(pairs.enumerated()), id: \.element.id) { index, pair in
                    if !matches.contains(pair.id) {
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            selectedHelper = index
                        } label: {
                            VStack(spacing: 4) {
                                Text(pair.helper)
                                    .font(.system(size: 32))
                                Text(pair.helperLabel)
                                    .font(.caption2)
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 80, height: 70)
                            .background(selectedHelper == index ? Color.blue.opacity(0.2) : Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedHelper == index ? Color.blue : Color.clear, lineWidth: 2)
                            )
                        }
                    }
                }
            }

            VStack(spacing: 12) {
                Text("Needs Help")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                ForEach(Array(pairs.shuffled().enumerated()), id: \.element.id) { _, pair in
                    if !matches.contains(pair.id) {
                        Button {
                            handlePersonTap(pair)
                        } label: {
                            VStack(spacing: 4) {
                                Text(pair.person)
                                    .font(.system(size: 32))
                                Text(pair.personLabel)
                                    .font(.caption2)
                                    .foregroundColor(.primary)
                            }
                            .frame(width: 80, height: 70)
                            .background(wrongMatch ? Color.red.opacity(0.1) : Color.white.opacity(0.8))
                            .cornerRadius(12)
                        }
                        .disabled(selectedHelper == nil)
                    }
                }
            }
        }
    }

    private var completionView: some View {
        VStack(spacing: 16) {
            Text("\u{1F389}")
                .font(.system(size: 64))
            Text("All Matched!")
                .font(.title.bold())
            Text("You helped everyone in the neighborhood!")
                .font(.body)
                .foregroundColor(.secondary)
            Text("The Prophet \u{FDFA} taught us to help our neighbors!")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(24)
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
    }

    private func handlePersonTap(_ pair: MatchPair) {
        guard let helperIdx = selectedHelper else { return }
        let selectedPair = pairs[helperIdx]

        if selectedPair.id == pair.id {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            matches.insert(pair.id)
            score += 1
            selectedHelper = nil
            if score == pairs.count {
                appState.completeLesson("minigame_help_neighbor", points: score * 3)
            }
        } else {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            wrongMatch = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                wrongMatch = false
            }
            selectedHelper = nil
        }
    }
}

// MARK: - Honesty Sorting Game

struct HonestySortingGame: View {
    @EnvironmentObject var appState: AppState
    let zoneGradient: [Color]

    struct SortStatement: Identifiable {
        let id = UUID()
        let text: String
        let isTruth: Bool
    }

    @State private var statements: [SortStatement] = [
        SortStatement(text: "I broke it but I'll say I didn't", isTruth: false),
        SortStatement(text: "I made a mistake and I'll admit it", isTruth: true),
        SortStatement(text: "I'll pretend I did my homework", isTruth: false),
        SortStatement(text: "I'll tell my teacher I need help", isTruth: true),
        SortStatement(text: "I found money and I'll return it", isTruth: true),
        SortStatement(text: "I'll say my friend did it, not me", isTruth: false),
        SortStatement(text: "I'll be honest even if it's hard", isTruth: true),
        SortStatement(text: "I'll copy and say it's my work", isTruth: false)
    ].shuffled()

    @State private var currentIndex = 0
    @State private var score = 0
    @State private var feedback: String?
    @State private var showResult = false

    var body: some View {
        VStack(spacing: 20) {
            if showResult {
                resultView
            } else if currentIndex < statements.count {
                sortingContent
            }
        }
        .padding()
    }

    private var sortingContent: some View {
        let statement = statements[currentIndex]

        return VStack(spacing: 20) {
            Text("\u{2696}\u{FE0F} Truth or Lie?")
                .font(.title2.bold())

            Text("Statement \(currentIndex + 1) of \(statements.count)")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("\"\(statement.text)\"")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(20)
                .background(Color.white.opacity(0.9))
                .cornerRadius(16)

            if let feedback = feedback {
                Text(feedback)
                    .font(.headline)
                    .foregroundColor(feedback.contains("Correct") ? .green : .red)
                    .transition(.scale)
            }

            HStack(spacing: 20) {
                Button {
                    checkAnswer(isTruth: true)
                } label: {
                    VStack {
                        Text("\u{2705}")
                            .font(.system(size: 36))
                        Text("Truth")
                            .font(.headline)
                    }
                    .frame(width: 120, height: 80)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(16)
                }

                Button {
                    checkAnswer(isTruth: false)
                } label: {
                    VStack {
                        Text("\u{274C}")
                            .font(.system(size: 36))
                        Text("Lie")
                            .font(.headline)
                    }
                    .frame(width: 120, height: 80)
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(16)
                }
            }
            .disabled(feedback != nil)
        }
        .padding(24)
        .background(Color.white.opacity(0.5))
        .cornerRadius(24)
    }

    private var resultView: some View {
        VStack(spacing: 20) {
            Text(score >= 6 ? "\u{1F31F}" : "\u{1F4AA}")
                .font(.system(size: 64))
            Text("Sorting Complete!")
                .font(.largeTitle.bold())
            Text("Score: \(score)/\(statements.count)")
                .font(.title.bold())
                .foregroundStyle(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
            Text("Truthfulness leads to righteousness!")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(32)
        .background(Color.white.opacity(0.95))
        .cornerRadius(24)
    }

    private func checkAnswer(isTruth: Bool) {
        let statement = statements[currentIndex]
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        if statement.isTruth == isTruth {
            score += 1
            feedback = "\u{2705} Correct!"
        } else {
            feedback = "\u{274C} Not quite!"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            feedback = nil
            if currentIndex < statements.count - 1 {
                withAnimation { currentIndex += 1 }
            } else {
                appState.completeLesson("minigame_honesty_sorting", points: score * 3)
                withAnimation { showResult = true }
            }
        }
    }
}

// MARK: - Prayer Puzzle Game

struct PrayerPuzzleGame: View {
    @EnvironmentObject var appState: AppState
    let zoneGradient: [Color]

    private let correctOrder = [
        "\u{1F9CD} Stand (Qiyam)",
        "\u{1F4D6} Recite Al-Fatiha",
        "\u{1F647} Bow (Ruku)",
        "\u{1F9CE} Stand back up",
        "\u{1F932} Prostrate (Sujud)",
        "\u{1FAB4} Sit briefly",
        "\u{1F932} Prostrate again (Sujud)",
        "\u{1F64F} Sit for Tashahhud"
    ]

    @State private var selectedSteps: [String] = []
    @State private var availableSteps: [String] = []
    @State private var showResult = false
    @State private var isCorrect = false

    var body: some View {
        VStack(spacing: 16) {
            if showResult {
                puzzleResultView
            } else {
                puzzleContent
            }
        }
        .padding()
        .onAppear {
            availableSteps = correctOrder.shuffled()
        }
    }

    private var puzzleContent: some View {
        VStack(spacing: 16) {
            Text("\u{1F9E9} Put the prayer steps in order!")
                .font(.headline)
                .multilineTextAlignment(.center)

            Text("Tap each step in the correct order")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Your order:")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)

                if selectedSteps.isEmpty {
                    Text("Tap steps below to begin...")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(8)
                } else {
                    ForEach(Array(selectedSteps.enumerated()), id: \.offset) { index, step in
                        HStack {
                            Text("\(index + 1).")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Text(step)
                                .font(.caption)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text("Available steps:")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)

                LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                    ForEach(availableSteps, id: \.self) { step in
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            selectedSteps.append(step)
                            availableSteps.removeAll { $0 == step }
                        } label: {
                            Text(step)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(10)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(10)
                        }
                    }
                }
            }

            HStack(spacing: 16) {
                if !selectedSteps.isEmpty {
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        if let last = selectedSteps.popLast() {
                            availableSteps.append(last)
                        }
                    } label: {
                        Text("Undo")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.gray)
                            .cornerRadius(20)
                    }
                }

                if availableSteps.isEmpty {
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        isCorrect = selectedSteps == correctOrder
                        if isCorrect {
                            appState.completeLesson("minigame_prayer_puzzle", points: 15)
                        }
                        withAnimation { showResult = true }
                    } label: {
                        Text("Check Answer!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(25)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(24)
    }

    private var puzzleResultView: some View {
        VStack(spacing: 20) {
            Text(isCorrect ? "\u{1F389}" : "\u{1F4AA}")
                .font(.system(size: 64))

            Text(isCorrect ? "Perfect Order!" : "Almost There!")
                .font(.largeTitle.bold())

            if !isCorrect {
                VStack(alignment: .leading, spacing: 4) {
                    Text("The correct order is:")
                        .font(.headline)
                    ForEach(Array(correctOrder.enumerated()), id: \.offset) { index, step in
                        Text("\(index + 1). \(step)")
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }

            Text("Prayer is the key to Paradise!")
                .font(.body)
                .foregroundColor(.secondary)

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                selectedSteps = []
                availableSteps = correctOrder.shuffled()
                withAnimation { showResult = false }
            } label: {
                Text("Try Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(25)
            }
        }
        .padding(32)
        .background(Color.white.opacity(0.95))
        .cornerRadius(24)
    }
}

// MARK: - Kindness Catcher Game

struct KindnessCatcherGame: View {
    @EnvironmentObject var appState: AppState
    let zoneGradient: [Color]

    struct FallingItem: Identifiable {
        let id = UUID()
        let emoji: String
        let isKind: Bool
        var xPosition: CGFloat
        var yOffset: CGFloat
        var caught: Bool = false
    }

    private let kindEmojis = ["\u{2764}\u{FE0F}", "\u{1F60A}", "\u{1F91D}", "\u{1F31F}", "\u{1F338}", "\u{1F496}", "\u{1F33B}"]
    private let badEmojis = ["\u{1F620}", "\u{1F4A2}", "\u{1F621}", "\u{1F44E}"]

    @State private var items: [FallingItem] = []
    @State private var score = 0
    @State private var lives = 3
    @State private var timeRemaining = 30
    @State private var gameActive = false
    @State private var gameOver = false

    var body: some View {
        VStack(spacing: 16) {
            if gameOver {
                catcherGameOver
            } else if !gameActive {
                startView
            } else {
                activeGameView
            }
        }
        .padding()
    }

    private var startView: some View {
        VStack(spacing: 20) {
            Text("\u{1F496}")
                .font(.system(size: 64))
            Text("Kindness Catcher")
                .font(.largeTitle.bold())
            Text("Tap the falling kindness emojis!\nAvoid the angry ones!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                startGame()
            } label: {
                Text("\u{1F3AE} Start!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(25)
            }
        }
        .padding(32)
        .background(Color.white.opacity(0.95))
        .cornerRadius(24)
    }

    private var activeGameView: some View {
        VStack(spacing: 12) {
            HStack {
                Label("\(score)", systemImage: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.headline)
                Spacer()
                HStack(spacing: 2) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < lives ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }
                Spacer()
                Label("\(timeRemaining)s", systemImage: "clock.fill")
                    .foregroundColor(timeRemaining <= 10 ? .red : .primary)
                    .font(.headline)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                ForEach(items.filter { !$0.caught }) { item in
                    Button {
                        catchItem(item)
                    } label: {
                        Text(item.emoji)
                            .font(.system(size: 32))
                            .frame(width: 56, height: 56)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.3))
            .cornerRadius(20)

            Text("Catch \u{2764}\u{FE0F} kindness! Avoid \u{1F620} anger!")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var catcherGameOver: some View {
        VStack(spacing: 20) {
            Text(score >= 10 ? "\u{1F3C6}" : "\u{2B50}")
                .font(.system(size: 64))
            Text("Game Over!")
                .font(.largeTitle.bold())
            Text("Kindness caught: \(score)")
                .font(.title.bold())
                .foregroundStyle(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
            Text("Spread kindness everywhere you go!")
                .font(.body)
                .foregroundColor(.secondary)

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                gameOver = false
                startGame()
            } label: {
                Text("Play Again")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(LinearGradient(colors: zoneGradient, startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(25)
            }
        }
        .padding(32)
        .background(Color.white.opacity(0.95))
        .cornerRadius(24)
    }

    private func startGame() {
        score = 0
        lives = 3
        timeRemaining = 30
        gameActive = true
        gameOver = false
        spawnItems()
        startTimer()
    }

    private func spawnItems() {
        var newItems: [FallingItem] = []
        for _ in 0..<8 {
            let isKind = Double.random(in: 0...1) > 0.3
            let emoji = isKind ? kindEmojis.randomElement()! : badEmojis.randomElement()!
            newItems.append(FallingItem(emoji: emoji, isKind: isKind, xPosition: CGFloat.random(in: 0...1), yOffset: 0))
        }
        items = newItems
    }

    private func catchItem(_ item: FallingItem) {
        if item.isKind {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            score += 1
        } else {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            lives -= 1
            if lives <= 0 {
                endGame()
                return
            }
        }
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx].caught = true
        }
        if items.filter({ !$0.caught }).isEmpty {
            spawnItems()
        }
    }

    private func endGame() {
        gameActive = false
        appState.completeLesson("minigame_kindness_catcher", points: score * 2)
        withAnimation { gameOver = true }
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 && gameActive {
                timeRemaining -= 1
                if timeRemaining % 5 == 0 {
                    spawnItems()
                }
            } else {
                timer.invalidate()
                if gameActive { endGame() }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HadithKidsWorldView()
        .environmentObject(AppState())
}
