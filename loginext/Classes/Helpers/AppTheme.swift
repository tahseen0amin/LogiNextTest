//
//  AppTheme.swift
//  loginext
//
//  Created by Tasin Zarkoob on 20/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import UIKit

struct AppTheme {
    
    struct OrderStatus {
        
        static func colors(status: Status) -> UIColor {
            switch status {
            case .QUEUED:
                return .gray
            case .IN_TRANSIT:
                return .orange
            case .DELIVERED:
                return .green
            case .CANCELLED:
                return .red
            }
        }
        
    }
}
