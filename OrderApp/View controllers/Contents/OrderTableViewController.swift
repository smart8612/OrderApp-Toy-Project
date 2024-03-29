//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit
import Combine


final class OrderTableViewController: UITableViewController {
    
    private var minutesToPrepareOrder = 0
    
    private let viewModel = OrderViewModel()
    private var imageLoadTasks: [IndexPath:Task<Void, Never>] = [:]
    private var orderUpdateSubscription: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerStateRestoration()
        registerSubscription()
        updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelSubscription()
        cancelAllImageLoadTasks()
    }
    
    @IBAction private func submitButtonTapped(_ sender: UIBarButtonItem) {
        presentOrderAlert()
    }
    
    @IBSegueAction private func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder, minutesToPrepare: minutesToPrepareOrder)
    }
    
}

// MARK: Helper function
extension OrderTableViewController {
    
    private func uploadOrder() {
        Task {
            do {
                let minutesToPrepare = try await viewModel.submitOrder()
                minutesToPrepareOrder = minutesToPrepare
                performSegue(withIdentifier: "confirmOrder", sender: nil)
            } catch {
                displayError(error, title: "Order Submission Failed")
            }
        }
    }
    
}

// MARK: Presentation Handling function
extension OrderTableViewController {
    
    private func configureUI() {
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    private func updateUI() {
        tableView.reloadData()
    }
    
    private func presentOrderAlert() {
        let orderTotal = viewModel.totalAmount
        let formattedTotal = orderTotal.formatted(.currency(code: "usd"))
        
        displayAlert(
            preferredStyle: .alert,
            title: "Confirm Order",
            message: "You are about to submit your order with a total of \(formattedTotal)",
            actions: [
                UIAlertAction(title: "Submit", style: .default) { _ in
                    self.uploadOrder()
                },
                UIAlertAction(title: "Cancel", style: .cancel)
        ])
    }
    
}

// MARK: Register Handling function
extension OrderTableViewController {
    
    private func registerStateRestoration() {
        viewModel.updateStateRestorationOnOrderScene()
    }
    
}

// MARK: Subscription Handling function
extension OrderTableViewController {
    
    private func registerSubscription() {
        orderUpdateSubscription = NotificationCenter.default.publisher(
            for: .orderUpdateNotification
        ).sink { [weak self] _ in
            self?.updateUI()
        }
    }
    
    private func cancelSubscription() {
        orderUpdateSubscription?.cancel()
    }
    
}

// MARK: Task Handling function
extension OrderTableViewController {
    
    private func cancelAllImageLoadTasks() {
        imageLoadTasks.forEach { (key: IndexPath, value: Task<Void, Never>) in
            value.cancel()
        }
    }
    
}

// MARK: TableView & DataSource Handling Code
extension OrderTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    private func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MenuItemTableViewCell else { return }
        let menuItem = viewModel.menuItems[indexPath.row]
        
        cell.itemName = menuItem.name
        cell.price = menuItem.price
        cell.image = nil
        
        imageLoadTasks[indexPath] = Task {
            if let data = try? await viewModel.fetchImage(from: menuItem.imageURL),
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
            viewModel.deleteOrder(with: indexPath.row)
        }
    }
    
}
