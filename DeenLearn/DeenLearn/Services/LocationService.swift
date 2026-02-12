//
//  LocationService.swift
//  DeenLearn
//
//  Location service for getting user coordinates for prayer times.
//  Uses native CoreLocation (CLLocationManager) for iOS geolocation.
//

import SwiftUI
import CoreLocation

// MARK: - Location Service

/// A singleton service that provides location functionality
/// for calculating accurate prayer times based on user's position.
/// Uses native iOS CoreLocation for accurate, battery-efficient geolocation.
@MainActor
final class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()
    
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var locationName: String = "Detecting location..."
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLoading = false
    @Published var error: String?
    @Published var isUsingDefaultLocation = true
    
    // Default location (Mecca) if user location is not available
    static let defaultLocation = CLLocation(latitude: 21.4225, longitude: 39.8262)
    
    // Location cache keys
    private static let cachedLatKey = "cachedLocationLat"
    private static let cachedLonKey = "cachedLocationLon"
    private static let cachedNameKey = "cachedLocationName"
    private static let hasCachedLocationKey = "hasCachedLocation"
    
    // Maximum age for a location fix (5 minutes)
    private static let maxLocationAge: TimeInterval = 300
    
    // Retry tracking
    private var retryCount = 0
    private static let maxRetries = 2
    private static let retryDelayNanoseconds: UInt64 = 1_000_000_000
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = locationManager.authorizationStatus
        loadCachedLocation()
        
        // Proactively request location on startup if already authorized
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    /// Request location permission
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Request current location
    func requestLocation() {
        isLoading = true
        error = nil
        retryCount = 0
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            requestPermission()
        case .denied, .restricted:
            isLoading = false
            error = "Location access denied. Please enable in Settings."
            if currentLocation == nil {
                currentLocation = LocationService.defaultLocation
                locationName = "Mecca (Default)"
            }
        @unknown default:
            isLoading = false
            error = "Unknown location status"
        }
    }
    
    /// Get the best available location (user's or default)
    var bestLocation: CLLocation {
        currentLocation ?? LocationService.defaultLocation
    }
    
    /// Start monitoring for significant location changes (battery-efficient)
    func startMonitoringSignificantLocationChanges() {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    // MARK: - Location Cache
    
    /// Save location to UserDefaults for faster startup
    private func cacheLocation(_ location: CLLocation, name: String) {
        UserDefaults.standard.set(location.coordinate.latitude, forKey: Self.cachedLatKey)
        UserDefaults.standard.set(location.coordinate.longitude, forKey: Self.cachedLonKey)
        UserDefaults.standard.set(name, forKey: Self.cachedNameKey)
        UserDefaults.standard.set(true, forKey: Self.hasCachedLocationKey)
    }
    
    /// Load previously cached location for instant availability
    private func loadCachedLocation() {
        guard UserDefaults.standard.bool(forKey: Self.hasCachedLocationKey) else { return }
        let lat = UserDefaults.standard.double(forKey: Self.cachedLatKey)
        let lon = UserDefaults.standard.double(forKey: Self.cachedLonKey)
        let name = UserDefaults.standard.string(forKey: Self.cachedNameKey)
        
        // Only use cache if values were actually stored
        currentLocation = CLLocation(latitude: lat, longitude: lon)
        locationName = name ?? "Cached Location"
        isUsingDefaultLocation = false
    }
    
    /// Reverse geocode to get location name
    private func reverseGeocode(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            Task { @MainActor in
                if let error = error {
                    self?.locationName = "Location Found"
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    let city = placemark.locality ?? ""
                    let country = placemark.country ?? ""
                    
                    var name = "Location Found"
                    if !city.isEmpty && !country.isEmpty {
                        name = "\(city), \(country)"
                    } else if !city.isEmpty {
                        name = city
                    } else if !country.isEmpty {
                        name = country
                    }
                    
                    self?.locationName = name
                    self?.cacheLocation(location, name: name)
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Filter for recent, accurate locations
        let validLocations = locations.filter { location in
            let age = abs(location.timestamp.timeIntervalSinceNow)
            return age < LocationService.maxLocationAge
                && location.horizontalAccuracy >= 0
                && location.horizontalAccuracy < 10000
        }
        
        guard let location = validLocations.last ?? locations.last else { return }
        
        Task { @MainActor in
            self.currentLocation = location
            self.isLoading = false
            self.isUsingDefaultLocation = false
            self.error = nil
            self.retryCount = 0
            self.startMonitoringSignificantLocationChanges()
            self.reverseGeocode(location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            // Retry on transient errors
            if self.retryCount < LocationService.maxRetries {
                self.retryCount += 1
                print("Location retry \(self.retryCount): \(error.localizedDescription)")
                try? await Task.sleep(nanoseconds: Self.retryDelayNanoseconds)
                manager.requestLocation()
                return
            }
            
            self.isLoading = false
            self.error = "Failed to get location"
            // Only fall back to default if no cached location
            if self.currentLocation == nil {
                self.currentLocation = LocationService.defaultLocation
                self.locationName = "Mecca (Default)"
            }
            print("Location error: \(error.localizedDescription)")
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.retryCount = 0
                manager.requestLocation()
            case .denied, .restricted:
                self.isLoading = false
                self.error = "Location access denied"
                if self.currentLocation == nil {
                    self.currentLocation = LocationService.defaultLocation
                    self.locationName = "Mecca (Default)"
                }
            default:
                break
            }
        }
    }
}
