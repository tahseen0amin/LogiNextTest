//
//  BaseViewController.swift
//  loginext
//
//  Created by Tasin Zarkoob on 20/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    internal func setup() {
        
    }

}
