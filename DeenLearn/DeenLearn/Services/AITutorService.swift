import Foundation

// MARK: - AI Tutor Service
/// Provides AI-powered Islamic knowledge Q&A with age-appropriate responses
class AITutorService: ObservableObject {
    static let shared = AITutorService()
    
    @Published var isProcessing = false
    @Published var conversationHistory: [ChatMessage] = []
    
    private init() {}
    
    // MARK: - Chat Message Model
    struct ChatMessage: Identifiable {
        let id = UUID()
        let content: String
        let isUser: Bool
        let timestamp: Date
    }
    
    // MARK: - Topic Categories
    enum Topic: String, CaseIterable {
        case pillars = "Pillars of Islam"
        case salah = "Prayer (Salah)"
        case quran = "Qur'an"
        case arabic = "Arabic Language"
        case prophets = "Prophets & Stories"
        case manners = "Islamic Manners"
        case general = "General"
    }
    
    // MARK: - Get AI Response
    func getResponse(for question: String, topic: Topic = .general, isKidsMode: Bool) async -> String {
        await MainActor.run {
            isProcessing = true
            conversationHistory.append(ChatMessage(content: question, isUser: true, timestamp: Date()))
        }
        
        // Simulate AI processing delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let response = generateResponse(for: question, topic: topic, isKidsMode: isKidsMode)
        
        await MainActor.run {
            conversationHistory.append(ChatMessage(content: response, isUser: false, timestamp: Date()))
            isProcessing = false
        }
        
        return response
    }
    
    // MARK: - Generate Response Based on Topic and Mode
    private func generateResponse(for question: String, topic: Topic, isKidsMode: Bool) -> String {
        let lowercasedQuestion = question.lowercased()
        
        // Kids Mode responses
        if isKidsMode {
            return generateKidsResponse(for: lowercasedQuestion, topic: topic)
        }
        
        // Adult Mode responses
        return generateAdultResponse(for: lowercasedQuestion, topic: topic)
    }
    
    // MARK: - Kids Mode Responses
    private func generateKidsResponse(for question: String, topic: Topic) -> String {
        // Pillars of Islam
        if question.contains("shahada") || question.contains("declaration") {
            return "🌟 The Shahada is like making a promise to Allah! We say: 'There is no god but Allah, and Muhammad is His messenger.' It's the most special words a Muslim says! 💫"
        }
        
        if question.contains("prayer") || question.contains("salah") {
            return "🕌 Salah is when we talk to Allah 5 times every day! It's like having a special meeting with our best friend. We stand, bow, and put our head on the ground to show Allah how much we love Him! 🤲"
        }
        
        if question.contains("zakat") || question.contains("charity") {
            return "💝 Zakat is sharing with others! When we have lots of things, we give some to people who need help. It makes Allah happy and makes us feel good inside! 🎁"
        }
        
        if question.contains("ramadan") || question.contains("fasting") {
            return "🌙 Ramadan is a super special month! Muslims don't eat or drink during the day to remember how lucky we are. At night, we have yummy iftar with family! ⭐"
        }
        
        if question.contains("hajj") || question.contains("pilgrimage") {
            return "🕋 Hajj is a big adventure to Makkah! Muslims from all over the world go there to visit Allah's special house, the Kaaba. Everyone wears white clothes and walks around it together! 🌍"
        }
        
        if question.contains("quran") {
            return "📖 The Qur'an is Allah's special book! It has beautiful words that Allah sent to Prophet Muhammad ﷺ. When we read it, it's like getting a letter from Allah! 💌"
        }
        
        if question.contains("prophet") || question.contains("muhammad") {
            return "💚 Prophet Muhammad ﷺ is the best person ever! Allah chose him to teach people how to be good. He was kind to everyone, even animals! We try to be like him every day! 🌟"
        }
        
        if question.contains("allah") || question.contains("god") {
            return "✨ Allah is the One who made everything - the sky, the stars, you, and me! Allah loves us more than anyone else and always takes care of us. We can talk to Allah anytime through prayer! 🤲"
        }
        
        if question.contains("wudu") || question.contains("ablution") {
            return "💧 Wudu is getting clean before talking to Allah! We wash our hands, mouth, nose, face, arms, head, and feet. It's like putting on special clean clothes before meeting someone important! 🚿"
        }
        
        // Default response for kids
        return "⭐ That's a great question! Islam teaches us to be kind, honest, and helpful. Allah loves children who ask questions and want to learn more! Keep being curious! 💫"
    }
    
    // MARK: - Adult Mode Responses
    private func generateAdultResponse(for question: String, topic: Topic) -> String {
        // Pillars of Islam
        if question.contains("shahada") || question.contains("declaration") {
            return """
            The Shahada (الشهادة) is the declaration of faith and the first pillar of Islam.
            
            It consists of two parts:
            1. "Lā ilāha illā Allāh" - There is no deity worthy of worship except Allah
            2. "Muḥammadun rasūlu Allāh" - Muhammad is the messenger of Allah
            
            This testimony affirms the oneness of Allah (Tawhid) and the prophethood of Muhammad ﷺ. Sincere recitation of the Shahada with understanding and conviction is the entry point into Islam.
            
            Reference: "The Prophet ﷺ said: 'Islam is built upon five pillars...'" (Bukhari & Muslim)
            """
        }
        
        if question.contains("prayer") || question.contains("salah") {
            return """
            Salah (الصلاة) is the second pillar of Islam and consists of five daily obligatory prayers:
            
            1. Fajr - Dawn prayer (2 rak'at)
            2. Dhuhr - Noon prayer (4 rak'at)
            3. Asr - Afternoon prayer (4 rak'at)
            4. Maghrib - Sunset prayer (3 rak'at)
            5. Isha - Night prayer (4 rak'at)
            
            Prerequisites include: ritual purity (wudu), proper intention (niyyah), facing the qiblah, and appropriate covering.
            
            The prayer includes recitation of Surah Al-Fatihah, bowing (ruku'), prostration (sujud), and the final sitting (tashahhud).
            
            Reference: "Indeed, prayer has been decreed upon the believers at specified times." (Qur'an 4:103)
            """
        }
        
        if question.contains("zakat") || question.contains("charity") {
            return """
            Zakat (الزكاة) is the third pillar of Islam - the obligatory charity.
            
            Key aspects:
            • Rate: Generally 2.5% on wealth held for one lunar year
            • Nisab: Minimum threshold (approximately 85g of gold or 595g of silver)
            • Types: Includes gold, silver, cash, business goods, agricultural produce, livestock
            
            Eight categories of recipients (Qur'an 9:60):
            1. The poor (al-fuqara)
            2. The needy (al-masakin)
            3. Zakat administrators
            4. Those whose hearts are to be reconciled
            5. Freeing slaves
            6. Those in debt
            7. In the cause of Allah
            8. Travelers in need
            
            Reference: "And establish prayer and give zakat..." (Qur'an 2:43)
            """
        }
        
        if question.contains("ramadan") || question.contains("fasting") {
            return """
            Sawm (الصوم) - Fasting during Ramadan is the fourth pillar of Islam.
            
            Requirements:
            • Complete abstinence from food, drink, and marital relations from dawn to sunset
            • Required for every sane, adult Muslim
            • Exemptions: illness, travel, menstruation, pregnancy/nursing (with makeup days)
            
            Spiritual objectives:
            • Developing taqwa (God-consciousness)
            • Self-discipline and empathy
            • Increased devotion and Qur'an recitation
            
            Special nights: Laylatul Qadr (Night of Decree) in the last ten nights
            
            Reference: "O you who believe! Fasting is prescribed for you as it was prescribed for those before you, that you may attain taqwa." (Qur'an 2:183)
            """
        }
        
        if question.contains("hajj") || question.contains("pilgrimage") {
            return """
            Hajj (الحج) is the fifth pillar of Islam - the pilgrimage to Makkah.
            
            Obligation: Once in a lifetime for those physically and financially able.
            
            Main rituals:
            1. Ihram - Sacred state with specific garments
            2. Tawaf - Circumambulation of the Ka'bah (7 times)
            3. Sa'i - Walking between Safa and Marwah (7 times)
            4. Standing at Arafat - The most essential pillar
            5. Muzdalifah - Overnight stay and collection of pebbles
            6. Stoning of the Jamarat - Symbolic rejection of Satan
            7. Sacrifice (Qurbani/Udhiyah)
            8. Farewell Tawaf
            
            Reference: "And [due] to Allah from the people is a pilgrimage to the House - for whoever is able to find thereto a way." (Qur'an 3:97)
            """
        }
        
        // Default response for adults
        return """
        Thank you for your question about Islamic knowledge.
        
        Islam is a comprehensive way of life based on:
        • The Qur'an - The final revelation from Allah
        • The Sunnah - The teachings and practices of Prophet Muhammad ﷺ
        
        The foundation rests on the Five Pillars:
        1. Shahada (Declaration of Faith)
        2. Salah (Prayer)
        3. Zakat (Obligatory Charity)
        4. Sawm (Fasting in Ramadan)
        5. Hajj (Pilgrimage)
        
        For detailed scholarly guidance on specific issues, consulting qualified scholars is recommended.
        """
    }
    
    // MARK: - Clear Conversation
    func clearConversation() {
        conversationHistory.removeAll()
    }
}
