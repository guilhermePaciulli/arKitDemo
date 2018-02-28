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
    
    func getBearing(to destination: CLLocation) ->  CGFloat {
        return self.get().bearingToLocationRadian(destination)
    }
    
}


extension CLLocation {
    
    func bearingToLocationRadian(_ destinationLocation: CLLocation) -> CGFloat {
        
        let lat1 = self.coordinate.latitude.degreesToRadians
        let lon1 = self.coordinate.longitude.degreesToRadians
        
        let lat2 = destinationLocation.coordinate.latitude.degreesToRadians
        let lon2 = destinationLocation.coordinate.longitude.degreesToRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return CGFloat.init(radiansBearing)
    }
    
    func walk(inDirectionOf destination: CLLocation, theDistanceOf xKm: Double) -> CLLocation {
        let lat1 = self.coordinate.latitude.degreesToRadians
        let lon1 = self.coordinate.longitude.degreesToRadians
        let bearing = Double(self.bearingToLocationRadian(destination).radiansToDegrees)
        let angularDistance = xKm / earthRadius
        
        //φ2 = asin( sin φ1 ⋅ cos δ + cos φ1 ⋅ sin δ ⋅ cos θ )
        let latF = sin(sin(lat1) * cos(angularDistance) + cos(lat1) * sin(angularDistance) * cos(bearing))
        
        //λ2 = λ1 + atan2( sin θ ⋅ sin δ ⋅ cos φ1, cos δ − sin φ1 ⋅ sin φ2 )
        let longF = lon1 + atan2(sin(bearing) * sin(angularDistance) * cos(lat1),
                                 cos(angularDistance) - sin(lat1) * sin(latF))
        //φ is latitude, λ is longitude, θ is the bearing (clockwise from north),
        //δ is the angular distance d/R; d being the distance travelled, R the earth’s radius
        
        
        let finalCoordinates = CLLocationCoordinate2D(latitude: latF, longitude: longF)
        let finalLocation = CLLocation(coordinate: finalCoordinates, altitude: destination.altitude)
        
        return finalLocation
    }
    
}

extension SCNVector3 {
    
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    func distanceTo(r: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(self.x - r.x, self.y - r.y, self.z - r.z)
    }
}
