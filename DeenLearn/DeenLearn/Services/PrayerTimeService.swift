//
//  PrayerTimeService.swift
//  DeenLearn
//
//  Prayer time calculation service based on user's location
//  Uses astronomical calculations for accurate prayer times
//

import SwiftUI
import CoreLocation

// MARK: - Prayer Time Model

struct PrayerTime: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let arabicName: String
    let time: Date
    let icon: String
    let isPrayer: Bool
    let timezone: TimeZone
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = timezone
        return formatter.string(from: time)
    }
    
    var isCurrentPrayer: Bool {
        // Check if current time is within this prayer period
        false // Will be calculated in service
    }
}

// MARK: - Calculation Method

enum CalculationMethod: String, CaseIterable, Identifiable {
    case mwl = "Muslim World League"
    case isna = "ISNA (North America)"
    case egypt = "Egyptian General Authority"
    case makkah = "Umm Al-Qura (Makkah)"
    case karachi = "University of Islamic Sciences, Karachi"
    case tehran = "Institute of Geophysics, Tehran"
    case singapore = "Singapore"
    
    var id: String { rawValue }
    
    // Fajr angle
    var fajrAngle: Double {
        switch self {
        case .mwl: return 18.0
        case .isna: return 15.0
        case .egypt: return 19.5
        case .makkah: return 18.5
        case .karachi: return 18.0
        case .tehran: return 17.7
        case .singapore: return 20.0
        }
    }
    
    // Isha angle (negative means minutes after Maghrib)
    var ishaAngle: Double {
        switch self {
        case .mwl: return 17.0
        case .isna: return 15.0
        case .egypt: return 17.5
        case .makkah: return -90 // 90 minutes after Maghrib
        case .karachi: return 18.0
        case .tehran: return 14.0
        case .singapore: return 18.0
        }
    }
}

// MARK: - Juristic Method for Asr

enum AsrJuristicMethod: String, CaseIterable, Identifiable {
    case shafii = "Shafi'i, Maliki, Hanbali"
    case hanafi = "Hanafi"
    
    var id: String { rawValue }
    
    var shadowFactor: Double {
        switch self {
        case .shafii: return 1.0
        case .hanafi: return 2.0
        }
    }
}

// MARK: - Prayer Time Service

@MainActor
final class PrayerTimeService: ObservableObject {
    static let shared = PrayerTimeService()
    
    @Published var prayerTimes: [PrayerTime] = []
    @Published var nextPrayer: PrayerTime?
    @Published var timeUntilNextPrayer: String = ""
    @Published var currentPrayerIndex: Int = -1
    @Published var isLoading = false
    
    @Published var calculationMethod: CalculationMethod = .isna {
        didSet {
            UserDefaults.standard.set(calculationMethod.rawValue, forKey: "prayerCalculationMethod")
            recalculatePrayerTimes()
        }
    }
    
    @Published var asrMethod: AsrJuristicMethod = .shafii {
        didSet {
            UserDefaults.standard.set(asrMethod.rawValue, forKey: "prayerAsrMethod")
            recalculatePrayerTimes()
        }
    }
    
    private var locationService = LocationService.shared
    private var timer: Timer?
    
    private init() {
        // Load saved preferences
        if let savedMethod = UserDefaults.standard.string(forKey: "prayerCalculationMethod"),
           let method = CalculationMethod(rawValue: savedMethod) {
            calculationMethod = method
        }
        
        if let savedAsrMethod = UserDefaults.standard.string(forKey: "prayerAsrMethod"),
           let method = AsrJuristicMethod(rawValue: savedAsrMethod) {
            asrMethod = method
        }
        
        // Start timer to update countdown
        startTimer()
        
        // Calculate initial prayer times after a short delay to allow location service to initialize
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.calculatePrayerTimes()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Public Methods
    
    /// Calculate prayer times for the current location
    func calculatePrayerTimes() {
        isLoading = true
        let location = locationService.bestLocation
        calculatePrayerTimes(for: location, date: Date())
        isLoading = false
    }
    
    /// Calculate prayer times for a specific location and date
    func calculatePrayerTimes(for location: CLLocation, date: Date, timezone: TimeZone? = nil) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        // Always use device timezone to match what the user sees on their clock
        let deviceTimezone = timezone ?? TimeZone.current
        let timezoneOffset = Double(deviceTimezone.secondsFromGMT(for: date)) / 3600.0
        
        // Calculate Julian date
        let jd = julianDate(year: year, month: month, day: day)
        
        // Calculate prayer times
        let times = computePrayerTimes(jd: jd, latitude: latitude, longitude: longitude, timezone: timezoneOffset)
        
        // Create PrayerTime objects
        var prayers: [PrayerTime] = []
        
        let prayerData: [(String, String, Double, String, Bool)] = [
            ("Fajr", "الفجر", times.fajr, "sun.horizon.fill", true),
            ("Shuruq", "الشروق", times.sunrise, "sunrise.fill", false),
            ("Dhuhr", "الظهر", times.dhuhr, "sun.max.fill", true),
            ("Asr", "العصر", times.asr, "sun.min.fill", true),
            ("Maghrib", "المغرب", times.maghrib, "sunset.fill", true),
            ("Isha", "العشاء", times.isha, "moon.stars.fill", true)
        ]
        
        for (name, arabicName, time, icon, isPrayer) in prayerData {
            if let prayerDate = timeToDate(time, baseDate: date, timezone: deviceTimezone) {
                prayers.append(PrayerTime(
                    name: name,
                    arabicName: arabicName,
                    time: prayerDate,
                    icon: icon,
                    isPrayer: isPrayer,
                    timezone: deviceTimezone
                ))
            }
        }
        
        self.prayerTimes = prayers
        updateNextPrayer()
    }
    
    /// Recalculate prayer times with current settings
    func recalculatePrayerTimes() {
        calculatePrayerTimes()
    }
    
    // MARK: - Private Calculation Methods
    
    private struct PrayerTimesResult {
        var fajr: Double = 0
        var sunrise: Double = 0
        var dhuhr: Double = 0
        var asr: Double = 0
        var maghrib: Double = 0
        var isha: Double = 0
    }
    
    private func computePrayerTimes(jd: Double, latitude: Double, longitude: Double, timezone: Double) -> PrayerTimesResult {
        var result = PrayerTimesResult()
        
        // Calculate sun position
        let d = jd - 2451545.0
        let g = fixAngle(357.529 + 0.98560028 * d)
        let q = fixAngle(280.459 + 0.98564736 * d)
        let l = fixAngle(q + 1.915 * sin(degToRad(g)) + 0.020 * sin(degToRad(2 * g)))
        let e = 23.439 - 0.00000036 * d
        let ra = radToDeg(atan2(cos(degToRad(e)) * sin(degToRad(l)), cos(degToRad(l)))) / 15.0
        let dec = radToDeg(asin(sin(degToRad(e)) * sin(degToRad(l))))
        let eqt = q / 15.0 - fixHour(ra)
        
        // Calculate Dhuhr time
        result.dhuhr = 12 + timezone - longitude / 15.0 - eqt
        
        // Calculate Sunrise and Sunset
        let sunriseAngle = 0.833
        result.sunrise = result.dhuhr - timeDiff(angle: sunriseAngle, dec: dec, lat: latitude)
        result.maghrib = result.dhuhr + timeDiff(angle: sunriseAngle, dec: dec, lat: latitude)
        
        // Calculate Fajr
        result.fajr = result.dhuhr - timeDiff(angle: calculationMethod.fajrAngle, dec: dec, lat: latitude)
        
        // Calculate Asr
        let asrAngle = radToDeg(atan(1 / (asrMethod.shadowFactor + tan(degToRad(abs(latitude - dec))))))
        result.asr = result.dhuhr + asrTimeDiff(elevation: asrAngle, dec: dec, lat: latitude)
        
        // Calculate Isha
        if calculationMethod.ishaAngle < 0 {
            // Minutes after Maghrib
            result.isha = result.maghrib + abs(calculationMethod.ishaAngle) / 60.0
        } else {
            result.isha = result.dhuhr + timeDiff(angle: calculationMethod.ishaAngle, dec: dec, lat: latitude)
        }
        
        return result
    }
    
    private func julianDate(year: Int, month: Int, day: Int) -> Double {
        var y = year
        var m = month
        
        if m <= 2 {
            y -= 1
            m += 12
        }
        
        let a = Int(floor(Double(y) / 100.0))
        let b = 2 - a + Int(floor(Double(a) / 4.0))
        
        return floor(365.25 * Double(y + 4716)) + floor(30.6001 * Double(m + 1)) + Double(day) + Double(b) - 1524.5
    }
    
    private func timeDiff(angle: Double, dec: Double, lat: Double) -> Double {
        let cosAngle = (-sin(degToRad(angle)) - sin(degToRad(dec)) * sin(degToRad(lat))) / (cos(degToRad(dec)) * cos(degToRad(lat)))
        return radToDeg(acos(min(1, max(-1, cosAngle)))) / 15.0
    }
    
    private func asrTimeDiff(elevation: Double, dec: Double, lat: Double) -> Double {
        let cosAngle = (sin(degToRad(elevation)) - sin(degToRad(dec)) * sin(degToRad(lat))) / (cos(degToRad(dec)) * cos(degToRad(lat)))
        return radToDeg(acos(min(1, max(-1, cosAngle)))) / 15.0
    }
    
    private func timeToDate(_ time: Double, baseDate: Date, timezone: TimeZone) -> Date? {
        let hours = Int(time)
        let minutes = Int((time - Double(hours)) * 60)
        
        var calendar = Calendar.current
        calendar.timeZone = timezone
        
        var components = calendar.dateComponents([.year, .month, .day], from: baseDate)
        components.hour = hours
        components.minute = minutes
        components.second = 0
        
        return calendar.date(from: components)
    }
    
    // MARK: - Helper Math Functions
    
    private func degToRad(_ d: Double) -> Double { d * .pi / 180.0 }
    private func radToDeg(_ r: Double) -> Double { r * 180.0 / .pi }
    private func fixAngle(_ a: Double) -> Double { a - 360.0 * floor(a / 360.0) }
    private func fixHour(_ h: Double) -> Double { h - 24.0 * floor(h / 24.0) }
    
    // MARK: - Next Prayer Tracking
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateNextPrayer()
            }
        }
    }
    
    private func updateNextPrayer() {
        let now = Date()
        
        // Find the next prayer (skip non-prayer reference times like Shuruq)
        var foundNext = false
        for (index, prayer) in prayerTimes.enumerated() {
            if prayer.time > now && prayer.isPrayer {
                nextPrayer = prayer
                currentPrayerIndex = index - 1
                foundNext = true
                updateCountdown(to: prayer.time)
                break
            }
        }
        
        // If no prayer found today, next is Fajr tomorrow
        if !foundNext {
            if let fajr = prayerTimes.first(where: { $0.isPrayer }) {
                nextPrayer = fajr
                currentPrayerIndex = prayerTimes.count - 1
                
                // Calculate time to tomorrow's Fajr
                if let tomorrowFajr = Calendar.current.date(byAdding: .day, value: 1, to: fajr.time) {
                    updateCountdown(to: tomorrowFajr)
                }
            }
        }
    }
    
    private func updateCountdown(to prayerTime: Date) {
        let now = Date()
        let diff = prayerTime.timeIntervalSince(now)
        
        if diff <= 0 {
            timeUntilNextPrayer = "Now"
            return
        }
        
        let hours = Int(diff) / 3600
        let minutes = (Int(diff) % 3600) / 60
        let seconds = Int(diff) % 60
        
        if hours > 0 {
            timeUntilNextPrayer = String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            timeUntilNextPrayer = String(format: "%d:%02d", minutes, seconds)
        }
    }
}
