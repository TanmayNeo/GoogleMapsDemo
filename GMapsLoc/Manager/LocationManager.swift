//
//  LocationManager.swift
//  GMapsLoc
//
//  Created by apple on 15/03/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static var shared = LocationManager()
    let manager = CLLocationManager()

    var didReceiveUserLocation : ((CLLocation) -> ())?
    
    private override init (){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
     
    }
    
    //sets up the delegate of the location manager
    func startUpdate() {
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let location = locations.first else { return }
        didReceiveUserLocation?(location)
    }
    
}
