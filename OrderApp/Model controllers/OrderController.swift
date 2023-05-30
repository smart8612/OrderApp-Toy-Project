//
//  OrderController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/29.
//

import Foundation
import OrderClient


struct OrderController {
    
    private(set) var order: Order
    
    var menuItems: [MenuItem] {
        order.menuItems
    }
    
    var totalAmount: Double {
        menuItems.reduce(0.0) { $0 + $1.price }
    }
    
    mutating func addOrder(with menuItem: MenuItem) {
        order.menuItems.append(menuItem)
    }
    
    mutating func deleteOrder(on index: Int) {
        order.menuItems.remove(at: index)
    }
    
    mutating func deleteAllOrder() {
        order.menuItems.removeAll()
    }
    
}
