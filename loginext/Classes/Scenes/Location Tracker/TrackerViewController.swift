//
//  TrackerViewController.swift
//  loginext
//
//  Created by Tasin Zarkoob on 20/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TrackerViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            self.mapView.delegate = self
        }
    }
    private var markers: [Marker]? {
        didSet {
            self.addAnnotation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchAllLocation()
//        if let current = LocationManager.shared.manager.location {
//            self.mapView.setRegion(MKCoordinateRegion(center: current.coordinate, latitudinalMeters: 400, longitudinalMeters: 400), animated: true)
//        }
    }
    
    private func fetchAllLocation() {
        let request = NSFetchRequest<Marker>(entityName: "Marker")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        request.returnsObjectsAsFaults = true
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        do {
            let results = try context.fetch(request)
            self.markers = results
        } catch {
            print("Failed to get the markers")
        }
    }
    
    private func addAnnotation() {
        if let count = self.markers?.count, count <= 2 {
            return
        }
        let first = self.markers!.first!
        let last = self.markers!.last!
        
        for  index in 0..<self.markers!.count-1 {
            let directions = self.makeDirectionRequest(first: self.markers![index], last: self.markers![index + 1])
            self.drawOverlay(for: directions)
        }
        self.setFinalRegionZoom(first: first, last: last)
        
    }
    
    private func makeDirectionRequest(first: Marker, last: Marker) -> MKDirections {
        
        let firstLocation = CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude)
        let lastLocation = CLLocationCoordinate2D(latitude: last.latitude, longitude: last.longitude)
       
        let firstPlacemark = MKPlacemark(coordinate: firstLocation)
        let lastPlacemark = MKPlacemark(coordinate: lastLocation)
       
        let firstMapItem = MKMapItem(placemark: firstPlacemark)
        let lastMapItem = MKMapItem(placemark: lastPlacemark)
       
        let directionRequest = MKDirections.Request()
        directionRequest.source = firstMapItem
        directionRequest.destination = lastMapItem
        directionRequest.transportType = .automobile
        return MKDirections(request: directionRequest)
    }
    
    private func drawOverlay(for directions: MKDirections) {
        directions.calculate { (response, error) in
            guard let response = response else {
                return
            }
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }
    
    private func setupOverlay() {
        
    }
    
    private func setFinalRegionZoom(first: Marker, last: Marker) {
        let directions = self.makeDirectionRequest(first: first, last: last)
        directions.calculate { (response, error) in
            guard let response = response else {
                return
            }
            
            let route = response.routes[0]
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
}

extension TrackerViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4.0
            return renderer
    }
}
