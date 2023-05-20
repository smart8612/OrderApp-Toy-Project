//
//  OrderViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/20.
//

import Foundation


final class OrderViewModel {
    
    private let restaurantController = RestaurantController.shared
    
    var order: Order {
        get { restaurantController.order }
        set { restaurantController.order = newValue }
    }
    
    var menuItems: [MenuItem] {
        order.menuItems
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
    
    func updateStateRestorationOnOrderScene() {
        restaurantController.updateUserActivity(with: .order)
    }
    
}

extension OrderViewModel: RestaurantAPIFetchable { }
