//
//  LocationManager.swift
//  loginext
//
//  Created by Tasin Zarkoob on 20/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared: LocationManager = LocationManager()
    
    var manager: CLLocationManager = CLLocationManager()
    
    var location: CLLocation?
    
    private var timer: Timer!
    
    private override init() {
        super.init()
        self.requestLocationAccess()
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
    }
    
    private func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
            self.updateLocationInCoreData()
        }
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    private func updateLocationInCoreData(){
        print("Location")
        print(self.location ?? "nil")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let current = self.location else { return }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Marker", in: context)
        if let marker = NSManagedObject(entity: entity!, insertInto: context) as? Marker {
            marker.latitude = current.coordinate.latitude
            marker.longitude = current.coordinate.longitude
            marker.timestamp = Date()
            do {
               try context.save()
              } catch {
               print("Failed saving")
            }
        }
    }
    
    // MARK: Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations[0]
    }

}
