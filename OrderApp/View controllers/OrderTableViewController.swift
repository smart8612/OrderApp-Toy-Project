//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    private let restaurantController = RestaurantController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUI),
            name: RestaurantController.orderUpdateNotification, object: nil
        )
        
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @objc
    private func updateUI() {
        self.tableView.reloadData()
    }

}

// MARK: TableView & DataSource Handling Code
extension OrderTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantController.order.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = restaurantController.order.menuItems[indexPath.row]
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = menuItem.name
        contentConfiguration.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
        cell.contentConfiguration = contentConfiguration
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            restaurantController.deleteOrder(with: indexPath.row)
        }
    }
    
}
