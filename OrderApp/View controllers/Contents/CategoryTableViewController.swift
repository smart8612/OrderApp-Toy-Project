//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit


final class CategoryTableViewController: UITableViewController {
    
    private let restaurantController = RestaurantController.shared
    private var categories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTargetAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerStateRestoration()
        updateUI()
    }
    
    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        guard let category = sender as? String else { return nil }
        return MenuTableViewController(coder: coder, category: category)
    }
    
}

// MARK: Register Handling function
extension CategoryTableViewController {
    
    private func registerStateRestoration() {
        restaurantController.updateUserActivity(with: .categories)
    }
    
    private func registerTargetAction() {
        refreshControl?.addTarget(self, action: #selector(updateUI), for: .valueChanged)
    }
    
}

// MARK: Presentation Handling function
extension CategoryTableViewController {
    
    @objc
    private func updateUI() {
        Task {
            do {
                let categories = try await restaurantController.fetchCategories()
                applyUI(with: categories.map { $0.name })
            } catch {
                displayError(error, title: "Failed to Fetch Categories")
            }
            refreshControl?.endRefreshing()
        }
    }
    
    private func applyUI(with categories: [String]) {
        self.categories = categories
        tableView.reloadData()
    }
    
}

// MARK: TableView & DataSource Handling Code
extension CategoryTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        performSegue(withIdentifier: Keys.showMenuSegue.id, sender: category)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
    
    private enum Keys: String {
        case showMenuSegue
        
        var id: String {
            self.rawValue
        }
    }
    
}
