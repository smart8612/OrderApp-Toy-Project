//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit

@MainActor
final class MenuTableViewController: UITableViewController {
    
    private let restaurantController = RestaurantController.shared
    private var menuItems: [MenuItem] = []
    private let category: String
    private var imageLoadTasks: [IndexPath:Task<Void, Never>] = [:]
    
    init?(coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        imageLoadTasks.forEach { (key: IndexPath, value: Task<Void, Never>) in
            value.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        title = category.capitalized
        
        Task {
            do {
                let menuItems = try await restaurantController.fetchMenuItems(forCategory: category)
                updateUI(with: menuItems)
            } catch {
                displayError(error, title: "Failed to fetch menu items for \(self.category)")
            }
        }
    }
    
    private func updateUI(with menuItems: [MenuItem]) {
        self.menuItems = menuItems
        tableView.reloadData()
    }
    
    @IBSegueAction private func showMenuDetail(_ coder: NSCoder, sender: Any?) -> MenuItemDetailViewController? {
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        let menuItem = menuItems[indexPath.row]
        return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
    }
    
}

// MARK: TableView & DataSource Handling Code
extension MenuTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imageLoadTasks[indexPath]?.cancel()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    private func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MenuItemTableViewCell else {
            return
        }
        
        let menuItem = menuItems[indexPath.row]
        
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
    
}
