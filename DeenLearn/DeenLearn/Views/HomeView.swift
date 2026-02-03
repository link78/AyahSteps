//
//  HomeView.swift
//  DeenLearn
//
//  Home screen with daily content and quick actions
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var primaryColor: Color {
        isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e")
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning!"
        case 12..<17:
            return "Good Afternoon!"
        case 17..<21:
            return "Good Evening!"
        default:
            return "Assalamu Alaikum!"
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Card
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(greeting)
                                    .font(isKidsMode ? .title2.bold() : .title3)
                                    .foregroundColor(.white)
                                
                                Text("السلام عليكم")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            // Streak badge
                            VStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.title)
                                    .foregroundColor(.orange)
                                Text("\(appState.currentStreak)")
                                    .font(.caption.bold())
                                    .foregroundColor(.white)
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                        }
                        
                        // Daily reminder
                        HStack(spacing: 12) {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(isKidsMode ? "Time to learn something new! 📚" : "Continue your learning journey")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                            
                            Spacer()
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(10)
                    }
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: isKidsMode ? 
                                [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")] :
                                [Color(hex: "1a5f4a"), Color(hex: "2d8b6e")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text(isKidsMode ? "🌟 Quick Start" : "Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                QuickActionCard(
                                    title: "Wudu",
                                    titleArabic: "الوضوء",
                                    icon: "drop.fill",
                                    color: .blue,
                                    isKidsMode: isKidsMode
                                )
                                
                                QuickActionCard(
                                    title: "Salah",
                                    titleArabic: "الصلاة",
                                    icon: "person.fill",
                                    color: .green,
                                    isKidsMode: isKidsMode
                                )
                                
                                QuickActionCard(
                                    title: "Quran",
                                    titleArabic: "القرآن",
                                    icon: "book.fill",
                                    color: .purple,
                                    isKidsMode: isKidsMode
                                )
                                
                                QuickActionCard(
                                    title: "Dua",
                                    titleArabic: "الدعاء",
                                    icon: "hands.sparkles.fill",
                                    color: .orange,
                                    isKidsMode: isKidsMode
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Daily Ayah
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(isKidsMode ? "📖 Today's Ayah" : "Ayah of the Day")
                                .font(.headline)
                            Spacer()
                        }
                        
                        VStack(spacing: 16) {
                            Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                                .font(.system(size: isKidsMode ? 24 : 28))
                                .multilineTextAlignment(.center)
                                .foregroundColor(primaryColor)
                            
                            Text("In the name of Allah, the Most Gracious, the Most Merciful")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Text("Al-Fatiha 1:1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                    }
                    .padding(.horizontal)
                    
                    // Points Display (for Kids)
                    if isKidsMode {
                        HStack(spacing: 20) {
                            StatCard(
                                title: "Points",
                                value: "\(appState.totalPoints)",
                                icon: "star.fill",
                                color: .yellow
                            )
                            
                            StatCard(
                                title: "Lessons",
                                value: "\(appState.completedLessons.count)",
                                icon: "checkmark.circle.fill",
                                color: .green
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(isKidsMode ? "🏠 Home" : "Home")
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let titleArabic: String
    let icon: String
    let color: Color
    let isKidsMode: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(isKidsMode ? .headline : .subheadline)
                    .fontWeight(.semibold)
                
                Text(titleArabic)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 100, height: 130)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title2.bold())
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
