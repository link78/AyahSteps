//
//  LocationService.swift
//  DeenLearn
//
//  Location service for getting user coordinates for prayer times
//

import SwiftUI
import CoreLocation

// MARK: - Location Service

/// A singleton service that provides location functionality
/// for calculating accurate prayer times based on user's position
@MainActor
final class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()
    
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var locationName: String = "Unknown Location"
    @Published var locationTimezone: TimeZone = TimeZone.current
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLoading = false
    @Published var error: String?
    
    // Default location (Mecca) if user location is not available
    static let defaultLocation = CLLocation(latitude: 21.4225, longitude: 39.8262)
    static let defaultTimezone = TimeZone(identifier: "Asia/Riyadh")! // Mecca timezone (UTC+3)
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = locationManager.authorizationStatus
    }
    
    /// Request location permission
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Request current location
    func requestLocation() {
        isLoading = true
        error = nil
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            requestPermission()
        case .denied, .restricted:
            isLoading = false
            error = "Location access denied. Please enable in Settings."
            // Use default location
            currentLocation = LocationService.defaultLocation
            locationName = "Mecca (Default)"
            locationTimezone = LocationService.defaultTimezone
        @unknown default:
            isLoading = false
            error = "Unknown location status"
        }
    }
    
    /// Get the best available location (user's or default)
    var bestLocation: CLLocation {
        currentLocation ?? LocationService.defaultLocation
    }
    
    /// Get the timezone for the best available location
    var bestTimezone: TimeZone {
        currentLocation != nil ? locationTimezone : LocationService.defaultTimezone
    }
    
    /// Reverse geocode to get location name and timezone
    private func reverseGeocode(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            Task { @MainActor in
                if let error = error {
                    self?.locationName = "Location Found"
                    // Fall back to estimating timezone from longitude
                    self?.locationTimezone = TimeZone(secondsFromGMT: Int(round(location.coordinate.longitude / 15.0 * 3600))) ?? LocationService.defaultTimezone
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    let city = placemark.locality ?? ""
                    let country = placemark.country ?? ""
                    
                    if !city.isEmpty && !country.isEmpty {
                        self?.locationName = "\(city), \(country)"
                    } else if !city.isEmpty {
                        self?.locationName = city
                    } else if !country.isEmpty {
                        self?.locationName = country
                    } else {
                        self?.locationName = "Location Found"
                    }
                    
                    // Get timezone from placemark
                    if let tz = placemark.timeZone {
                        self?.locationTimezone = tz
                    }
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        Task { @MainActor in
            self.currentLocation = location
            self.isLoading = false
            self.error = nil
            self.reverseGeocode(location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.isLoading = false
            self.error = "Failed to get location"
            // Use default location on error
            self.currentLocation = LocationService.defaultLocation
            self.locationName = "Mecca (Default)"
            self.locationTimezone = LocationService.defaultTimezone
            print("Location error: \(error.localizedDescription)")
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
            case .denied, .restricted:
                self.isLoading = false
                self.error = "Location access denied"
                self.currentLocation = LocationService.defaultLocation
                self.locationName = "Mecca (Default)"
                self.locationTimezone = LocationService.defaultTimezone
            default:
                break
            }
        }
    }
}
