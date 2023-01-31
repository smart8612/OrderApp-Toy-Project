//
//  Order.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import Foundation

struct Order: Codable {
    
    private(set) var menuItems: [MenuItem] = []
    
    var totalAmount: Double {
        menuItems.reduce(0.0) { $0 + $1.price }
    }
    
    mutating func addOrder(with menuItem: MenuItem) {
        menuItems.append(menuItem)
    }
    
    mutating func deleteOrder(on index: Int) {
        menuItems.remove(at: index)
    }
    
    mutating func deleteAllOrder() {
        menuItems.removeAll()
    }
    
}
