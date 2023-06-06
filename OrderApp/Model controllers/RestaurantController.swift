//
//  RestaurantController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-28.
//

import Foundation
import OrderClient


final class RestaurantController {
    
    static let shared = RestaurantController()
    
    private init() {}
    
    private(set) var orderController = OrderController(order: .init()) {
        didSet { updateState() }
    }
    
    var order: Order {
        get { orderController.order }
        set { orderController = OrderController(order: newValue) }
    }
    
    var userActivity = NSUserActivity(activityType: "com.tistory.singularis7.OrderApp.order")
    
    func updateUserActivity(with controller: StateRestorationController) {
        switch controller {
        case .menu(let category):
            userActivity.menuCategory = category
        case .menuItemDetail(let menuItem):
            userActivity.menuItem = menuItem
        case .order, .categories, .setting:
            break
        }
        
        userActivity.controllerIdentifier = controller.identifier
    }
    
    var menuItems: [MenuItem] {
        order.menuItems
    }
    
    var orderCount: Int {
        menuItems.count
    }
    
    var totalAmount: Double {
        orderController.totalAmount
    }
    
    func addOrder(with menuItem: MenuItem) {
        orderController.addOrder(with: menuItem)
    }
    
    func deleteOrder(on index: Int) {
        orderController.deleteOrder(on: index)
    }
    
    func deleteAllOrder() {
        orderController.deleteAllOrder()
    }
    
    func restore(order: Order) {
        self.order = order
    }
    
    private func updateState() {
        postOrderUpdateNotification()
        updateOrderState()
    }
    
    private func postOrderUpdateNotification() {
        NotificationCenter.default.post(
            name: .orderUpdateNotification,
            object: nil
        )
    }
    
    private func updateOrderState() {
        userActivity.order = orderController.order
    }
    
}

extension RestaurantController: RestaurantAPIFetchable { }
