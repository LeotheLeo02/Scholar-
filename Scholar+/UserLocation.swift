//
//  UserLocation.swift
//  Scholar+
//
//  Created by Nate on 9/22/22.
//

import Foundation
import MapKit

final class LocationViewModel: NSObject, CLLocationManagerDelegate, ObservableObject{
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 60), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
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
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}
