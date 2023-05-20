//
//  RestaurantController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-28.
//

import Foundation
import NetworkKit

final class RestaurantController {
    
    static let shared = RestaurantController()
    
    private init() {}
    
    private(set) var order = Order() {
        didSet {
            NotificationCenter.default.post(
                name: .orderUpdateNotification,
                object: nil
            )
            userActivity.order = order
        }
    }
    
    var totalAmount: Double {
        order.totalAmount
    }
    
    func addOrder(with menuItem: MenuItem) {
        order.addOrder(with: menuItem)
    }
    
    func deleteOrder(with index: Int) {
        order.deleteOrder(on: index)
    }
    
    func deleteAllOrder() {
        order.deleteAllOrder()
    }
    
    func restore(order: Order) {
        self.order = order
    }
    
}

extension RestaurantController: RestaurantAPIFetchable { }

extension RestaurantController: OrderStateRestorable { }
