//
//  Annotation.swift
//  loginext
//
//  Created by Tasin Zarkoob on 20/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import Foundation
import MapKit

class Annotation : NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(order: Order) {
        self.title = order.title
        self.coordinate = CLLocationCoordinate2D(latitude: order.address.latitude, longitude: order.address.longitude)
        super.init()
    }
}
