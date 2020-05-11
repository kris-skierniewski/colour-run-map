//
//  LocationService.swift
//  colourRun
//
//  Created by Luke on 07/05/2020.
//  Copyright © 2020 Mapway. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

protocol LocationServiceProtocol {
    
    
    
}


class LocationService: LocationServiceProtocol {
    
    //private var locationManager: LocationManager = LocationManager()

    
    
    private var autherisationRequestCompletionBlocks = [((status: CLAuthorizationStatus, didShow: Bool) -> Void)?]()
    
    
    
    @Published var lastKnownLocation: CLLocation? {
        willSet {
            
        }
    }
    
    
}
