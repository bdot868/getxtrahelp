//
//  LocationManager.swift
//  Momentor
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit
import CoreLocation

//protocol UpdateLocationDelegate {
//    func UpdateLocation(locationdata: [CLLocation])
//}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: -  Variable
    static let shared = LocationManager()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var provideLocationBlock: ((_ locationManager: CLLocationManager,_ location: CLLocation)->(Bool))?
    
    //    var updateLocDelegate: UpdateLocationDelegate?
    // MARK: - Init
    override init() {
        super.init()
        //Set up CLLocationManager instance
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if [.authorizedWhenInUse, .authorizedAlways].contains(status) {
            manager.startUpdatingLocation()
            //NotificationCenter.default.post(name:NSNotification.Name(rawValue: NotificationPostname.KLocationStatus), object: status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            
            currentLocation = locations.last
            
            if let cadd = self.currentLocation {
                XtraHelp.sharedInstance.getAddressFromLatLong(lat: cadd.coordinate.latitude, long: cadd.coordinate.longitude) { (str,country,state,city,street,zipcode) in
                    XtraHelp.sharedInstance.currentAddressString = str
                }
            }
            
            if let block = provideLocationBlock {
                if currentLocation == nil {
                    currentLocation = locations.last!
                    //lat_currnt = location?.coordinate.latitude ?? 0.0
                    //long_currnt = location?.coordinate.longitude ?? 0.0
                    if block(locationManager,currentLocation!) {
                        //locationManager.stopUpdatingLocation()
                    } else {
                        //location = nil
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // MARK: - Instance Method
    
    func startLocationTracking() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        case .denied:
            print("Show alert")
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LocationAccessViewController")
            let navVC = UINavigationController(rootViewController: vc)
            navVC.isNavigationBarHidden = true
            navVC.modalPresentationStyle = .overFullScreen
            delay(seconds: 1) {
                appDelegate.window?.rootViewController?.present(navVC, animated: true, completion: nil)
            }
        case .restricted:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func getLocationUpdates(completionHandler: @escaping ((_ locationManager: CLLocationManager,_ location: CLLocation)->(Bool))) {
        currentLocation = nil
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        provideLocationBlock = completionHandler
        
    }
    
    func stopLocationTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    func restartLocationUpdating() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func isAutorizationStausDenined() -> Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
    func findDistancefromCurrent(with source : CLLocation) -> Double {
        //currentLocation = CLLocation(latitude: 0, longitude: 0)
        let distanceInMeters : CLLocationDistance = (currentLocation!.distance(from: source))
        let distanceInMiles = distanceInMeters/1609.344
        // let strDistance = String(format: "%.2f", distanceInMiles)
        return distanceInMiles
    }
}
