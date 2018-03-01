//
//  Location.swift
//  ARKitNanoChallenge
//
//  Created by Guilherme Paciulli on 27/02/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SceneKit

private let earthRadius: Double = 6.371

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


extension CLLocation {
    
    public func bearing(to destination: CLLocation) -> Double {
        let lat1 = Double.pi * coordinate.latitude / 180.0
        let long1 = Double.pi * coordinate.longitude / 180.0
        let lat2 = Double.pi * destination.coordinate.latitude / 180.0
        let long2 = Double.pi * destination.coordinate.longitude / 180.0
        
        let rads = atan2(sin(long2 - long1) * cos(lat2),
                         cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
        let degrees = rads * 180 / Double.pi
        
        return (degrees+360).truncatingRemainder(dividingBy: 360)
    }
    
    func walk(inDirectionOf destination: CLLocation, theDistanceOf xKm: Double) -> CLLocation {
        
        let φ1 = self.coordinate.latitude //φ is latitude
        let λ1 = self.coordinate.longitude //λ is longitude
        let θ = self.bearing(to: destination) //θ is the bearing (clockwise from north)
        let δ = xKm / earthRadius //δ is the angular distance d/R; d being the distance travelled, R the earth’s radius
        
//      let φ2 = asin(sin φ1  ⋅ cos δ  + cos φ1  ⋅  sin δ  ⋅ cos θ )
        let φ2 = asin(sin(φ1) * cos(δ) + cos(φ1) * sin(δ) * cos(θ))
        
//      let λ2 = λ1 + atan2(sin θ  ⋅ sin δ  ⋅  cos φ1,  cos δ  − sin φ1  ⋅ sin φ2 )
        let λ2 = λ1 + atan2(sin(θ) * sin(δ) * cos(φ1), cos(δ) - sin(φ1) * sin(φ2))
        
        
        let finalCoordinates = CLLocationCoordinate2D(latitude: φ1, longitude: λ2)
        let finalLocation = CLLocation(coordinate: finalCoordinates, altitude: self.altitude)
        
        return finalLocation
    }
    
    func walk(inDirectionOf bearing: Double, theDistanceOf xKm: Double, altitudeOf zMeters: Double? = nil) -> CLLocation {
        
        let φ1 = self.coordinate.latitude.degreesToRadians  //φ1 is latitude
        let λ1 = self.coordinate.longitude.degreesToRadians //λ1 is longitude
        let θ = bearing                                     //θ is the bearing (clockwise from north)
        let δ = xKm / earthRadius                           //δ is the angular distance d/R; d being the distance travelled, R the earth’s radius
        
//      let φ2 = asin(sin φ1  ⋅ cos δ  + cos φ1  ⋅  sin δ  ⋅ cos θ )
        let φ2 = asin(sin(φ1) * cos(δ) + cos(φ1) * sin(δ) * cos(θ))
        
//      let λ2 = λ1 + atan2(sin θ  ⋅ sin δ  ⋅  cos φ1,  cos δ  − sin φ1  ⋅ sin φ2 )
        let λ2 = λ1 + atan2(sin(θ) * sin(δ) * cos(φ1), cos(δ) - sin(φ1) * sin(φ2))
        
        
        let finalCoordinates = CLLocationCoordinate2D(latitude: φ2, longitude: λ2)
        let finalLocation = CLLocation(coordinate: finalCoordinates, altitude: zMeters ?? self.altitude)
        
        return finalLocation
    }
    
}

extension SCNVector3 {
    
    func length() -> Float {
        return sqrtf(x * x + y * y)
    }
    
    func distanceTo(r: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(self.x - r.x, self.y - r.y, self.z - r.z)
    }
}
