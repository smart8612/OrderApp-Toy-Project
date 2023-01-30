//
//  RestaurantController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-28.
//

import Foundation

class RestaurantController {
    
    typealias MinutesToPrepare = Int
    
    static let shared = RestaurantController()
    
    private let networkController = NetworkController()
    private(set) var order = Order() {
        didSet {
            NotificationCenter.default.post(
                name: RestaurantController.orderUpdateNotification,
                object: nil
            )
        }
    }
    
    private init() {}
    
    func addOrder(with menuItem: MenuItem) {
        order.menuItems.append(menuItem)
    }
    
    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        let apiRequest = RestaurantOrderPostAPIRequest(menuIDs: menuIDs)
        let result = try await networkController.send(request: apiRequest)
        return result.preperationTime
    }
    
    func fetchCategories() async throws -> [String] {
        let apiRequest = RestaurantCategoriesGetAPIRequest()
        let result = try await networkController.send(request: apiRequest)
        return result.categories
    }
    
    func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
        let apiRequest = RestaurantMenuItemsGetAPIRequest(categoryName: categoryName)
        let result = try await networkController.send(request: apiRequest)
        return result.items
    }
    
}


extension RestaurantController {
    
    static let orderUpdateNotification = Notification.Name("RestaurantController.orderUpdated")
    
}
