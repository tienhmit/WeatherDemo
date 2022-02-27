//
//  LocationHelper.swift
//  WeatherAlert
//
//  Created by Hoang Manh Tien on 2/26/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import CoreLocation

typealias GetLocationDoneBlock = (_ location: CLLocation) -> Void
typealias GetLocationFalseBlock = (_ status: CLAuthorizationStatus) -> Void

class LocationHelper: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var latestLocation: CLLocation?
    var doneBlock: GetLocationDoneBlock?
    var falseBlock: GetLocationFalseBlock?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    var isLocationServiceEndable: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    public static var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func getCurrentLocation(_ _done: @escaping GetLocationDoneBlock, _ _false: @escaping GetLocationFalseBlock) {
        doneBlock = _done
        falseBlock = _false
        
        if isLocationServiceEndable {
             switch authorizationStatus {
                case .notDetermined:
                    locationManager.requestAlwaysAuthorization()
                    DLog("notDetermined")
                    break
                case .restricted, .denied:
                    DLog("No access")
                    falseBlock?(authorizationStatus)
                    doneBlock = nil
                    falseBlock = nil
                case .authorizedAlways, .authorizedWhenInUse:
                    DLog("Access")
                    locationManager.startUpdatingLocation()
                default:
                break
             }
        } else {
            falseBlock?(authorizationStatus)
            doneBlock = nil
            falseBlock = nil
            DLog("Location services are not enabled")
        }
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Pick the location with best (= smallest value) horizontal accuracy
        latestLocation = locations.sorted { $0.horizontalAccuracy < $1.horizontalAccuracy }.first
        locationManager.stopUpdatingLocation()
        
        if let location = latestLocation {
            doneBlock?(location)
        }
        
        doneBlock = nil
        falseBlock = nil
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
            falseBlock?(status)
        }
        
        doneBlock = nil
        falseBlock = nil
    }
    
    deinit {
        doneBlock = nil
        falseBlock = nil
    }
}
