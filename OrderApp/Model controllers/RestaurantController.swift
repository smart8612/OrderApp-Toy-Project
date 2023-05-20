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
    
    let userActivity = NSUserActivity(activityType: "com.tistory.singularis7.OrderApp.order")
    
    private(set) var order = Order() {
        didSet {
            NotificationCenter.default.post(
                name: .orderUpdateNotification,
                object: nil
            )
            userActivity.order = order
        }
    }
    
    private init() {}
    
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
    
    func updateUserActivity(with controller: StateRestorationController) {
        switch controller {
        case .menu(let category):
            userActivity.menuCategory = category
        case .menuItemDetail(let menuItem):
            userActivity.menuItem = menuItem
        case .order, .categories:
            break
        }
        
        userActivity.controllerIdentifier = controller.identifier
    }
    
}

extension RestaurantController: RestaurantAPIFetchable { }
