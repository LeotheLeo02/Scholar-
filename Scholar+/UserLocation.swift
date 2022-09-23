//
//  UserLocation.swift
//  Scholar+
//
//  Created by Nate on 9/22/22.
//

import Foundation
import MapKit

final class LocationViewModel: NSObject, CLLocationManagerDelegate, ObservableObject{
    
    var locationManager: CLLocationManager?
    
    func CheckLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }else{
            print("Show alert")
        }
    }
    
    private func checkAuthorization(){
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Parental Controls")
        case .denied:
            print("Go to settings to fix")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}
