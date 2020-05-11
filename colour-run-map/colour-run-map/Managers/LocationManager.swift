//
//  LocationManager.swift
//  colourRun
//
//  Created by Luke on 07/05/2020.
//  Copyright © 2020 Mapway. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()

    private var autherisationRequestCompletionBlocks = [((CLAuthorizationStatus) -> Void)]()
    private var locationRequestCompletionBlocks = [((CLLocation?) -> Void)]()
    
    
    static let shared = LocationManager()
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var canGetLocation: Bool {
        return locationAutherisationStatus == .authorizedWhenInUse || locationAutherisationStatus == .authorizedAlways
    }
    
    @Published var locationAutherisationStatus: CLAuthorizationStatus? {
        willSet { objectWillChange.send() }
    }

    @Published var lastLocation: CLLocation? {
        willSet { objectWillChange.send() }
    }
    
    var isRecordingLocation = false
    
    @Published var recordedLocations: [CLLocation] = [] {
        willSet { objectWillChange.send() }
    }
    
    var recentLocation: CLLocation? {
        if let lastLocation = lastLocation,
            lastLocation.timestamp.timeIntervalSinceNow < 60.0 {
            return lastLocation
        }
        
        return nil
    }

    let objectWillChange = PassthroughSubject<Void, Never>()
    
    func requestWhenInUseAuthorization(withCompletion completion: ((_ status: CLAuthorizationStatus) -> Void)?) {
        if completion != nil { autherisationRequestCompletionBlocks.append(completion!) }
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation(withCompletion completion: ((CLLocation?) -> Void)?) {
        if canGetLocation {
            if completion != nil { locationRequestCompletionBlocks.append(completion!) }
            locationManager.requestLocation()
        } else {
            completion?(nil)
        }
    }
    
    func startRecordingLocation() {
        recordedLocations.removeAll()
        isRecordingLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func stopRecordingLocation() {
        isRecordingLocation = false
        locationManager.stopUpdatingLocation()
    }

    
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationAutherisationStatus = status
        
//        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            manager.startUpdatingLocation()
//        }
        autherisationRequestCompletionBlocks.forEach { block in
            block(status)
        }
        autherisationRequestCompletionBlocks = []
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if isRecordingLocation {
            //continuously recording locations
            for newLocation in locations {
                let howRecent = newLocation.timestamp.timeIntervalSinceNow
                guard newLocation.horizontalAccuracy < 20 && newLocation.verticalAccuracy < 20 && abs(howRecent) < 10 else { continue }
                if let lastLocation = recordedLocations.last {
                    //calculate distance etc
                }
                recordedLocations.append(newLocation)
                objectWillChange.send()
                lastLocation = newLocation
            }
        } else {
            //just getting current location
            guard let location = locations.last else { return }
            lastLocation = location
            locationRequestCompletionBlocks.forEach{ block in
                block(location)
            }
            locationRequestCompletionBlocks = []

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationRequestCompletionBlocks.forEach{ block in
            block(nil)
        }
        locationRequestCompletionBlocks = []
    }
    
}

extension CLAuthorizationStatus {
    
    var asString: String {
        switch self {
        case .notDetermined: return "Not Determined"
        case .authorizedWhenInUse: return "Authorized When In Use"
        case .authorizedAlways: return "Authorized Always"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        default: return "Unknown"
        }
    }
    
}
