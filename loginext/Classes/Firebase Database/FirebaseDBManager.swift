//
//  FirebaseDBManager.swift
//  loginext
//
//  Created by Tasin Zarkoob on 17/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDBManager {
    static let shared = FirebaseDBManager()
    var ref : DatabaseReference!
    
    private init(){
        ref = Database.database().reference()
    }
    
    
}
