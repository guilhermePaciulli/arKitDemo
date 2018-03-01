//
//  LocationSingleton.swift
//  ARKitNanoChallenge
//
//  Created by Guilherme Paciulli on 01/03/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SceneKit


class Location {
    
    static public let shared = Location()
    
    private init() { }
    
    func exists() -> Bool {
        return UserDefaults.standard.value(forKey: "latitude") != nil
    }
    
    func set(location: CLLocation) {
        UserDefaults.standard.set(location.coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(location.coordinate.longitude, forKey: "longitude")
        UserDefaults.standard.set(location.altitude, forKey: "altitude")
    }
    
    func get() -> CLLocation {
        let latitude = UserDefaults.standard.value(forKey: "latitude") as! Double
        let longitude = UserDefaults.standard.value(forKey: "longitude") as! Double
        let altitude = UserDefaults.standard.value(forKey: "altitude") as! Double
        let coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                longitude: longitude)
        return CLLocation(coordinate: coordinate, altitude: altitude)
    }
    
}
