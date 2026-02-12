//
//  Prayer.swift
//  DeenLearn
//
//  Data models for Salah & Wudu learning
//

import SwiftUI

// MARK: - Wudu Step Model

struct WuduStep: Identifiable {
    let id: String
    let stepNumber: Int
    let name: String
    let nameArabic: String
    let description: String
    let kidsDescription: String
    let kidsEmoji: String
    let duration: Int // seconds
    let repetitions: Int
    let isSunnah: Bool
    let commonMistakes: [String]
    let fiqhNotes: String?
}

// MARK: - Salah Step Model

struct SalahStep: Identifiable {
    let id: String
    let stepNumber: Int
    let name: String
    let nameArabic: String
    let description: String
    let kidsDescription: String
    let kidsEmoji: String
    let position: SalahPosition
    let recitation: Recitation?
    let duration: Int // seconds
    let repetitions: Int
    let commonMistakes: [String]
    let fiqhNotes: String?
}

enum SalahPosition: String {
    case standing = "Standing"
    case bowing = "Bowing (Ruku)"
    case prostrating = "Prostrating (Sujud)"
    case sitting = "Sitting"
    case standingFromSujud = "Rising"
}

// MARK: - Recitation Model

struct Recitation: Identifiable {
    let id: String
    let arabic: String
    let transliteration: String
    let translation: String
    let audioFileName: String?
}

// MARK: - Dua Categories

enum DuaCategory: String, CaseIterable, Identifiable {
    case afterPrayer = "After Prayer"
    case morningAdhkar = "Morning Adhkar"
    case eveningAdhkar = "Evening Adhkar"
    case protection = "Protection"
    case travel = "Travel"
    case healing = "Healing & Sickness"
    case general = "General Duas"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .afterPrayer: return "hands.and.sparkles"
        case .morningAdhkar: return "sunrise.fill"
        case .eveningAdhkar: return "sunset.fill"
        case .protection: return "shield.fill"
        case .travel: return "airplane"
        case .healing: return "heart.fill"
        case .general: return "star.fill"
        }
    }
    
    var color: String {
        switch self {
        case .afterPrayer: return "blue"
        case .morningAdhkar: return "orange"
        case .eveningAdhkar: return "purple"
        case .protection: return "green"
        case .travel: return "indigo"
        case .healing: return "red"
        case .general: return "teal"
        }
    }
}

// MARK: - Dua After Prayer

struct DuaAfterPrayer: Identifiable {
    let id: String
    let name: String
    let arabic: String
    let transliteration: String
    let translation: String
    let benefit: String
    let timesToRecite: Int
    let category: DuaCategory
    let source: String
    let hadithCollection: String?
    let hadithNumber: Int?
    
    // Backward-compatible init
    init(id: String, name: String, arabic: String, transliteration: String, translation: String, benefit: String, timesToRecite: Int, category: DuaCategory = .afterPrayer, source: String = "Sunnah", hadithCollection: String? = nil, hadithNumber: Int? = nil) {
        self.id = id
        self.name = name
        self.arabic = arabic
        self.transliteration = transliteration
        self.translation = translation
        self.benefit = benefit
        self.timesToRecite = timesToRecite
        self.category = category
        self.source = source
        self.hadithCollection = hadithCollection
        self.hadithNumber = hadithNumber
    }
}

// MARK: - Prayer Mistake

struct PrayerMistake: Identifiable {
    let id: String
    let title: String
    let description: String
    let correction: String
    let category: MistakeCategory
}

enum MistakeCategory: String, CaseIterable {
    case wudu = "Wudu"
    case salah = "Salah"
    case recitation = "Recitation"
    case posture = "Posture"
}

// MARK: - Sample Data

extension WuduStep {
    static let allSteps: [WuduStep] = [
        WuduStep(
            id: "wudu-1",
            stepNumber: 1,
            name: "Intention (Niyyah)",
            nameArabic: "النية",
            description: "Make the intention in your heart to perform wudu for the purpose of purification and worship. The intention is made silently in the heart, not verbally.",
            kidsDescription: "Think in your heart: 'I'm going to clean myself for Allah!'",
            kidsEmoji: "💭",
            duration: 3,
            repetitions: 1,
            isSunnah: false,
            commonMistakes: ["Saying the intention out loud (it should be in the heart)"],
            fiqhNotes: "The intention must be made before starting wudu. According to Hanafi school, intention is recommended but not obligatory."
        ),
        WuduStep(
            id: "wudu-2",
            stepNumber: 2,
            name: "Say Bismillah",
            nameArabic: "بِسْمِ اللَّهِ",
            description: "Begin by saying 'Bismillah' (In the name of Allah). This invokes Allah's blessing on the act of purification.",
            kidsDescription: "Say 'Bismillah!' - that means 'In Allah's name!'",
            kidsEmoji: "🗣️",
            duration: 2,
            repetitions: 1,
            isSunnah: true,
            commonMistakes: ["Forgetting to say Bismillah"],
            fiqhNotes: "According to some scholars, saying Bismillah is obligatory (wajib), while others consider it recommended (sunnah)."
        ),
        WuduStep(
            id: "wudu-3",
            stepNumber: 3,
            name: "Wash Hands",
            nameArabic: "غسل اليدين",
            description: "Wash both hands up to the wrists three times, starting with the right hand. Make sure water reaches between the fingers.",
            kidsDescription: "Wash your hands 3 times - rub between your fingers like this! 🖐️",
            kidsEmoji: "🖐️",
            duration: 10,
            repetitions: 3,
            isSunnah: true,
            commonMistakes: ["Not washing between fingers", "Washing less than 3 times", "Not reaching the wrists"],
            fiqhNotes: "Washing hands three times at the beginning is a sunnah act. It is recommended to remove rings to ensure water reaches the skin."
        ),
        WuduStep(
            id: "wudu-4",
            stepNumber: 4,
            name: "Rinse Mouth",
            nameArabic: "المضمضة",
            description: "Take water into your mouth with your right hand and rinse it thoroughly three times, moving the water around your mouth.",
            kidsDescription: "Put water in your mouth and swish it around like mouthwash! Do it 3 times!",
            kidsEmoji: "💦",
            duration: 8,
            repetitions: 3,
            isSunnah: true,
            commonMistakes: ["Not rinsing thoroughly", "Swallowing the water while fasting"],
            fiqhNotes: "It is recommended to use the miswak (tooth stick) while rinsing the mouth."
        ),
        WuduStep(
            id: "wudu-5",
            stepNumber: 5,
            name: "Clean Nose",
            nameArabic: "الاستنشاق والاستنثار",
            description: "Sniff water into your nostrils using your right hand and blow it out using your left hand. Repeat three times.",
            kidsDescription: "Sniff a little water into your nose and blow it out gently. 3 times!",
            kidsEmoji: "👃",
            duration: 10,
            repetitions: 3,
            isSunnah: true,
            commonMistakes: ["Sniffing too much water", "Not cleaning properly", "Using the wrong hand to blow"],
            fiqhNotes: "Be gentle when sniffing water, especially while fasting. Use left hand to blow out the water."
        ),
        WuduStep(
            id: "wudu-6",
            stepNumber: 6,
            name: "Wash Face",
            nameArabic: "غسل الوجه",
            description: "Wash your entire face three times, from the hairline to below the chin, and from ear to ear. Make sure water covers every part.",
            kidsDescription: "Splash water on your face 3 times - from your hair to your chin, ear to ear!",
            kidsEmoji: "😊",
            duration: 15,
            repetitions: 3,
            isSunnah: false,
            commonMistakes: ["Missing the hairline", "Not washing under the chin", "Missing areas near ears"],
            fiqhNotes: "Washing the face is obligatory (fard). The beard should be washed on the surface, and it's recommended to run fingers through a thick beard."
        ),
        WuduStep(
            id: "wudu-7",
            stepNumber: 7,
            name: "Wash Right Arm",
            nameArabic: "غسل اليد اليمنى",
            description: "Wash your right arm from fingertips to just above the elbow, three times. Make sure water covers the entire arm.",
            kidsDescription: "Wash your right arm 3 times - all the way up past your elbow!",
            kidsEmoji: "💪",
            duration: 12,
            repetitions: 3,
            isSunnah: false,
            commonMistakes: ["Not washing above the elbow", "Missing parts of the arm", "Not washing between fingers"],
            fiqhNotes: "Washing the arms including the elbows is obligatory. Starting with the right is sunnah."
        ),
        WuduStep(
            id: "wudu-8",
            stepNumber: 8,
            name: "Wash Left Arm",
            nameArabic: "غسل اليد اليسرى",
            description: "Wash your left arm from fingertips to just above the elbow, three times. Make sure water covers the entire arm.",
            kidsDescription: "Now wash your left arm 3 times - all the way up past your elbow!",
            kidsEmoji: "💪",
            duration: 12,
            repetitions: 3,
            isSunnah: false,
            commonMistakes: ["Not washing above the elbow", "Missing parts of the arm"],
            fiqhNotes: "The same rules apply as for the right arm."
        ),
        WuduStep(
            id: "wudu-9",
            stepNumber: 9,
            name: "Wipe Head",
            nameArabic: "مسح الرأس",
            description: "Wet your hands and wipe over your head from the front hairline to the back, then return to the front. Do this once.",
            kidsDescription: "Wet your hands and slide them from your forehead to the back of your head and back again!",
            kidsEmoji: "🧠",
            duration: 5,
            repetitions: 1,
            isSunnah: false,
            commonMistakes: ["Only wiping part of the head", "Using too much water", "Wiping multiple times (some madhabs)"],
            fiqhNotes: "Hanafi: Wiping 1/4 of head is obligatory. Shafi'i/Hanbali: Wiping any part is sufficient. Maliki: Entire head must be wiped."
        ),
        WuduStep(
            id: "wudu-10",
            stepNumber: 10,
            name: "Wipe Ears",
            nameArabic: "مسح الأذنين",
            description: "Using the same wetness from wiping the head, wipe the inside of both ears with your index fingers and the outside with your thumbs.",
            kidsDescription: "Clean inside your ears with your pointer fingers and behind with your thumbs!",
            kidsEmoji: "👂",
            duration: 5,
            repetitions: 1,
            isSunnah: true,
            commonMistakes: ["Forgetting to wipe the ears", "Using new water for ears"],
            fiqhNotes: "The ears are considered part of the head. It is sunnah to wipe them with the remaining wetness from wiping the head."
        ),
        WuduStep(
            id: "wudu-11",
            stepNumber: 11,
            name: "Wash Right Foot",
            nameArabic: "غسل القدم اليمنى",
            description: "Wash your right foot up to and including the ankle, three times. Make sure to wash between all toes.",
            kidsDescription: "Wash your right foot 3 times - don't forget between your toes!",
            kidsEmoji: "🦶",
            duration: 12,
            repetitions: 3,
            isSunnah: false,
            commonMistakes: ["Not washing between toes", "Not washing the ankle", "Missing the heel"],
            fiqhNotes: "Washing feet including ankles is obligatory. Make sure water reaches between toes and under the ankle bone."
        ),
        WuduStep(
            id: "wudu-12",
            stepNumber: 12,
            name: "Wash Left Foot",
            nameArabic: "غسل القدم اليسرى",
            description: "Wash your left foot up to and including the ankle, three times. Make sure to wash between all toes.",
            kidsDescription: "Now wash your left foot 3 times - between all the toes too!",
            kidsEmoji: "🦶",
            duration: 12,
            repetitions: 3,
            isSunnah: false,
            commonMistakes: ["Not washing between toes", "Not washing the ankle"],
            fiqhNotes: "The same rules apply as for the right foot."
        ),
        WuduStep(
            id: "wudu-13",
            stepNumber: 13,
            name: "Dua After Wudu",
            nameArabic: "دعاء بعد الوضوء",
            description: "After completing wudu, recite: 'Ash-hadu an la ilaha illallah, wahdahu la sharika lah, wa ash-hadu anna Muhammadan abduhu wa rasuluh.'",
            kidsDescription: "Say the special dua! It means 'I believe there is no god but Allah and Muhammad is His messenger!'",
            kidsEmoji: "🤲",
            duration: 10,
            repetitions: 1,
            isSunnah: true,
            commonMistakes: ["Forgetting to make dua after wudu"],
            fiqhNotes: "The Prophet ﷺ said: 'Whoever performs wudu then says this dua, all eight gates of Paradise will be opened for him.'"
        )
    ]
}

extension SalahStep {
    static let twoRakatSteps: [SalahStep] = [
        // Standing for first rakah
        SalahStep(
            id: "salah-1",
            stepNumber: 1,
            name: "Takbiratul Ihram",
            nameArabic: "تكبيرة الإحرام",
            description: "Stand facing the Qibla, raise your hands to your ears (or shoulders), and say 'Allahu Akbar' to begin the prayer.",
            kidsDescription: "Stand tall, raise your hands, and say 'Allahu Akbar!' - Allah is the Greatest!",
            kidsEmoji: "🙌",
            position: .standing,
            recitation: Recitation(id: "takbir", arabic: "اللَّهُ أَكْبَرُ", transliteration: "Allahu Akbar", translation: "Allah is the Greatest", audioFileName: nil),
            duration: 3,
            repetitions: 1,
            commonMistakes: ["Not facing Qibla", "Not raising hands properly", "Starting before completing takbir"],
            fiqhNotes: "Hanafi: Raise hands to ears. Shafi'i/Hanbali: Raise to shoulders. This takbir is obligatory and marks entry into prayer."
        ),
        SalahStep(
            id: "salah-2",
            stepNumber: 2,
            name: "Opening Dua (Thana)",
            nameArabic: "دعاء الاستفتاح",
            description: "Place right hand over left on your chest (or below navel), and recite the opening supplication silently.",
            kidsDescription: "Put your hands together on your tummy and say a quiet prayer to start!",
            kidsEmoji: "🙏",
            position: .standing,
            recitation: Recitation(id: "thana", arabic: "سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، وَتَبَارَكَ اسْمُكَ، وَتَعَالَى جَدُّكَ، وَلَا إِلَٰهَ غَيْرُكَ", transliteration: "Subhanaka Allahumma wa bihamdika, wa tabarakasmuka, wa ta'ala jadduka, wa la ilaha ghairuk", translation: "Glory be to You, O Allah, and praise. Blessed is Your name, exalted is Your majesty, and there is no deity but You.", audioFileName: nil),
            duration: 10,
            repetitions: 1,
            commonMistakes: ["Skipping the opening dua", "Reciting it aloud"],
            fiqhNotes: "This is a sunnah act. Different duas are reported from the Prophet ﷺ."
        ),
        SalahStep(
            id: "salah-3",
            stepNumber: 3,
            name: "Seek Refuge (Ta'awwudh)",
            nameArabic: "التعوذ",
            description: "Say 'A'udhu billahi min ash-shaytanir rajim' to seek refuge in Allah from Satan.",
            kidsDescription: "Ask Allah to protect you from Shaytan by saying the special words!",
            kidsEmoji: "🛡️",
            position: .standing,
            recitation: Recitation(id: "taawwudh", arabic: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ", transliteration: "A'udhu billahi minash-shaytanir rajim", translation: "I seek refuge in Allah from the accursed Satan", audioFileName: nil),
            duration: 3,
            repetitions: 1,
            commonMistakes: ["Forgetting to say it", "Saying it aloud in congregational prayer"],
            fiqhNotes: "Recited silently before Surah Al-Fatiha in the first rakah."
        ),
        SalahStep(
            id: "salah-4",
            stepNumber: 4,
            name: "Recite Al-Fatiha",
            nameArabic: "قراءة الفاتحة",
            description: "Recite Surah Al-Fatiha completely. This is obligatory in every rakah of prayer.",
            kidsDescription: "Now recite Surah Al-Fatiha - the most important surah!",
            kidsEmoji: "📖",
            position: .standing,
            recitation: Recitation(id: "fatiha", arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ۝ الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ۝ الرَّحْمَٰنِ الرَّحِيمِ ۝ مَالِكِ يَوْمِ الدِّينِ ۝ إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ۝ اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ۝ صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ", transliteration: "Bismillahir Rahmanir Raheem. Alhamdu lillahi Rabbil 'aalameen. Ar-Rahmanir-Raheem. Maliki yawmid-Deen. Iyyaka na'budu wa iyyaka nasta'een. Ihdinas-Siratal-Mustaqeem. Siratal-ladhina an'amta 'alayhim ghayril-maghdubi 'alayhim wa lad-dalleen.", translation: "In the name of Allah, the Most Gracious, the Most Merciful. All praise is due to Allah, Lord of the worlds. The Most Gracious, the Most Merciful. Master of the Day of Judgment. You alone we worship, and You alone we ask for help. Guide us to the straight path. The path of those upon whom You have bestowed favor, not of those who have earned anger or of those who are astray.", audioFileName: nil),
            duration: 30,
            repetitions: 1,
            commonMistakes: ["Not reciting properly", "Rushing through it", "Missing verses"],
            fiqhNotes: "Reciting Al-Fatiha is obligatory in every rakah according to the majority of scholars. Say 'Ameen' after completing it."
        ),
        SalahStep(
            id: "salah-5",
            stepNumber: 5,
            name: "Recite Additional Surah",
            nameArabic: "قراءة سورة",
            description: "After Al-Fatiha, recite another surah or some verses from the Quran.",
            kidsDescription: "Now recite another short surah you know, like Al-Ikhlas!",
            kidsEmoji: "📚",
            position: .standing,
            recitation: Recitation(id: "ikhlas", arabic: "قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ", transliteration: "Qul Huwa Allahu Ahad. Allahus-Samad. Lam yalid wa lam yulad. Wa lam yakun lahu kufuwan ahad.", translation: "Say, He is Allah, the One. Allah, the Eternal Refuge. He neither begets nor is born. Nor is there to Him any equivalent.", audioFileName: nil),
            duration: 15,
            repetitions: 1,
            commonMistakes: ["Not reciting any additional surah in first two rakahs"],
            fiqhNotes: "Reciting an additional surah after Fatiha is sunnah in the first two rakahs."
        ),
        SalahStep(
            id: "salah-6",
            stepNumber: 6,
            name: "Ruku (Bowing)",
            nameArabic: "الركوع",
            description: "Say 'Allahu Akbar' and bow down, keeping your back straight and parallel to the ground. Place hands on knees.",
            kidsDescription: "Say 'Allahu Akbar' and bow down! Keep your back flat like a table!",
            kidsEmoji: "🙇",
            position: .bowing,
            recitation: Recitation(id: "ruku", arabic: "سُبْحَانَ رَبِّيَ الْعَظِيمِ", transliteration: "Subhana Rabbiyal 'Azeem", translation: "Glory be to my Lord, the Most Great", audioFileName: nil),
            duration: 10,
            repetitions: 3,
            commonMistakes: ["Back not straight", "Head too low or too high", "Not saying tasbeeh 3 times"],
            fiqhNotes: "The tasbeeh should be said at least once (obligatory according to some), but three times is sunnah."
        ),
        SalahStep(
            id: "salah-7",
            stepNumber: 7,
            name: "Rise from Ruku",
            nameArabic: "الرفع من الركوع",
            description: "Stand up saying 'Sami'Allahu liman hamidah' (Allah hears those who praise Him), then say 'Rabbana wa lakal hamd.'",
            kidsDescription: "Stand up straight and say 'Sami Allahu liman hamidah, Rabbana wa lakal hamd!'",
            kidsEmoji: "🧍",
            position: .standing,
            recitation: Recitation(id: "qawma", arabic: "سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ، رَبَّنَا وَلَكَ الْحَمْدُ", transliteration: "Sami'Allahu liman hamidah, Rabbana wa lakal hamd", translation: "Allah hears those who praise Him. Our Lord, to You is all praise.", audioFileName: nil),
            duration: 5,
            repetitions: 1,
            commonMistakes: ["Not standing fully straight", "Rushing this position"],
            fiqhNotes: "The imam says 'Sami'Allahu liman hamidah' and followers respond with 'Rabbana wa lakal hamd.'"
        ),
        SalahStep(
            id: "salah-8",
            stepNumber: 8,
            name: "First Sujud",
            nameArabic: "السجدة الأولى",
            description: "Say 'Allahu Akbar' and prostrate with seven body parts touching the ground: forehead, nose, both palms, both knees, and toes of both feet.",
            kidsDescription: "Say 'Allahu Akbar' and put your head down! Touch the ground with your forehead!",
            kidsEmoji: "🙏",
            position: .prostrating,
            recitation: Recitation(id: "sujud", arabic: "سُبْحَانَ رَبِّيَ الْأَعْلَى", transliteration: "Subhana Rabbiyal A'la", translation: "Glory be to my Lord, the Most High", audioFileName: nil),
            duration: 10,
            repetitions: 3,
            commonMistakes: ["Elbows touching ground", "Feet lifting off ground", "Not saying tasbeeh"],
            fiqhNotes: "The Prophet ﷺ said: 'The closest a servant is to his Lord is when prostrating, so increase your supplication.'"
        ),
        SalahStep(
            id: "salah-9",
            stepNumber: 9,
            name: "Sit Between Prostrations",
            nameArabic: "الجلوس بين السجدتين",
            description: "Say 'Allahu Akbar' and sit up, placing your hands on your thighs. Say 'Rabbighfir li' (My Lord, forgive me).",
            kidsDescription: "Sit up and ask Allah to forgive you: 'Rabbighfir li!'",
            kidsEmoji: "🧎",
            position: .sitting,
            recitation: Recitation(id: "jalsa", arabic: "رَبِّ اغْفِرْ لِي", transliteration: "Rabbighfir li", translation: "My Lord, forgive me", audioFileName: nil),
            duration: 5,
            repetitions: 1,
            commonMistakes: ["Rushing this sitting", "Not making dua"],
            fiqhNotes: "It is sunnah to say 'Rabbighfir li' twice or more during this sitting."
        ),
        SalahStep(
            id: "salah-10",
            stepNumber: 10,
            name: "Second Sujud",
            nameArabic: "السجدة الثانية",
            description: "Say 'Allahu Akbar' and prostrate again, saying 'Subhana Rabbiyal A'la' three times.",
            kidsDescription: "Go back down for another sujud! Say 'Subhana Rabbiyal A'la' 3 times!",
            kidsEmoji: "🙏",
            position: .prostrating,
            recitation: Recitation(id: "sujud2", arabic: "سُبْحَانَ رَبِّيَ الْأَعْلَى", transliteration: "Subhana Rabbiyal A'la", translation: "Glory be to my Lord, the Most High", audioFileName: nil),
            duration: 10,
            repetitions: 3,
            commonMistakes: ["Same as first sujud"],
            fiqhNotes: "Same rules apply as the first prostration."
        ),
        // Second Rakah
        SalahStep(
            id: "salah-11",
            stepNumber: 11,
            name: "Stand for Second Rakah",
            nameArabic: "القيام للركعة الثانية",
            description: "Say 'Allahu Akbar' and stand up for the second rakah. Place hands as before.",
            kidsDescription: "Stand back up saying 'Allahu Akbar!' Time for the second rakah!",
            kidsEmoji: "🧍",
            position: .standing,
            recitation: nil,
            duration: 3,
            repetitions: 1,
            commonMistakes: ["Not standing fully before starting Fatiha"],
            fiqhNotes: "Some scholars recommend brief sitting before standing (jalsatul istirahah)."
        ),
        SalahStep(
            id: "salah-12",
            stepNumber: 12,
            name: "Second Rakah - Fatiha",
            nameArabic: "الفاتحة - الركعة الثانية",
            description: "Recite Surah Al-Fatiha again.",
            kidsDescription: "Recite Al-Fatiha again!",
            kidsEmoji: "📖",
            position: .standing,
            recitation: Recitation(id: "fatiha2", arabic: "الْفَاتِحَة", transliteration: "Al-Fatiha", translation: "The Opening", audioFileName: nil),
            duration: 30,
            repetitions: 1,
            commonMistakes: ["Same as first rakah"],
            fiqhNotes: nil
        ),
        SalahStep(
            id: "salah-13",
            stepNumber: 13,
            name: "Second Rakah - Additional Surah",
            nameArabic: "سورة - الركعة الثانية",
            description: "Recite another surah after Al-Fatiha.",
            kidsDescription: "Recite another short surah!",
            kidsEmoji: "📚",
            position: .standing,
            recitation: nil,
            duration: 15,
            repetitions: 1,
            commonMistakes: ["Skipping in second rakah"],
            fiqhNotes: nil
        ),
        SalahStep(
            id: "salah-14",
            stepNumber: 14,
            name: "Second Rakah - Ruku",
            nameArabic: "الركوع - الركعة الثانية",
            description: "Perform ruku as in the first rakah.",
            kidsDescription: "Bow down again! 'Subhana Rabbiyal Azeem' 3 times!",
            kidsEmoji: "🙇",
            position: .bowing,
            recitation: Recitation(id: "ruku2", arabic: "سُبْحَانَ رَبِّيَ الْعَظِيمِ", transliteration: "Subhana Rabbiyal 'Azeem", translation: "Glory be to my Lord, the Most Great", audioFileName: nil),
            duration: 10,
            repetitions: 3,
            commonMistakes: ["Same as first rakah"],
            fiqhNotes: nil
        ),
        SalahStep(
            id: "salah-15",
            stepNumber: 15,
            name: "Second Rakah - Rise & Sujud",
            nameArabic: "القيام والسجود",
            description: "Rise from ruku, then perform two prostrations as before.",
            kidsDescription: "Stand up, then do two sujuds just like before!",
            kidsEmoji: "🙏",
            position: .prostrating,
            recitation: nil,
            duration: 30,
            repetitions: 1,
            commonMistakes: ["Rushing"],
            fiqhNotes: nil
        ),
        SalahStep(
            id: "salah-16",
            stepNumber: 16,
            name: "Tashahhud",
            nameArabic: "التشهد",
            description: "After the second sujud, sit and recite the Tashahhud while raising the index finger.",
            kidsDescription: "Sit down and recite the Tashahhud. Point with your finger when saying 'La ilaha illallah!'",
            kidsEmoji: "☝️",
            position: .sitting,
            recitation: Recitation(id: "tashahhud", arabic: "التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ، السَّلَامُ عَلَيْنَا وَعَلَىٰ عِبَادِ اللَّهِ الصَّالِحِينَ، أَشْهَدُ أَن لَّا إِلَٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ", transliteration: "At-tahiyyatu lillahi was-salawatu wat-tayyibat. As-salamu 'alayka ayyuhan-Nabiyyu wa rahmatullahi wa barakatuh. As-salamu 'alayna wa 'ala 'ibadillahis-salihin. Ash-hadu an la ilaha illallah wa ash-hadu anna Muhammadan 'abduhu wa rasuluh.", translation: "All greetings, prayers, and good things are for Allah. Peace be upon you, O Prophet, and the mercy of Allah and His blessings. Peace be upon us and upon the righteous servants of Allah. I bear witness that there is no deity but Allah and I bear witness that Muhammad is His servant and messenger.", audioFileName: nil),
            duration: 20,
            repetitions: 1,
            commonMistakes: ["Not raising index finger", "Looking at the finger instead of the pointing direction"],
            fiqhNotes: "There are different versions of the Tashahhud. This is the most common one."
        ),
        SalahStep(
            id: "salah-17",
            stepNumber: 17,
            name: "Salawat (Durood)",
            nameArabic: "الصلاة على النبي",
            description: "Send blessings upon the Prophet Muhammad ﷺ by reciting the Salawat/Durood Ibrahim.",
            kidsDescription: "Say a special prayer for Prophet Muhammad ﷺ!",
            kidsEmoji: "💚",
            position: .sitting,
            recitation: Recitation(id: "durood", arabic: "اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ", transliteration: "Allahumma salli 'ala Muhammadin wa 'ala ali Muhammad, kama sallayta 'ala Ibrahima wa 'ala ali Ibrahim, innaka Hamidun Majid", translation: "O Allah, send prayers upon Muhammad and upon the family of Muhammad, as You sent prayers upon Ibrahim and upon the family of Ibrahim. Indeed, You are Praiseworthy, Glorious.", audioFileName: nil),
            duration: 15,
            repetitions: 1,
            commonMistakes: ["Skipping the durood"],
            fiqhNotes: "Reciting Durood in the final sitting is obligatory according to Shafi'i school, sunnah according to others."
        ),
        SalahStep(
            id: "salah-18",
            stepNumber: 18,
            name: "Final Dua",
            nameArabic: "الدعاء قبل السلام",
            description: "Make any dua you wish before ending the prayer. A recommended dua is seeking refuge from four things.",
            kidsDescription: "Ask Allah for anything good before ending your prayer!",
            kidsEmoji: "🤲",
            position: .sitting,
            recitation: Recitation(id: "dua", arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عَذَابِ جَهَنَّمَ، وَمِنْ عَذَابِ الْقَبْرِ، وَمِنْ فِتْنَةِ الْمَحْيَا وَالْمَمَاتِ، وَمِنْ شَرِّ فِتْنَةِ الْمَسِيحِ الدَّجَّالِ", transliteration: "Allahumma inni a'udhu bika min 'adhabi jahannam, wa min 'adhabil-qabr, wa min fitnatil-mahya wal-mamat, wa min sharri fitnatil-masihid-dajjal", translation: "O Allah, I seek refuge in You from the punishment of Hell, the punishment of the grave, the trials of life and death, and the evil of the trial of the False Messiah.", audioFileName: nil),
            duration: 10,
            repetitions: 1,
            commonMistakes: ["Skipping dua before salam"],
            fiqhNotes: "The Prophet ﷺ taught this dua specifically for before the salam."
        ),
        SalahStep(
            id: "salah-19",
            stepNumber: 19,
            name: "Salam to the Right",
            nameArabic: "السلام - يمين",
            description: "Turn your head to the right and say 'As-salamu alaykum wa rahmatullah.'",
            kidsDescription: "Turn your head right and say 'As-salamu alaykum wa rahmatullah!'",
            kidsEmoji: "👉",
            position: .sitting,
            recitation: Recitation(id: "salam1", arabic: "السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ", transliteration: "As-salamu alaykum wa rahmatullah", translation: "Peace be upon you and the mercy of Allah", audioFileName: nil),
            duration: 3,
            repetitions: 1,
            commonMistakes: ["Not turning head enough", "Saying it too fast"],
            fiqhNotes: "Some scholars say to look at the shoulder when making salam."
        ),
        SalahStep(
            id: "salah-20",
            stepNumber: 20,
            name: "Salam to the Left",
            nameArabic: "السلام - يسار",
            description: "Turn your head to the left and say 'As-salamu alaykum wa rahmatullah.' This completes the prayer.",
            kidsDescription: "Turn your head left and say 'As-salamu alaykum wa rahmatullah!' - You did it! 🎉",
            kidsEmoji: "👈",
            position: .sitting,
            recitation: Recitation(id: "salam2", arabic: "السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ", transliteration: "As-salamu alaykum wa rahmatullah", translation: "Peace be upon you and the mercy of Allah", audioFileName: nil),
            duration: 3,
            repetitions: 1,
            commonMistakes: ["Leaving prayer area immediately"],
            fiqhNotes: "It is sunnah to sit briefly after salam for dhikr and dua."
        )
    ]
}

extension DuaAfterPrayer {
    static let allDuas: [DuaAfterPrayer] = [
        // MARK: - After Prayer Adhkar
        DuaAfterPrayer(
            id: "dua-1",
            name: "Astaghfirullah",
            arabic: "أَسْتَغْفِرُ اللَّهَ",
            transliteration: "Astaghfirullah",
            translation: "I seek forgiveness from Allah",
            benefit: "Seeking forgiveness from Allah for any shortcomings in the prayer",
            timesToRecite: 3,
            category: .afterPrayer,
            source: "Sahih Muslim 591",
            hadithCollection: "muslim",
            hadithNumber: 591
        ),
        DuaAfterPrayer(
            id: "dua-2",
            name: "Allahumma Antas-Salam",
            arabic: "اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ",
            transliteration: "Allahumma antas-salam wa minkas-salam, tabarakta ya dhal-jalali wal-ikram",
            translation: "O Allah, You are Peace and from You comes peace. Blessed are You, O Owner of majesty and honor.",
            benefit: "Acknowledging Allah as the source of all peace",
            timesToRecite: 1,
            category: .afterPrayer,
            source: "Sahih Muslim 592",
            hadithCollection: "muslim",
            hadithNumber: 592
        ),
        DuaAfterPrayer(
            id: "dua-3",
            name: "SubhanAllah",
            arabic: "سُبْحَانَ اللَّهِ",
            transliteration: "SubhanAllah",
            translation: "Glory be to Allah",
            benefit: "Glorifying Allah — the Prophet ﷺ said this fills the scale of good deeds",
            timesToRecite: 33,
            category: .afterPrayer,
            source: "Sahih Muslim 597",
            hadithCollection: "muslim",
            hadithNumber: 597
        ),
        DuaAfterPrayer(
            id: "dua-4",
            name: "Alhamdulillah",
            arabic: "الْحَمْدُ لِلَّهِ",
            transliteration: "Alhamdulillah",
            translation: "All praise is due to Allah",
            benefit: "Praising Allah for all blessings",
            timesToRecite: 33,
            category: .afterPrayer,
            source: "Sahih Muslim 597",
            hadithCollection: "muslim",
            hadithNumber: 597
        ),
        DuaAfterPrayer(
            id: "dua-5",
            name: "Allahu Akbar",
            arabic: "اللَّهُ أَكْبَرُ",
            transliteration: "Allahu Akbar",
            translation: "Allah is the Greatest",
            benefit: "Acknowledging Allah's greatness",
            timesToRecite: 33,
            category: .afterPrayer,
            source: "Sahih Muslim 597",
            hadithCollection: "muslim",
            hadithNumber: 597
        ),
        DuaAfterPrayer(
            id: "dua-6",
            name: "La ilaha illallah",
            arabic: "لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd wa huwa 'ala kulli shay'in qadir",
            translation: "There is no deity but Allah alone, with no partner. To Him belongs the dominion, and to Him is all praise, and He is capable of all things.",
            benefit: "Completing the 100 with this declaration of faith",
            timesToRecite: 1,
            category: .afterPrayer,
            source: "Sahih Muslim 593",
            hadithCollection: "muslim",
            hadithNumber: 593
        ),
        DuaAfterPrayer(
            id: "dua-7",
            name: "Ayatul Kursi",
            arabic: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ",
            transliteration: "Allahu la ilaha illa huwal-Hayyul-Qayyum. La ta'khudhuhu sinatun wa la nawm. Lahu ma fis-samawati wa ma fil-ard. Man dhal-ladhi yashfa'u 'indahu illa bi-idhnih. Ya'lamu ma bayna aydihim wa ma khalfahum wa la yuhituna bi-shay'im-min 'ilmihi illa bima sha'. Wasi'a kursiyyuhus-samawati wal-ard. Wa la ya'uduhu hifdhuhuwa wa huwal-'Aliyyul-'Azim.",
            translation: "Allah — there is no deity except Him, the Ever-Living, the Sustainer of existence. Neither drowsiness overtakes Him nor sleep. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is before them and what will be after them, and they encompass not a thing of His knowledge except for what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.",
            benefit: "The Prophet ﷺ said whoever recites it after every prayer, nothing prevents them from entering Paradise except death",
            timesToRecite: 1,
            category: .afterPrayer,
            source: "Sunan an-Nasa'i 9928 / Al-Baqarah 2:255",
            hadithCollection: "nasai",
            hadithNumber: 9928
        ),
        
        // MARK: - Morning Adhkar
        DuaAfterPrayer(
            id: "dua-morning-1",
            name: "Morning Remembrance",
            arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "Asbahna wa asbahal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd wa huwa 'ala kulli shay'in qadir",
            translation: "We have reached the morning and at this very time the dominion belongs to Allah. All praise is for Allah. None has the right to be worshiped except Allah alone, without any partner. To Him belongs the dominion, and all praise is for Him, and He is capable of all things.",
            benefit: "Starting the day acknowledging Allah's sovereignty and blessings",
            timesToRecite: 1,
            category: .morningAdhkar,
            source: "Sahih Muslim 2723",
            hadithCollection: "muslim",
            hadithNumber: 2723
        ),
        DuaAfterPrayer(
            id: "dua-morning-2",
            name: "Sayyid al-Istighfar",
            arabic: "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ وَأَنَا عَلَىٰ عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ",
            transliteration: "Allahumma anta rabbi la ilaha illa anta, khalaqtani wa ana 'abduka, wa ana 'ala 'ahdika wa wa'dika mastata'tu, a'udhu bika min sharri ma sana'tu, abu'u laka bini'matika 'alayya wa abu'u bi-dhanbi, faghfir li fa-innahu la yaghfirudh-dhunuba illa ant",
            translation: "O Allah, You are my Lord. There is no deity except You. You created me and I am Your servant. I am on Your covenant and promise as best I can. I seek refuge in You from the evil of what I have done. I acknowledge Your blessings upon me and I confess my sins. Forgive me, for none forgives sins but You.",
            benefit: "The master supplication for forgiveness — whoever says it with conviction in the morning and dies that day enters Paradise",
            timesToRecite: 1,
            category: .morningAdhkar,
            source: "Sahih al-Bukhari 6306",
            hadithCollection: "bukhari",
            hadithNumber: 6306
        ),
        DuaAfterPrayer(
            id: "dua-morning-3",
            name: "Morning Protection",
            arabic: "بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            transliteration: "Bismillahil-ladhi la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama'i wa huwas-Sami'ul-'Alim",
            translation: "In the name of Allah, with whose name nothing on earth or in heaven can harm, and He is the All-Hearing, All-Knowing.",
            benefit: "Protection from all harm throughout the day — nothing will harm the one who says this three times",
            timesToRecite: 3,
            category: .morningAdhkar,
            source: "Sunan Abu Dawud 5088 / Jami' at-Tirmidhi 3388",
            hadithCollection: "abu-daud",
            hadithNumber: 5088
        ),
        DuaAfterPrayer(
            id: "dua-morning-4",
            name: "Contentment with Allah",
            arabic: "رَضِيتُ بِاللَّهِ رَبًّا وَبِالْإِسْلَامِ دِينًا وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا",
            transliteration: "Raditu billahi rabba, wa bil-islami dina, wa bi-Muhammadin sallallahu 'alayhi wa sallama nabiyya",
            translation: "I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad ﷺ as my Prophet.",
            benefit: "Whoever says this three times in the morning, it is Allah's promise to please them on the Day of Judgment",
            timesToRecite: 3,
            category: .morningAdhkar,
            source: "Sunan Abu Dawud 5072",
            hadithCollection: "abu-daud",
            hadithNumber: 5072
        ),
        
        // MARK: - Evening Adhkar
        DuaAfterPrayer(
            id: "dua-evening-1",
            name: "Evening Remembrance",
            arabic: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "Amsayna wa amsal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamd wa huwa 'ala kulli shay'in qadir",
            translation: "We have reached the evening and at this very time the dominion belongs to Allah. All praise is for Allah. None has the right to be worshiped except Allah alone, without any partner. To Him belongs the dominion, and all praise is for Him, and He is capable of all things.",
            benefit: "Ending the day acknowledging Allah's sovereignty, mirroring the morning adhkar",
            timesToRecite: 1,
            category: .eveningAdhkar,
            source: "Sahih Muslim 2723",
            hadithCollection: "muslim",
            hadithNumber: 2723
        ),
        DuaAfterPrayer(
            id: "dua-evening-2",
            name: "Seeking Refuge (Al-Mu'awwidhatan)",
            arabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ● قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
            transliteration: "Qul a'udhu bi rabbil-falaq... Qul a'udhu bi rabbin-nas...",
            translation: "Say: I seek refuge in the Lord of daybreak... Say: I seek refuge in the Lord of mankind...",
            benefit: "The Prophet ﷺ would recite these surahs in the morning and evening for protection",
            timesToRecite: 3,
            category: .eveningAdhkar,
            source: "Sunan Abu Dawud 5082",
            hadithCollection: "abu-daud",
            hadithNumber: 5082
        ),
        DuaAfterPrayer(
            id: "dua-evening-3",
            name: "Evening Protection",
            arabic: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            transliteration: "A'udhu bi kalimatillahit-tammat min sharri ma khalaq",
            translation: "I seek refuge in the perfect words of Allah from the evil of what He has created.",
            benefit: "Protection from all harm — whoever says this in the evening, no poison or sting will harm them that night",
            timesToRecite: 3,
            category: .eveningAdhkar,
            source: "Sahih Muslim 2709",
            hadithCollection: "muslim",
            hadithNumber: 2709
        ),
        
        // MARK: - Protection Duas
        DuaAfterPrayer(
            id: "dua-protect-1",
            name: "Dua for Leaving Home",
            arabic: "بِسْمِ اللَّهِ تَوَكَّلْتُ عَلَى اللَّهِ لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
            transliteration: "Bismillah, tawakkaltu 'alallah, la hawla wa la quwwata illa billah",
            translation: "In the name of Allah, I place my trust in Allah. There is no power and no strength except with Allah.",
            benefit: "An angel says: You are guided, defended and protected. And the devil turns away from you.",
            timesToRecite: 1,
            category: .protection,
            source: "Sunan Abu Dawud 5095 / Jami' at-Tirmidhi 3426",
            hadithCollection: "abu-daud",
            hadithNumber: 5095
        ),
        DuaAfterPrayer(
            id: "dua-protect-2",
            name: "Dua Before Sleeping",
            arabic: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
            transliteration: "Bismika Allahumma amutu wa ahya",
            translation: "In Your name, O Allah, I die and I live.",
            benefit: "The Prophet ﷺ would say this when lying down to sleep, acknowledging that sleep is like death",
            timesToRecite: 1,
            category: .protection,
            source: "Sahih al-Bukhari 6324",
            hadithCollection: "bukhari",
            hadithNumber: 6324
        ),
        DuaAfterPrayer(
            id: "dua-protect-3",
            name: "Dua When Waking Up",
            arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ",
            transliteration: "Alhamdu lillahil-ladhi ahyana ba'da ma amatana wa ilayhinnushur",
            translation: "All praise is for Allah who gave us life after having taken it from us, and unto Him is the resurrection.",
            benefit: "Starting your day with gratitude for being given another day of life",
            timesToRecite: 1,
            category: .protection,
            source: "Sahih al-Bukhari 6312",
            hadithCollection: "bukhari",
            hadithNumber: 6312
        ),
        DuaAfterPrayer(
            id: "dua-protect-4",
            name: "Dua for Entering the Masjid",
            arabic: "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
            transliteration: "Allahumma-ftah li abwaba rahmatik",
            translation: "O Allah, open for me the gates of Your mercy.",
            benefit: "Asking Allah's mercy when entering His house of worship",
            timesToRecite: 1,
            category: .protection,
            source: "Sahih Muslim 713",
            hadithCollection: "muslim",
            hadithNumber: 713
        ),
        
        // MARK: - General Duas
        DuaAfterPrayer(
            id: "dua-general-1",
            name: "Dua Before Eating",
            arabic: "بِسْمِ اللَّهِ",
            transliteration: "Bismillah",
            translation: "In the name of Allah.",
            benefit: "The Prophet ﷺ said: When one of you eats, let him mention the name of Allah",
            timesToRecite: 1,
            category: .general,
            source: "Sunan Abu Dawud 3767",
            hadithCollection: "abu-daud",
            hadithNumber: 3767
        ),
        DuaAfterPrayer(
            id: "dua-general-2",
            name: "Dua After Eating",
            arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَٰذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ",
            transliteration: "Alhamdu lillahil-ladhi at'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah",
            translation: "All praise is for Allah who fed me this and provided it for me without any power or might from myself.",
            benefit: "Whoever says this after eating, all previous sins are forgiven",
            timesToRecite: 1,
            category: .general,
            source: "Sunan Abu Dawud 4023 / Jami' at-Tirmidhi 3458",
            hadithCollection: "abu-daud",
            hadithNumber: 4023
        ),
        DuaAfterPrayer(
            id: "dua-general-3",
            name: "Dua When in Distress",
            arabic: "لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
            transliteration: "La ilaha illa anta subhanaka inni kuntu minaz-zalimin",
            translation: "There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers.",
            benefit: "The dua of Prophet Yunus (Jonah) — no Muslim calls upon Allah with this except that Allah answers",
            timesToRecite: 1,
            category: .general,
            source: "Jami' at-Tirmidhi 3505 / Al-Anbiya 21:87",
            hadithCollection: "tirmidhi",
            hadithNumber: 3505
        ),
        DuaAfterPrayer(
            id: "dua-general-4",
            name: "Istikhara (Seeking Guidance)",
            arabic: "اللَّهُمَّ إِنِّي أَسْتَخِيرُكَ بِعِلْمِكَ وَأَسْتَقْدِرُكَ بِقُدْرَتِكَ وَأَسْأَلُكَ مِنْ فَضْلِكَ الْعَظِيمِ",
            transliteration: "Allahumma inni astakhiruka bi 'ilmika wa astaqdiruka bi qudratika wa as'aluka min fadlikal-'azim",
            translation: "O Allah, I seek Your guidance through Your knowledge, and I seek strength through Your power, and I ask You from Your immense favor.",
            benefit: "The Prophet ﷺ taught this dua for seeking Allah's guidance in all matters of life",
            timesToRecite: 1,
            category: .general,
            source: "Sahih al-Bukhari 1166",
            hadithCollection: "bukhari",
            hadithNumber: 1166
        ),
        DuaAfterPrayer(
            id: "dua-general-5",
            name: "Dua for Parents",
            arabic: "رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا",
            transliteration: "Rabbir-hamhuma kama rabbayani saghira",
            translation: "My Lord, have mercy upon them as they brought me up when I was small.",
            benefit: "A beautiful Quranic dua showing gratitude and love for parents",
            timesToRecite: 1,
            category: .general,
            source: "Surah Al-Isra 17:24"
        ),
        
        // MARK: - Travel Duas
        
        DuaAfterPrayer(
            id: "dua-travel-1",
            name: "Dua When Starting a Journey",
            arabic: "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنقَلِبُونَ",
            transliteration: "Subhanalladhi sakhkhara lana hadha wa ma kunna lahu muqrinin wa inna ila Rabbina lamunqalibun",
            translation: "Glory be to Him who has subjected this to us, and we could never have it by our efforts. And to our Lord we shall surely return.",
            benefit: "Recited when boarding any means of transport — acknowledges Allah's blessing of travel",
            timesToRecite: 1,
            category: .travel,
            source: "Surah Az-Zukhruf 43:13-14"
        ),
        DuaAfterPrayer(
            id: "dua-travel-2",
            name: "Dua for Travel",
            arabic: "اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى وَمِنَ الْعَمَلِ مَا تَرْضَى",
            transliteration: "Allahumma inna nas'aluka fi safarina hadha al-birra wat-taqwa wa minal-'amali ma tarda",
            translation: "O Allah, we ask You in this journey of ours for righteousness, piety, and deeds which are pleasing to You.",
            benefit: "Comprehensive travel supplication taught by the Prophet ﷺ",
            timesToRecite: 1,
            category: .travel,
            source: "Sahih Muslim 1342",
            hadithCollection: "muslim",
            hadithNumber: 1342
        ),
        DuaAfterPrayer(
            id: "dua-travel-3",
            name: "Dua When Returning from Travel",
            arabic: "آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ",
            transliteration: "Ayibuna ta'ibuna 'abiduna li Rabbina hamidun",
            translation: "We return, repenting, worshipping, and praising our Lord.",
            benefit: "Said upon returning home safely from a journey",
            timesToRecite: 1,
            category: .travel,
            source: "Sahih al-Bukhari 1797",
            hadithCollection: "bukhari",
            hadithNumber: 1797
        ),
        DuaAfterPrayer(
            id: "dua-travel-4",
            name: "Dua When Entering a Town",
            arabic: "اللَّهُمَّ رَبَّ السَّمَاوَاتِ السَّبْعِ وَمَا أَظْلَلْنَ وَرَبَّ الْأَرَضِينَ السَّبْعِ وَمَا أَقْلَلْنَ أَسْأَلُكَ خَيْرَ هَذِهِ الْقَرْيَةِ وَخَيْرَ أَهْلِهَا",
            transliteration: "Allahumma Rabbas-samawatis-sab'i wa ma adhlaln, wa Rabbal-aradeenas-sab'i wa ma aqlal, as'aluka khayra hadhihil-qaryah wa khayra ahliha",
            translation: "O Allah, Lord of the seven heavens and all that they envelop, Lord of the seven earths and all that they carry, I ask You for the goodness of this town and the goodness of its people.",
            benefit: "Said when entering a new city or town for protection and blessings",
            timesToRecite: 1,
            category: .travel,
            source: "Mustadrak al-Hakim 2/100"
        ),
        
        // MARK: - Healing & Sickness Duas
        
        DuaAfterPrayer(
            id: "dua-healing-1",
            name: "Dua for Healing (General)",
            arabic: "اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ اشْفِ أَنْتَ الشَّافِي لاَ شِفَاءَ إِلاَّ شِفَاؤُكَ شِفَاءً لاَ يُغَادِرُ سَقَمًا",
            transliteration: "Allahumma Rabban-naas, adhibil-ba's, ishfi antash-Shafee la shifa'a illa shifa'uka shifa'an la yughadiru saqama",
            translation: "O Allah, Lord of mankind, remove the illness, cure the disease. You are the One Who cures. There is no cure except Your cure, a cure that leaves no illness.",
            benefit: "The Prophet ﷺ would recite this when visiting the sick — the most powerful healing dua",
            timesToRecite: 3,
            category: .healing,
            source: "Sahih al-Bukhari 5675",
            hadithCollection: "bukhari",
            hadithNumber: 5675
        ),
        DuaAfterPrayer(
            id: "dua-healing-2",
            name: "Dua When Visiting the Sick",
            arabic: "أَسْأَلُ اللَّهَ الْعَظِيمَ رَبَّ الْعَرْشِ الْعَظِيمِ أَنْ يَشْفِيَكَ",
            transliteration: "As'alullaahal-'Adheema Rabbal-'Arshil-'Adheemi an yashfiyak",
            translation: "I ask Allah the Almighty, Lord of the Magnificent Throne, to cure you.",
            benefit: "Recited 7 times when visiting the sick — the Prophet ﷺ said whoever recites this 7 times, Allah will cure them if their time has not yet come",
            timesToRecite: 7,
            category: .healing,
            source: "Abu Dawud 3106",
            hadithCollection: "abu-dawud",
            hadithNumber: 3106
        ),
        DuaAfterPrayer(
            id: "dua-healing-3",
            name: "Placing Hand on Pain",
            arabic: "بِسْمِ اللَّهِ ثَلاَثًا أَعُوذُ بِاللَّهِ وَقُدْرَتِهِ مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ",
            transliteration: "Bismillahi (three times), a'udhu billahi wa qudratihi min sharri ma ajidu wa uhadhiru",
            translation: "In the name of Allah (three times). I seek refuge in Allah and His Power from the evil of what I find and fear.",
            benefit: "Place your hand on the area of pain and say Bismillah three times, then recite this dua seven times",
            timesToRecite: 7,
            category: .healing,
            source: "Sahih Muslim 2202",
            hadithCollection: "muslim",
            hadithNumber: 2202
        ),
        DuaAfterPrayer(
            id: "dua-healing-4",
            name: "Dua for Relief from Anxiety",
            arabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ وَالْعَجْزِ وَالْكَسَلِ وَالْبُخْلِ وَالْجُبْنِ وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ",
            transliteration: "Allahumma inni a'udhu bika minal-hammi wal-hazani wal-'ajzi wal-kasali wal-bukhli wal-jubni wa dala'id-dayni wa ghalabatir-rijal",
            translation: "O Allah, I seek refuge in You from worry and grief, from helplessness and laziness, from miserliness and cowardice, from being overcome by debt and overpowered by men.",
            benefit: "One of the most comprehensive duas for mental health — covers anxiety, depression, laziness, and financial distress",
            timesToRecite: 1,
            category: .healing,
            source: "Sahih al-Bukhari 6369",
            hadithCollection: "bukhari",
            hadithNumber: 6369
        ),
        
        // MARK: - More Morning Adhkar
        
        DuaAfterPrayer(
            id: "dua-morning-5",
            name: "Morning Dua: Entering a New Day",
            arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ",
            transliteration: "Asbahna wa asbahal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah",
            translation: "We have reached the morning and at this very time the whole kingdom belongs to Allah. All praise is due to Allah. None has the right to be worshipped except Allah alone, without any partner.",
            benefit: "Comprehensive morning remembrance acknowledging Allah's sovereignty",
            timesToRecite: 1,
            category: .morningAdhkar,
            source: "Sahih Muslim 2723",
            hadithCollection: "muslim",
            hadithNumber: 2723
        ),
        DuaAfterPrayer(
            id: "dua-morning-6",
            name: "Morning Dua: Seeking Well-being",
            arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ",
            transliteration: "Allahumma inni as'alukal-'afwa wal-'afiyata fid-dunya wal-akhirah",
            translation: "O Allah, I ask You for pardon and well-being in this life and the next.",
            benefit: "The Prophet ﷺ never left this dua in the morning or evening",
            timesToRecite: 1,
            category: .morningAdhkar,
            source: "Sunan Ibn Majah 3871",
            hadithCollection: "ibnu-majah",
            hadithNumber: 3871
        ),
        
        // MARK: - More Evening Adhkar
        
        DuaAfterPrayer(
            id: "dua-evening-4",
            name: "Evening Dua: Seeking Refuge",
            arabic: "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            transliteration: "A'udhu bi kalimatillahit-tammati min sharri ma khalaq",
            translation: "I seek refuge in the perfect words of Allah from the evil of what He has created.",
            benefit: "Protection from every harm — especially recommended in the evening and when staying somewhere new",
            timesToRecite: 3,
            category: .eveningAdhkar,
            source: "Sahih Muslim 2708",
            hadithCollection: "muslim",
            hadithNumber: 2708
        ),
        DuaAfterPrayer(
            id: "dua-evening-5",
            name: "Evening Dua: Before Sleeping",
            arabic: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
            transliteration: "Bismika Allahumma amutu wa ahya",
            translation: "In Your name, O Allah, I die and I live.",
            benefit: "Said before sleeping — sleep is a minor death and waking is a rebirth",
            timesToRecite: 1,
            category: .eveningAdhkar,
            source: "Sahih al-Bukhari 6324",
            hadithCollection: "bukhari",
            hadithNumber: 6324
        ),
        
        // MARK: - More General Duas
        
        DuaAfterPrayer(
            id: "dua-general-6",
            name: "Dua for Knowledge",
            arabic: "رَبِّ زِدْنِي عِلْمًا",
            transliteration: "Rabbi zidni 'ilma",
            translation: "My Lord, increase me in knowledge.",
            benefit: "A concise Quranic dua that the Prophet ﷺ was commanded to recite",
            timesToRecite: 1,
            category: .general,
            source: "Surah Ta-Ha 20:114"
        ),
        DuaAfterPrayer(
            id: "dua-general-7",
            name: "Dua for Guidance",
            arabic: "اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي",
            transliteration: "Allahummah-dini wa saddidni",
            translation: "O Allah, guide me and keep me on the right path.",
            benefit: "A simple yet powerful dua asking Allah for guidance in all matters",
            timesToRecite: 1,
            category: .general,
            source: "Sahih Muslim 2725",
            hadithCollection: "muslim",
            hadithNumber: 2725
        ),
        DuaAfterPrayer(
            id: "dua-general-8",
            name: "Dua When Entering the Mosque",
            arabic: "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
            transliteration: "Allahummaf-tah li abwaba rahmatik",
            translation: "O Allah, open for me the doors of Your mercy.",
            benefit: "Recited when entering a mosque — seeking Allah's mercy in His house",
            timesToRecite: 1,
            category: .general,
            source: "Sahih Muslim 713",
            hadithCollection: "muslim",
            hadithNumber: 713
        ),
        DuaAfterPrayer(
            id: "dua-general-9",
            name: "Dua When Leaving the Mosque",
            arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ",
            transliteration: "Allahumma inni as'aluka min fadlik",
            translation: "O Allah, I ask You from Your bounty.",
            benefit: "Recited when leaving a mosque — asking for Allah's bounty in daily life",
            timesToRecite: 1,
            category: .general,
            source: "Sahih Muslim 713",
            hadithCollection: "muslim",
            hadithNumber: 713
        ),
        DuaAfterPrayer(
            id: "dua-general-10",
            name: "Dua Before Eating",
            arabic: "بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ",
            transliteration: "Bismillahi wa 'ala barakatillah",
            translation: "In the name of Allah and with the blessing of Allah.",
            benefit: "Mentioning Allah's name before eating brings barakah (blessing) to the food",
            timesToRecite: 1,
            category: .general,
            source: "Sunan Abu Dawud 3767",
            hadithCollection: "abu-dawud",
            hadithNumber: 3767
        ),
        DuaAfterPrayer(
            id: "dua-general-11",
            name: "Dua After Eating",
            arabic: "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلاَ قُوَّةٍ",
            transliteration: "Alhamdu lillahil-ladhi at'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah",
            translation: "All praise is due to Allah who fed me this and provided it for me without any might or power from myself.",
            benefit: "Whoever says this after eating, all their previous sins are forgiven",
            timesToRecite: 1,
            category: .general,
            source: "Sunan at-Tirmidhi 3458",
            hadithCollection: "tirmidzi",
            hadithNumber: 3458
        )
    ]
    
    /// Get duas filtered by category
    static func duas(for category: DuaCategory) -> [DuaAfterPrayer] {
        allDuas.filter { $0.category == category }
    }
}

extension PrayerMistake {
    static let commonMistakes: [PrayerMistake] = [
        // Wudu mistakes
        PrayerMistake(
            id: "mistake-1",
            title: "Incomplete Washing",
            description: "Not ensuring water reaches all required areas, especially between fingers and toes, elbows, and ankles.",
            correction: "Take your time and make sure water touches every part of the area being washed. Run fingers through to ensure water penetrates.",
            category: .wudu
        ),
        PrayerMistake(
            id: "mistake-2",
            title: "Wasting Water",
            description: "Using excessive water during wudu, which is discouraged in Islam.",
            correction: "The Prophet ﷺ performed wudu with just a mudd (about 500ml) of water. Use water efficiently.",
            category: .wudu
        ),
        PrayerMistake(
            id: "mistake-3",
            title: "Wrong Order",
            description: "Not following the correct sequence of wudu actions.",
            correction: "Follow the sequence: hands, mouth, nose, face, arms, head, ears, feet. Order is important in the Hanafi school.",
            category: .wudu
        ),
        // Salah mistakes
        PrayerMistake(
            id: "mistake-4",
            title: "Not Standing Still",
            description: "Moving or fidgeting during prayer, especially during standing (qiyam).",
            correction: "Stand still with focus. The Prophet ﷺ said to pray as you see me praying - with calmness and stillness.",
            category: .salah
        ),
        PrayerMistake(
            id: "mistake-5",
            title: "Rushing Through Prayer",
            description: "Performing prayer movements too quickly without proper pause and tranquility.",
            correction: "Each position should have a moment of stillness (tuma'neenah). The Prophet ﷺ told a man to repeat his prayer because he was too fast.",
            category: .salah
        ),
        PrayerMistake(
            id: "mistake-6",
            title: "Back Not Straight in Ruku",
            description: "Bowing with a curved back instead of keeping it straight and level.",
            correction: "In ruku, your back should be flat like a table. Head should be in line with the back, not raised or lowered.",
            category: .posture
        ),
        PrayerMistake(
            id: "mistake-7",
            title: "Elbows on Ground in Sujud",
            description: "Placing elbows on the ground during prostration.",
            correction: "Keep elbows raised off the ground during sujud. The Prophet ﷺ forbade spreading arms like a dog.",
            category: .posture
        ),
        PrayerMistake(
            id: "mistake-8",
            title: "Not Reciting Al-Fatiha Properly",
            description: "Missing verses, pronouncing incorrectly, or not completing the surah.",
            correction: "Learn Al-Fatiha with correct tajweed. Prayer is not valid without Al-Fatiha according to most scholars.",
            category: .recitation
        ),
        PrayerMistake(
            id: "mistake-9",
            title: "Looking Around",
            description: "Moving the eyes or looking sideways during prayer.",
            correction: "Keep your gaze on the place of sujud during standing, at your toes during sitting. The Prophet ﷺ warned against looking up.",
            category: .salah
        ),
        PrayerMistake(
            id: "mistake-10",
            title: "Forgetting Tasbeeh Count",
            description: "Not saying the tasbeeh the recommended number of times in ruku and sujud.",
            correction: "Say 'Subhana Rabbiyal Azeem' in ruku and 'Subhana Rabbiyal A'la' in sujud at least 3 times each.",
            category: .recitation
        )
    ]
}
