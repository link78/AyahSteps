//
//  WelcomeView.swift
//  DeenLearn
//
//  Welcome screen for user mode selection
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingModeSelection = false
    
    var body: some View {
        ZStack {
            // Beautiful gradient background
            LinearGradient(
                colors: [Color(hex: "1a5f4a"), Color(hex: "2d8b6e"), Color(hex: "3eb489")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // App Logo and Title
                VStack(spacing: 20) {
                    // Crescent and star symbol
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 140, height: 140)
                        
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 70))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, Color(hex: "ffd700")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    
                    VStack(spacing: 8) {
                        Text("DeenLearn")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("دين لرن")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("Islamic Learning for Everyone")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 4)
                    }
                }
                
                Spacer()
                
                // Mode Selection Buttons
                VStack(spacing: 16) {
                    Text("I am learning as...")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    // Kids Mode Button
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            appState.userMode = .kids
                        }
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "face.smiling.fill")
                                .font(.system(size: 32))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Kids Mode")
                                    .font(.title2.bold())
                                Text("Fun & colorful learning")
                                    .font(.subheadline)
                                    .opacity(0.8)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                        }
                        .foregroundColor(Color(hex: "1a5f4a"))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    }
                    
                    // Adults Mode Button
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            appState.userMode = .adults
                        }
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Adults Mode")
                                    .font(.title2.bold())
                                Text("In-depth Islamic knowledge")
                                    .font(.subheadline)
                                    .opacity(0.8)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.title3)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Footer
                VStack(spacing: 8) {
                    Text("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("In the name of Allah, the Most Gracious, the Most Merciful")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppState())
}
