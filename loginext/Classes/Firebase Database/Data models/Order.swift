//
//  Order.swift
//  loginext
//
//  Created by Tasin Zarkoob on 17/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import Foundation

enum Status: String, Codable {
    case QUEUED = "QUEUED"
    case IN_TRANSIT = "IN_TRANSIT"
    case DELIVERED = "DELIVERED"
    case CANCELLED = "CANCELLED"
    
    func value() -> String {
        return self.rawValue
    }
}

struct Order : Codable {
    // Example of nested struct (Order.Address)
    struct Address : Codable {
        var latitude: Double
        var longitude: Double
        var street: String
        var city: String
        var pincode: Int
        
        func toDictionary() -> [String: Any] {
            return [
                "latitude": latitude,
                "longitude": longitude,
                "street": street,
                "city": city,
                "pincode": pincode
            ]
        }
    }
    
    var id: String
    var title: String
    var address: Address
    var status : Status
    var agentID: Int
    
    // example of custom implementation of Codable
    enum CodingKeys: CodingKey {
        case id,
            title, address, status, agentID
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(agentID, forKey: .agentID)
        try container.encode(address, forKey: .title)
        try container.encode(status.rawValue, forKey: .status)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        address = try container.decode(Address.self, forKey: .address)
        status = try container.decode(Status.self, forKey: .status)
        agentID = try container.decode(Int.self, forKey: .agentID)
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "status": status.rawValue,
            "agentID": agentID,
            "address": address.toDictionary()
        ]
    }
    
}
