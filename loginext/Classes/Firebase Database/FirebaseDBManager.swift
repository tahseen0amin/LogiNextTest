//
//  FirebaseDBManager.swift
//  loginext
//
//  Created by Tasin Zarkoob on 17/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import Foundation
import Firebase

typealias FirebaseCompletionHandler = (Any) -> Void

class FirebaseDBManager {
    static let shared = FirebaseDBManager()
    var ref : DatabaseReference!
    
    private init(){
        Database.database().isPersistenceEnabled = true
        ref = Database.database().reference()
    }
    
    func getAllOrders(completionHandler: @escaping FirebaseCompletionHandler) {
        
        self.ref.child("data").child("orders").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(), let data = snapshot.value {
                completionHandler(data)
            }
        }) { (error) in
             print(error.localizedDescription)
        }
    }
    
    func updateOrderStatus(order: Order) {
        guard let key = self.ref.child("data").child("orders").child(order.id).key else { return }
        let childUpdates = ["/data/orders/\(key)": order.toDictionary()]
        ref.updateChildValues(childUpdates)
        
    }
    
}
