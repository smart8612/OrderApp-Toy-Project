//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    private let restaurantController = RestaurantController.shared
    private var minutesToPrepareOrder = 0

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
    
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        let orderTotal = restaurantController.order.menuItems.reduce(0.0) { partialResult, menuItem in
            return partialResult + menuItem.price
        }
        
        let formattedTotal = orderTotal.formatted(.currency(code: "usd"))
        
        let alert = UIAlertController(
            title: "Confirm Order",
            message: "You are about to submit your order with a total of \(formattedTotal)",
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(title: "Submit", style: .default) { _ in
                self.uploadOrder()
            }
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        present(alert, animated: true)
    }
    
    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder, minutesToPrepare: minutesToPrepareOrder)
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "dismissConfirmation" {
            restaurantController.deleteAllOrder()
        }
    }
    
    private func uploadOrder() {
        let menuIds = restaurantController.order.menuItems.map { $0.id }
        Task {
            do {
                let minutesToPrepare = try await restaurantController.submitOrder(forMenuIDs: menuIds)
                minutesToPrepareOrder = minutesToPrepare
                performSegue(withIdentifier: "confirmOrder", sender: nil)
            } catch {
                displayError(error, title: "Order Submission Failed")
            }
        }
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
        contentConfiguration.image = UIImage(systemName: "photo.on.rectangle")
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
