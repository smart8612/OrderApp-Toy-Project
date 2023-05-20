//
//  RestaurantController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-28.
//

import Foundation

final class RestaurantController {
    
    static let shared = RestaurantController()
    
    private init() {}
    
    var order = Order() {
        didSet {
            postOrderUpdateNotification()
            updateOrderState()
        }
    }
    
    func restore(order: Order) {
        self.order = order
    }
    
    private func postOrderUpdateNotification() {
        NotificationCenter.default.post(
            name: .orderUpdateNotification,
            object: nil
        )
    }
    
    private func updateOrderState() {
        userActivity.order = order
    }
    
}

extension RestaurantController: RestaurantAPIFetchable { }

extension RestaurantController: OrderStateRestorable { }
