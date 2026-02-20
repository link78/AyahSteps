//
//  QiblaCompassView.swift
//  DeenLearn
//
//  Qibla compass with automatic geolocation and real-time heading
//

import SwiftUI
import CoreLocation

// MARK: - Heading Manager

class HeadingManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var heading: Double = 0
    @Published var isAvailable = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        if CLLocationManager.headingAvailable() {
            isAvailable = true
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy >= 0 {
            heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        }
    }
    
    deinit {
        locationManager.stopUpdatingHeading()
    }
}

// MARK: - Qibla Compass View

struct QiblaCompassView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var headingManager = HeadingManager()
    @StateObject private var locationService = LocationService.shared
    @StateObject private var islamicAPI = IslamicAPIService.shared
    
    @State private var qiblaAngle: Double = 0
    @State private var distanceToKaaba: Double = 0
    @State private var isAligned = false
    
    private let kaabaLocation = CLLocation(latitude: 21.4225, longitude: 39.8262)
    
    private var primaryColor: Color {
        appState.userMode == .kids ? Color(hex: "FF6B6B") : Color(hex: "2d8b6e")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DeviceLayout.scaled(20)) {
                    locationHeader
                    compassSection
                    infoCards
                    if !headingManager.isAvailable {
                        calibrationNotice
                    }
                }
                .padding(DeviceLayout.scaled(16))
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Qibla Compass")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { fetchQiblaDirection() }
            .onChange(of: locationService.currentLocation) { _ in fetchQiblaDirection() }
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Location Header
    
    private var locationHeader: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundColor(primaryColor)
            VStack(alignment: .leading, spacing: 2) {
                Text(locationService.locationName)
                    .font(.headline)
                if let loc = locationService.currentLocation {
                    Text("\(String(format: "%.4f", loc.coordinate.latitude))°, \(String(format: "%.4f", loc.coordinate.longitude))°")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            if locationService.isUsingDefaultLocation {
                Button {
                    locationService.requestLocation()
                } label: {
                    Label("Detect", systemImage: "location.circle")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(primaryColor.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding(DeviceLayout.scaled(16))
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(DeviceLayout.scaled(12))
    }
    
    // MARK: - Compass Section
    
    private var compassSection: some View {
        VStack(spacing: DeviceLayout.scaled(16)) {
            ZStack {
                // Compass background
                Circle()
                    .fill(Color(.secondarySystemGroupedBackground))
                    .frame(width: DeviceLayout.scaled(280), height: DeviceLayout.scaled(280))
                    .shadow(color: .black.opacity(0.1), radius: 10)
                
                // Compass rose with cardinal directions
                compassRose
                    .rotationEffect(.degrees(-headingManager.heading))
                
                // Qibla direction indicator
                qiblaIndicator
                    .rotationEffect(.degrees(qiblaAngle - headingManager.heading))
                
                // Center point
                Circle()
                    .fill(primaryColor)
                    .frame(width: DeviceLayout.scaled(12), height: DeviceLayout.scaled(12))
                
                // North indicator (fixed at top)
                VStack {
                    Text("N")
                        .font(.caption.bold())
                        .foregroundColor(.red)
                        .offset(y: -DeviceLayout.scaled(150))
                    Spacer()
                }
                .frame(height: DeviceLayout.scaled(300))
            }
            .frame(width: DeviceLayout.scaled(300), height: DeviceLayout.scaled(300))
            .animation(.easeInOut(duration: 0.3), value: headingManager.heading)
            
            // Alignment indicator
            alignmentStatus
            
            // Direction readout
            HStack(spacing: DeviceLayout.scaled(20)) {
                VStack {
                    Text("Heading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(headingManager.isAvailable ? "\(String(format: "%.0f", headingManager.heading))°" : "--")
                        .font(.title3.monospacedDigit().bold())
                }
                
                Divider().frame(height: 30)
                
                VStack {
                    Text("Qibla")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(String(format: "%.1f", qiblaAngle))°")
                        .font(.title3.monospacedDigit().bold())
                        .foregroundColor(primaryColor)
                }
                
                Divider().frame(height: 30)
                
                VStack {
                    Text("Distance")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formattedDistance)
                        .font(.title3.monospacedDigit().bold())
                }
            }
            .padding(DeviceLayout.scaled(12))
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(DeviceLayout.scaled(12))
        }
    }
    
    // MARK: - Compass Rose
    
    private var compassRose: some View {
        ZStack {
            // Degree markers
            ForEach(0..<36) { i in
                Rectangle()
                    .fill(i % 9 == 0 ? Color.primary : Color.secondary.opacity(0.3))
                    .frame(width: i % 9 == 0 ? 2 : 1, height: i % 9 == 0 ? 15 : 8)
                    .offset(y: -DeviceLayout.scaled(130))
                    .rotationEffect(.degrees(Double(i) * 10))
            }
            
            // Cardinal direction labels
            ForEach(Array(["N", "E", "S", "W"].enumerated()), id: \.offset) { index, label in
                Text(label)
                    .font(.caption.bold())
                    .foregroundColor(label == "N" ? .red : .primary)
                    .offset(y: -DeviceLayout.scaled(112))
                    .rotationEffect(.degrees(Double(index) * 90))
            }
        }
    }
    
    // MARK: - Qibla Indicator
    
    private var qiblaIndicator: some View {
        VStack(spacing: 0) {
            // Kaaba icon at the tip
            ZStack {
                Circle()
                    .fill(isAligned ? Color.green : primaryColor)
                    .frame(width: DeviceLayout.scaled(36), height: DeviceLayout.scaled(36))
                
                Text("🕋")
                    .font(.system(size: DeviceLayout.scaled(20)))
            }
            .offset(y: -DeviceLayout.scaled(100))
            
            // Direction line
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [isAligned ? .green : primaryColor, .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 3, height: DeviceLayout.scaled(80))
                .offset(y: -DeviceLayout.scaled(60))
        }
    }
    
    // MARK: - Alignment Status
    
    private var alignmentStatus: some View {
        Group {
            if headingManager.isAvailable {
                let diff = abs(normalizeAngle(qiblaAngle - headingManager.heading))
                let aligned = diff < 5
                
                HStack {
                    Image(systemName: aligned ? "checkmark.circle.fill" : "arrow.triangle.turn.up.right.circle")
                        .foregroundColor(aligned ? .green : .orange)
                    Text(aligned ? "You are facing the Qibla! 🕋" : "Turn \(turnDirection) to face Qibla")
                        .font(.subheadline.bold())
                        .foregroundColor(aligned ? .green : .primary)
                }
                .padding(DeviceLayout.scaled(12))
                .frame(maxWidth: .infinity)
                .background((aligned ? Color.green : Color.orange).opacity(0.1))
                .cornerRadius(DeviceLayout.scaled(10))
                .onAppear { isAligned = aligned }
                .onChange(of: headingManager.heading) { _ in
                    let d = abs(normalizeAngle(qiblaAngle - headingManager.heading))
                    withAnimation { isAligned = d < 5 }
                }
            } else {
                HStack {
                    Image(systemName: "safari")
                        .foregroundColor(primaryColor)
                    Text("Qibla is \(String(format: "%.1f", qiblaAngle))° from North 🕋")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)
                }
                .padding(DeviceLayout.scaled(12))
                .frame(maxWidth: .infinity)
                .background(primaryColor.opacity(0.1))
                .cornerRadius(DeviceLayout.scaled(10))
            }
        }
    }
    
    // MARK: - Info Cards
    
    private var infoCards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: DeviceLayout.scaled(140)))], spacing: DeviceLayout.scaled(12)) {
            infoCard(icon: "building.columns.fill", title: "Kaaba", value: "Mecca, Saudi Arabia", color: .brown)
            infoCard(icon: "mappin.and.ellipse", title: "Your Location", value: locationService.locationName, color: primaryColor)
            infoCard(icon: "safari", title: "Bearing", value: "\(String(format: "%.1f", qiblaAngle))°", color: .blue)
            infoCard(icon: "ruler", title: "Distance", value: formattedDistance, color: .purple)
        }
    }
    
    private func infoCard(icon: String, title: String, value: String, color: Color) -> some View {
        VStack(spacing: DeviceLayout.scaled(8)) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline.bold())
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: DeviceLayout.scaled(100))
        .padding(DeviceLayout.scaled(12))
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(DeviceLayout.scaled(12))
    }
    
    // MARK: - Calibration Notice
    
    private var calibrationNotice: some View {
        VStack(spacing: 8) {
            Image(systemName: "info.circle.fill")
                .font(.title2)
                .foregroundColor(primaryColor)
            Text("Static Qibla Direction")
                .font(.headline)
            Text("Live compass rotation requires a magnetometer. The Qibla bearing is calculated from your location and is accurate.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(DeviceLayout.scaled(16))
        .frame(maxWidth: .infinity)
        .background(primaryColor.opacity(0.1))
        .cornerRadius(DeviceLayout.scaled(12))
    }
    
    // MARK: - Helpers
    
    private var turnDirection: String {
        let diff = normalizeAngle(qiblaAngle - headingManager.heading)
        return diff > 0 ? "right" : "left"
    }
    
    private var formattedDistance: String {
        if distanceToKaaba > 1000 {
            return "\(String(format: "%.0f", distanceToKaaba / 1000)) km"
        }
        return "\(String(format: "%.0f", distanceToKaaba)) m"
    }
    
    private func normalizeAngle(_ angle: Double) -> Double {
        var normalized = angle.truncatingRemainder(dividingBy: 360)
        if normalized > 180 { normalized -= 360 }
        if normalized < -180 { normalized += 360 }
        return normalized
    }
    
    private func fetchQiblaDirection() {
        let location = locationService.bestLocation
        
        // Calculate distance to Kaaba
        let userLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        distanceToKaaba = userLocation.distance(from: kaabaLocation)
        
        // Calculate Qibla bearing using great circle formula
        let lat1 = location.coordinate.latitude * .pi / 180
        let lon1 = location.coordinate.longitude * .pi / 180
        let lat2 = kaabaLocation.coordinate.latitude * .pi / 180
        let lon2 = kaabaLocation.coordinate.longitude * .pi / 180
        
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        var bearing = atan2(y, x) * 180 / .pi
        if bearing < 0 { bearing += 360 }
        
        qiblaAngle = bearing
        
        // Also fetch from API for verification
        Task {
            await islamicAPI.fetchQiblaDirection(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            if let apiDirection = islamicAPI.qiblaDirection {
                await MainActor.run { qiblaAngle = apiDirection }
            }
        }
    }
}

#Preview {
    QiblaCompassView()
        .environmentObject(AppState())
}
