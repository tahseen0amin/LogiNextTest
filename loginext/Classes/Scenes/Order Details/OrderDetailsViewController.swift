//
//  OrderDetailsViewController.swift
//  loginext
//
//  Created by Tasin Zarkoob on 19/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import UIKit
import MapKit

class OrderDetailsViewController: UITableViewController {
    
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPincode: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var order: Order!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
    }
    
    private func updateView() {
        self.orderTitle.text = order.title
        self.lblStreet.text = order.address.street
        self.lblCity.text = order.address.city
        self.lblPincode.text = "\(order.address.pincode)"
        self.orderStatus.text = order.status.value().uppercased()
        self.orderStatus.textColor = AppTheme.OrderStatus.colors(status: order.status)
        
        let annotation = Annotation(order: order)
        self.map.addAnnotation(annotation)
        self.map.setRegion(MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
    }
    
    @IBAction func changeOrderStatus(_ sender: UIButton) {
        let allStatus = ["QUEUED", "IN_TRANSIT", "DELIVERED", "CANCELLED"]
        LoginextStatusPicker.shared.showPicker(in: self, title: "Change Order Status", selected: order.status.value(),
                                               strings: allStatus) { (selected, index, cancel) in
            
            if let selected = selected {
                guard let newStatus = Status(rawValue: selected) else {
                    return
                }
                self.order.status = newStatus
                FirebaseDBManager.shared.updateOrderStatus(order: self.order)
                self.updateView()
            }
            
        }
    }
    
    
}

extension OrderDetailsViewController: MKMapViewDelegate {
    
}
