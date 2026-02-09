//
//  PrayerTimesCardView.swift
//  DeenLearn
//
//  Prayer times display card for HomeView
//

import SwiftUI

// MARK: - Prayer Times Card View

struct PrayerTimesCardView: View {
    @ObservedObject var prayerTimeService = PrayerTimeService.shared
    @ObservedObject var locationService = LocationService.shared
    @EnvironmentObject var appState: AppState
    @State private var showSettings = false
    @State private var hasRequestedLocation = false
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var primaryColor: Color {
        isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            // Prayer Times List
            if prayerTimeService.prayerTimes.isEmpty {
                loadingView
            } else {
                prayerTimesListView
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal)
        .onAppear {
            if !hasRequestedLocation {
                hasRequestedLocation = true
                locationService.requestLocation()
            }
            // Always calculate prayer times on appear
            // This ensures times are shown even if location was already available
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if prayerTimeService.prayerTimes.isEmpty {
                    prayerTimeService.calculatePrayerTimes()
                }
            }
        }
        .onChange(of: locationService.currentLocation) { _ in
            prayerTimeService.calculatePrayerTimes()
        }
        .onChange(of: locationService.authorizationStatus) { _ in
            // Also trigger calculation when authorization changes
            prayerTimeService.calculatePrayerTimes()
        }
        .sheet(isPresented: $showSettings) {
            PrayerSettingsView()
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(isKidsMode ? "🕌 Prayer Times" : "Prayer Times")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(locationService.locationName)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        if locationService.isLoading {
                            ProgressView()
                                .scaleEffect(0.6)
                                .tint(.white)
                        }
                    }
                }
                
                Spacer()
                
                // Settings button
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            // Next Prayer Countdown
            if let nextPrayer = prayerTimeService.nextPrayer {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Next Prayer")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        HStack(spacing: 8) {
                            Text(nextPrayer.name)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            
                            Text(nextPrayer.arabicName)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Time Left")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(prayerTimeService.timeUntilNextPrayer)
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .monospacedDigit()
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: isKidsMode 
                    ? [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")]
                    : [Color(hex: "1a5f4a"), Color(hex: "2d8b6e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Calculating prayer times...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(height: 200)
    }
    
    // MARK: - Prayer Times List
    
    private var prayerTimesListView: some View {
        VStack(spacing: 0) {
            ForEach(Array(prayerTimeService.prayerTimes.enumerated()), id: \.element.id) { index, prayer in
                PrayerTimeRow(
                    prayer: prayer,
                    isNext: prayer.id == prayerTimeService.nextPrayer?.id,
                    isPast: index < prayerTimeService.currentPrayerIndex + 1,
                    isKidsMode: isKidsMode,
                    primaryColor: primaryColor
                )
                
                if index < prayerTimeService.prayerTimes.count - 1 {
                    Divider()
                        .padding(.leading, 56)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Prayer Time Row

struct PrayerTimeRow: View {
    let prayer: PrayerTime
    let isNext: Bool
    let isPast: Bool
    let isKidsMode: Bool
    let primaryColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(isNext ? primaryColor : (isPast ? Color.gray.opacity(0.3) : Color(.systemGray5)))
                    .frame(width: 40, height: 40)
                
                Image(systemName: prayer.icon)
                    .font(.body)
                    .foregroundColor(isNext ? .white : (isPast ? .gray : primaryColor))
            }
            
            // Prayer Name
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 8) {
                    Text(prayer.name)
                        .font(.body)
                        .fontWeight(isNext ? .bold : .medium)
                        .foregroundColor(isPast ? .gray : .primary)
                    
                    Text(prayer.arabicName)
                        .font(.subheadline)
                        .foregroundColor(isPast ? .gray.opacity(0.7) : .secondary)
                }
                
                if isNext {
                    Text("Next Prayer")
                        .font(.caption2)
                        .foregroundColor(primaryColor)
                }
            }
            
            Spacer()
            
            // Time
            Text(prayer.formattedTime)
                .font(.body)
                .fontWeight(isNext ? .bold : .regular)
                .foregroundColor(isPast ? .gray : .primary)
                .monospacedDigit()
            
            // Checkmark for past prayers
            if isPast {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.body)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(isNext ? primaryColor.opacity(0.08) : Color.clear)
    }
}

// MARK: - Prayer Settings View

struct PrayerSettingsView: View {
    @ObservedObject var prayerTimeService = PrayerTimeService.shared
    @ObservedObject var locationService = LocationService.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                // Location Section
                Section {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Current Location")
                                .font(.subheadline)
                            Text(locationService.locationName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Refresh") {
                            locationService.requestLocation()
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
                    }
                    
                    if let error = locationService.error {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                } header: {
                    Text("Location")
                }
                
                // Calculation Method
                Section {
                    Picker("Calculation Method", selection: $prayerTimeService.calculationMethod) {
                        ForEach(CalculationMethod.allCases) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Calculation Method")
                } footer: {
                    Text("Different regions use different calculation methods. Choose the one commonly used in your area.")
                }
                
                // Asr Calculation
                Section {
                    Picker("Asr Calculation", selection: $prayerTimeService.asrMethod) {
                        ForEach(AsrJuristicMethod.allCases) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Juristic Method for Asr")
                } footer: {
                    Text("Standard: Shafi'i, Maliki, Hanbali\nHanafi: Later Asr time")
                }
                
                // Info Section
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Prayer times are calculated locally", systemImage: "info.circle")
                        Label("No internet required", systemImage: "wifi.slash")
                        Label("Accuracy: ±1-2 minutes", systemImage: "clock")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                } header: {
                    Text("Information")
                }
            }
            .navigationTitle("Prayer Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Compact Prayer Times Widget

struct CompactPrayerTimesWidget: View {
    @ObservedObject var prayerTimeService = PrayerTimeService.shared
    @ObservedObject var locationService = LocationService.shared
    @EnvironmentObject var appState: AppState
    @State private var hasRequestedLocation = false
    
    var isKidsMode: Bool {
        appState.userMode == .kids
    }
    
    var primaryColor: Color {
        isKidsMode ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e")
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Header with next prayer
            if let nextPrayer = prayerTimeService.nextPrayer {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(isKidsMode ? "🕌 Next Prayer" : "Next Prayer")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 6) {
                            Image(systemName: nextPrayer.icon)
                                .foregroundColor(primaryColor)
                            
                            Text(nextPrayer.name)
                                .font(.headline)
                            
                            Text(nextPrayer.arabicName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(nextPrayer.formattedTime)
                            .font(.headline)
                        
                        Text(prayerTimeService.timeUntilNextPrayer)
                            .font(.caption)
                            .foregroundColor(primaryColor)
                            .monospacedDigit()
                    }
                }
            } else {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading prayer times...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Quick view of all prayers
            HStack(spacing: 0) {
                ForEach(prayerTimeService.prayerTimes.prefix(5)) { prayer in
                    VStack(spacing: 4) {
                        Image(systemName: prayer.icon)
                            .font(.caption)
                            .foregroundColor(prayer.id == prayerTimeService.nextPrayer?.id ? primaryColor : .secondary)
                        
                        Text(prayer.name.prefix(3))
                            .font(.caption2)
                            .foregroundColor(prayer.id == prayerTimeService.nextPrayer?.id ? .primary : .secondary)
                        
                        Text(prayer.formattedTime.replacingOccurrences(of: " AM", with: "a").replacingOccurrences(of: " PM", with: "p"))
                            .font(.caption2)
                            .foregroundColor(prayer.id == prayerTimeService.nextPrayer?.id ? primaryColor : .secondary)
                            .monospacedDigit()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .padding(.horizontal)
        .onAppear {
            if !hasRequestedLocation {
                hasRequestedLocation = true
                locationService.requestLocation()
            }
            // Always calculate prayer times on appear
            // This ensures times are shown even if location was already available
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if prayerTimeService.prayerTimes.isEmpty {
                    prayerTimeService.calculatePrayerTimes()
                }
            }
        }
        .onChange(of: locationService.currentLocation) { _ in
            prayerTimeService.calculatePrayerTimes()
        }
        .onChange(of: locationService.authorizationStatus) { _ in
            // Also trigger calculation when authorization changes
            prayerTimeService.calculatePrayerTimes()
        }
    }
}

// MARK: - Preview

#Preview("Prayer Times Card - Kids") {
    PrayerTimesCardView()
        .environmentObject(AppState())
}

#Preview("Prayer Times Card - Adult") {
    let appState = AppState()
    appState.userMode = .adults
    return PrayerTimesCardView()
        .environmentObject(appState)
}

#Preview("Compact Widget") {
    CompactPrayerTimesWidget()
        .environmentObject(AppState())
}
