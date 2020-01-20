//
//  OrderListCell.swift
//  loginext
//
//  Created by Tasin Zarkoob on 17/01/2020.
//  Copyright © 2020 Tasin Zarkoob. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {
    
    private var order: Order!
    
    @IBOutlet private weak var orderTitle: UILabel!
    @IBOutlet private weak var orderStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(order: Order) {
        self.order = order
        self.orderTitle.text = self.order.title
        self.orderStatus.text = self.order.status.value().uppercased()
        self.orderStatus.textColor = AppTheme.OrderStatus.colors(status: order.status)
    }
}
