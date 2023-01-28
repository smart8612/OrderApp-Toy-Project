//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit

@MainActor
class MenuTableViewController: UITableViewController {
    
    private let restaurantController = RestaurantController()
    private var menuItems: [MenuItem] = []
    private let category: String
    
    init?(coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        self.title = category.capitalized
        
        Task {
            do {
                let menuItems = try await restaurantController.fetchMenuItems(forCategory: category)
                updateUI(with: menuItems)
            } catch {
                displayError(
                    error,
                    title: "Failed to fetch menu items for \(self.category)"
                )
            }
        }
    }
    
    private func updateUI(with menuItems: [MenuItem]) {
        self.menuItems = menuItems
        self.tableView.reloadData()
    }
    
    private func displayError(_ error: Error, title: String) {
        guard self.isOnScreen else { return }
        
        let alert = UIAlertController(
            title: title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Dismiss", style: .default)
        )
        self.present(alert, animated: true)
    }

}

extension MenuTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    private func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = menuItem.name
        contentConfiguration.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
        cell.contentConfiguration = contentConfiguration
    }
    
}
