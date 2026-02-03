//
//  QuranView.swift
//  DeenLearn
//
//  Dedicated Quran learning section
//

import SwiftUI

struct QuranView: View {
    @EnvironmentObject var appState: AppState
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    let surahs: [(number: Int, name: String, arabic: String, verses: Int, meaning: String)] = [
        (1, "Al-Fatiha", "الفاتحة", 7, "The Opening"),
        (112, "Al-Ikhlas", "الإخلاص", 4, "The Sincerity"),
        (113, "Al-Falaq", "الفلق", 5, "The Daybreak"),
        (114, "An-Nas", "الناس", 6, "Mankind"),
        (110, "An-Nasr", "النصر", 3, "The Help"),
        (108, "Al-Kawthar", "الكوثر", 3, "The Abundance"),
        (107, "Al-Ma'un", "الماعون", 7, "The Small Kindnesses"),
        (106, "Quraysh", "قريش", 4, "Quraysh"),
        (105, "Al-Fil", "الفيل", 5, "The Elephant"),
        (103, "Al-Asr", "العصر", 3, "The Time")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Card
                    VStack(spacing: 16) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        Text("القرآن الكريم")
                            .font(.title)
                            .foregroundColor(.white)
                        
                        Text("The Noble Quran")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(isKidsMode ? "Start with short surahs and build your way up! 📖" : "Begin your journey with commonly memorized surahs")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "6B5B95"), Color(hex: "8E7CC3")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Surah List
                    VStack(alignment: .leading, spacing: 16) {
                        Text(isKidsMode ? "🌟 Surahs to Memorize" : "Essential Surahs")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(surahs, id: \.number) { surah in
                            SurahCard(
                                number: surah.number,
                                name: surah.name,
                                arabic: surah.arabic,
                                verses: surah.verses,
                                meaning: surah.meaning,
                                isKidsMode: isKidsMode
                            )
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(isKidsMode ? "📖 Quran" : "Quran")
        }
    }
}

struct SurahCard: View {
    let number: Int
    let name: String
    let arabic: String
    let verses: Int
    let meaning: String
    let isKidsMode: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Surah Number
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "6B5B95").opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Text("\(number)")
                    .font(.headline)
                    .foregroundColor(Color(hex: "6B5B95"))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(arabic)
                        .font(.title3)
                        .foregroundColor(Color(hex: "6B5B95"))
                }
                
                HStack {
                    Text(meaning)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(verses) verses")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview {
    QuranView()
        .environmentObject(AppState())
}
