//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit
import Combine

@MainActor
final class OrderTableViewController: UITableViewController {
    
    private let restaurantController = RestaurantController.shared
    private var minutesToPrepareOrder = 0
    private var imageLoadTasks: [IndexPath:Task<Void, Never>] = [:]
    private var orderUpdateSubscribe: Cancellable?

    override func viewDidDisappear(_ animated: Bool) {
        imageLoadTasks.forEach { (key: IndexPath, value: Task<Void, Never>) in
            value.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restaurantController.updateUserActivity(with: .order)
    }
    
    private func configureUI() {
        navigationItem.leftBarButtonItem = editButtonItem
        
        orderUpdateSubscribe = NotificationCenter.default.publisher(
            for: .orderUpdateNotification,
            object: nil
        ).sink(receiveValue: { [weak self] _ in
            self?.updateUI()
        })
    }
    
    private func updateUI() {
        tableView.reloadData()
    }
    
    @IBAction private func submitTapped(_ sender: UIBarButtonItem) {
        let orderTotal = restaurantController.totalAmount
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
    
    @IBSegueAction private func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder, minutesToPrepare: minutesToPrepareOrder)
    }
    
    @IBAction private func unwindToOrderList(segue: UIStoryboardSegue) {
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
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imageLoadTasks[indexPath]?.cancel()
    }
    
    private func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MenuItemTableViewCell else {
            return
        }
        
        let menuItem = restaurantController.order.menuItems[indexPath.row]
        
        cell.itemName = menuItem.name
        cell.price = menuItem.price
        cell.image = nil
        
        imageLoadTasks[indexPath] = Task {
            if let data = try? await restaurantController.fetchImage(from: menuItem.imageURL),
               let image = UIImage(data: data),
               let currentIndexPath = self.tableView.indexPath(for: cell) {
                cell.image = (currentIndexPath == indexPath) ? image:nil
            } else {
                cell.image = nil
            }
            
            imageLoadTasks[indexPath] = nil
        }
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
