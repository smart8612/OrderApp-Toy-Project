//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    private var order = Order()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension OrderTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = order.menuItems[indexPath.row]
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = menuItem.name
        contentConfiguration.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
        cell.contentConfiguration = contentConfiguration
    }
    
}
