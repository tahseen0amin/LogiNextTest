//
//  OrderListViewController.swift
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

class OrderListConfigurator {
    static func configure(viewController: OrderListViewController) {
        let interactor = OrderListInteractor()
        let presenter = OrderListPresenter()
        let router = OrderListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}

protocol OrderListDisplayLogic {
    func updateTableView(data: [Order])
}

class OrderListViewController: BaseViewController, OrderListDisplayLogic, UITableViewDataSource, UITableViewDelegate {
    
    var interactor: OrderListBusinessLogic?
    var router: (NSObjectProtocol & OrderListRoutingLogic & OrderListDataPassing)?
    
    @IBOutlet private weak var tableView: UITableView!
    private let cellIdentifier = "OrderListCell"
    private var data: [Order] = []
    
    // MARK: Setup
    internal override func setup() {
        OrderListConfigurator.configure(viewController: self)
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Orders"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // imagine login screen will setup the delivery agent name as
        let agentID = 1
        let request = OrderList.GetAllOrders.Request(agentID: agentID)
        interactor?.fetchOrders(request: request)

    }
    
    // MARK: Display Logic Implementation
    func updateTableView(data: [Order]) {
        self.data = data
        self.tableView.reloadData()
    }
    
    // MARK: Routing
    
    // MARK: TABLE VIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OrderListCell
        let order = self.data[indexPath.row]
        cell.setupCell(order: order)
        return cell
    }
    
    // MARK: TABLE VIEW DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.router?.routeToOrderDetails(order: self.data[indexPath.row])
    }

}