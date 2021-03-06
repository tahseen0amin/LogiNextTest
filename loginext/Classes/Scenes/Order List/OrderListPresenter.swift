//
//  OrderListPresenter.swift
//  loginext
//
//  Created by Tasin Zarkoob on 17/01/2020.
//  Copyright (c) 2020 Tasin Zarkoob. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol OrderListPresentationLogic {
    func updateOrderList(response: OrderList.GetAllOrders.Response)
}

class OrderListPresenter: OrderListPresentationLogic {
    
     var viewController: OrderListDisplayLogic?
    
    func updateOrderList(response: OrderList.GetAllOrders.Response) {
        if let errorString = response.errorString {
            print(errorString)
            // show the error
        } else {
            viewController?.updateTableView(data: response.orders)
        }
        
    }
    
}
