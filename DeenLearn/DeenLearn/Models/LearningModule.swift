//
//  LearningModule.swift
//  DeenLearn
//
//  Learning module data models
//

import SwiftUI

struct LearningModule: Identifiable {
    let id: String
    let title: String
    let titleArabic: String
    let description: String
    let icon: String
    let color: Color
    let lessons: [Lesson]
    let forKids: Bool
    let forAdults: Bool
}

struct Lesson: Identifiable {
    let id: String
    let title: String
    let description: String
    let content: LessonContent
    let duration: Int // in minutes
}

enum LessonContent {
    case text(String)
    case steps([LessonStep])
    case quran(QuranLesson)
}

struct LessonStep: Identifiable {
    let id: String
    let stepNumber: Int
    let title: String
    let description: String
    let imageName: String?
}

struct QuranLesson {
    let surahNumber: Int
    let surahName: String
    let surahNameArabic: String
    let verses: [QuranVerse]
}

struct QuranVerse: Identifiable {
    let id: Int
    let arabic: String
    let transliteration: String
    let translation: String
}

// MARK: - Sample Data

extension LearningModule {
    static let sampleModules: [LearningModule] = [
        // Wudu Module
        LearningModule(
            id: "wudu",
            title: "Wudu",
            titleArabic: "الوضوء",
            description: "Learn how to perform ablution before prayer",
            icon: "drop.fill",
            color: .blue,
            lessons: [
                Lesson(
                    id: "wudu-intro",
                    title: "What is Wudu?",
                    description: "Introduction to ablution",
                    content: .text("Wudu (ablution) is the Islamic ritual washing performed before prayers. It purifies the body and prepares the mind for worship. The Prophet ﷺ said: 'Cleanliness is half of faith.'"),
                    duration: 3
                ),
                Lesson(
                    id: "wudu-steps",
                    title: "Steps of Wudu",
                    description: "Learn the complete steps",
                    content: .steps([
                        LessonStep(id: "w1", stepNumber: 1, title: "Intention (Niyyah)", description: "Make the intention in your heart to perform wudu for purification", imageName: nil),
                        LessonStep(id: "w2", stepNumber: 2, title: "Say Bismillah", description: "Begin by saying 'Bismillah' (In the name of Allah)", imageName: nil),
                        LessonStep(id: "w3", stepNumber: 3, title: "Wash Hands", description: "Wash both hands up to the wrists three times", imageName: nil),
                        LessonStep(id: "w4", stepNumber: 4, title: "Rinse Mouth", description: "Take water into your mouth and rinse three times", imageName: nil),
                        LessonStep(id: "w5", stepNumber: 5, title: "Clean Nose", description: "Sniff water into your nose and blow it out three times", imageName: nil),
                        LessonStep(id: "w6", stepNumber: 6, title: "Wash Face", description: "Wash your entire face three times", imageName: nil),
                        LessonStep(id: "w7", stepNumber: 7, title: "Wash Arms", description: "Wash both arms up to the elbows three times, starting with the right", imageName: nil),
                        LessonStep(id: "w8", stepNumber: 8, title: "Wipe Head", description: "Wipe your head with wet hands once", imageName: nil),
                        LessonStep(id: "w9", stepNumber: 9, title: "Clean Ears", description: "Wipe inside and behind your ears with wet fingers", imageName: nil),
                        LessonStep(id: "w10", stepNumber: 10, title: "Wash Feet", description: "Wash both feet up to the ankles three times, starting with the right", imageName: nil)
                    ]),
                    duration: 10
                )
            ],
            forKids: true,
            forAdults: true
        ),
        
        // Salah Module
        LearningModule(
            id: "salah",
            title: "Salah",
            titleArabic: "الصلاة",
            description: "Learn the five daily prayers",
            icon: "person.fill",
            color: .green,
            lessons: [
                Lesson(
                    id: "salah-intro",
                    title: "Importance of Salah",
                    description: "Why we pray five times a day",
                    content: .text("Salah (prayer) is the second pillar of Islam and the most important act of worship. Allah says in the Quran: 'Indeed, prayer prohibits immorality and wrongdoing' (29:45). The five daily prayers connect us with Allah throughout the day."),
                    duration: 5
                ),
                Lesson(
                    id: "salah-times",
                    title: "Prayer Times",
                    description: "Learn the five prayer times",
                    content: .steps([
                        LessonStep(id: "s1", stepNumber: 1, title: "Fajr (الفجر)", description: "Dawn prayer - from true dawn until sunrise", imageName: nil),
                        LessonStep(id: "s2", stepNumber: 2, title: "Dhuhr (الظهر)", description: "Noon prayer - from when the sun passes its zenith until mid-afternoon", imageName: nil),
                        LessonStep(id: "s3", stepNumber: 3, title: "Asr (العصر)", description: "Afternoon prayer - from mid-afternoon until sunset", imageName: nil),
                        LessonStep(id: "s4", stepNumber: 4, title: "Maghrib (المغرب)", description: "Sunset prayer - from sunset until the red glow disappears", imageName: nil),
                        LessonStep(id: "s5", stepNumber: 5, title: "Isha (العشاء)", description: "Night prayer - from when the red glow disappears until midnight", imageName: nil)
                    ]),
                    duration: 8
                )
            ],
            forKids: true,
            forAdults: true
        ),
        
        // Quran Module
        LearningModule(
            id: "quran",
            title: "Quran",
            titleArabic: "القرآن",
            description: "Learn to recite the Holy Quran",
            icon: "book.fill",
            color: .purple,
            lessons: [
                Lesson(
                    id: "quran-fatiha",
                    title: "Surah Al-Fatiha",
                    description: "The Opening Chapter",
                    content: .quran(QuranLesson(
                        surahNumber: 1,
                        surahName: "Al-Fatiha",
                        surahNameArabic: "الفاتحة",
                        verses: [
                            QuranVerse(id: 1, arabic: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", transliteration: "Bismillahir Rahmanir Raheem", translation: "In the name of Allah, the Most Gracious, the Most Merciful"),
                            QuranVerse(id: 2, arabic: "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", transliteration: "Alhamdu lillahi Rabbil 'aalameen", translation: "All praise is due to Allah, Lord of the worlds"),
                            QuranVerse(id: 3, arabic: "الرَّحْمَٰنِ الرَّحِيمِ", transliteration: "Ar-Rahmanir-Raheem", translation: "The Most Gracious, the Most Merciful"),
                            QuranVerse(id: 4, arabic: "مَالِكِ يَوْمِ الدِّينِ", transliteration: "Maliki yawmid-Deen", translation: "Master of the Day of Judgment"),
                            QuranVerse(id: 5, arabic: "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", transliteration: "Iyyaka na'budu wa iyyaka nasta'een", translation: "You alone we worship, and You alone we ask for help"),
                            QuranVerse(id: 6, arabic: "اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ", transliteration: "Ihdinas-Siratal-Mustaqeem", translation: "Guide us to the straight path"),
                            QuranVerse(id: 7, arabic: "صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ", transliteration: "Siratal-ladhina an'amta 'alayhim ghayril-maghdubi 'alayhim wa lad-dalleen", translation: "The path of those upon whom You have bestowed favor, not of those who have earned [Your] anger or of those who are astray")
                        ]
                    )),
                    duration: 15
                )
            ],
            forKids: true,
            forAdults: true
        ),
        
        // Islamic Manners (Kids focused)
        LearningModule(
            id: "manners",
            title: "Good Manners",
            titleArabic: "الأخلاق",
            description: "Learn Islamic manners and etiquette",
            icon: "heart.fill",
            color: .pink,
            lessons: [
                Lesson(
                    id: "manners-eating",
                    title: "Eating Manners",
                    description: "How to eat like a Muslim",
                    content: .steps([
                        LessonStep(id: "m1", stepNumber: 1, title: "Say Bismillah", description: "Always say 'Bismillah' before eating", imageName: nil),
                        LessonStep(id: "m2", stepNumber: 2, title: "Eat with Right Hand", description: "Use your right hand to eat", imageName: nil),
                        LessonStep(id: "m3", stepNumber: 3, title: "Eat What's Near", description: "Eat from the food closest to you", imageName: nil),
                        LessonStep(id: "m4", stepNumber: 4, title: "Don't Waste", description: "Never waste food - take only what you can eat", imageName: nil),
                        LessonStep(id: "m5", stepNumber: 5, title: "Say Alhamdulillah", description: "Say 'Alhamdulillah' after finishing", imageName: nil)
                    ]),
                    duration: 5
                )
            ],
            forKids: true,
            forAdults: false
        ),
        
        // Pillars of Islam (Adults focused)
        LearningModule(
            id: "pillars",
            title: "Pillars of Islam",
            titleArabic: "أركان الإسلام",
            description: "Deep dive into the five pillars",
            icon: "building.columns.fill",
            color: .orange,
            lessons: [
                Lesson(
                    id: "pillars-overview",
                    title: "The Five Pillars",
                    description: "Foundation of Islamic practice",
                    content: .steps([
                        LessonStep(id: "p1", stepNumber: 1, title: "Shahada (الشهادة)", description: "Declaration of faith: 'There is no god but Allah, and Muhammad is His messenger'", imageName: nil),
                        LessonStep(id: "p2", stepNumber: 2, title: "Salah (الصلاة)", description: "Five daily prayers that maintain the connection with Allah", imageName: nil),
                        LessonStep(id: "p3", stepNumber: 3, title: "Zakat (الزكاة)", description: "Obligatory charity of 2.5% of wealth given annually", imageName: nil),
                        LessonStep(id: "p4", stepNumber: 4, title: "Sawm (الصوم)", description: "Fasting during the month of Ramadan from dawn to sunset", imageName: nil),
                        LessonStep(id: "p5", stepNumber: 5, title: "Hajj (الحج)", description: "Pilgrimage to Makkah once in a lifetime if able", imageName: nil)
                    ]),
                    duration: 20
                )
            ],
            forKids: false,
            forAdults: true
        )
    ]
    
    static func modulesFor(mode: UserMode) -> [LearningModule] {
        sampleModules.filter { module in
            switch mode {
            case .kids:
                return module.forKids
            case .adults:
                return module.forAdults
            }
        }
    }
}
