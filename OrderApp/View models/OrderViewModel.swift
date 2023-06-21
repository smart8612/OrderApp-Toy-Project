//
//  OrderViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/20.
//

import Foundation
import OrderClient


final class OrderViewModel {
    
    private let restaurantController = RestaurantController.shared
    
    var menuItems: [MenuItem] {
        restaurantController.order.menuItems
    }
    
    var totalAmount: Double {
        restaurantController.totalAmount
    }
    
    func addOrder(with menuItem: MenuItem) {
        restaurantController.addOrder(with: menuItem)
    }
    
    func deleteOrder(with index: Int) {
        restaurantController.deleteOrder(on: index)
    }
    
    func deleteAllOrder() {
        restaurantController.deleteAllOrder()
    }
    
    func updateStateRestorationOnOrderScene() {
        restaurantController.updateUserActivity(with: .order)
    }
    
    func submitOrder() async throws -> MinutesToPrepare {
        let menuIds = menuItems.map { $0.id }
        return try await submitOrder(forMenuIDs: menuIds)
    }
    
}

extension OrderViewModel: RestaurantAPIFetchable { }
