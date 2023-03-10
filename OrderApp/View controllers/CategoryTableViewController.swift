//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit

@MainActor
final class CategoryTableViewController: UITableViewController {
    
    private let restaurantController = RestaurantController.shared
    private var categories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        restaurantController.updateUserActivity(with: .categories)
    }
    
    private func configureUI() {
        Task {
            do {
                let categories = try await restaurantController.fetchCategories()
                updateUI(with: categories)
            } catch {
                displayError(error, title: "Failed to Fetch Categories")
            }
        }
    }
    
    private func updateUI(with categories: [String]) {
        self.categories = categories
        tableView.reloadData()
    }
    
    @IBSegueAction private func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        guard let cell = sender as? UITableViewCell,
              let indexPath = self.tableView.indexPath(for: cell) else {
                  return nil
              }
        let category = categories[indexPath.row]
        return MenuTableViewController(coder: coder, category: category)
    }
    
}

// MARK: TableView & DataSource Handling Code
extension CategoryTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        configureCell(cell, forCategoryAt: indexPath)
        return cell
    }
    
    private func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = category.capitalized
        cell.contentConfiguration = contentConfiguration
    }
    
}
