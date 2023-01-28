//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit

@MainActor
class CategoryTableViewController: UITableViewController {
    
    private let restautantController = RestaurantController()
    private var categories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        print("Finish View Did Load")
    }
    
    private func configureUI() {
        Task {
            do {
                let categories = try await restautantController.fetchCategories()
                updateUI(with: categories)
            } catch {
                displayError(error, title: "Failed to Fetch Categories")
            }
        }
    }
    
    private func updateUI(with categories: [String]) {
        self.categories = categories
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
    
    func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = category.capitalized
        cell.contentConfiguration = contentConfiguration
    }
    
}
