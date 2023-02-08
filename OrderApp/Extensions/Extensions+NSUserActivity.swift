//
//  Extensions+NSUserActivity.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-08.
//

import Foundation

extension NSUserActivity {
    
    var order: Order? {
        get {
            guard let jsonData = userInfo?[Keys.order.rawValue] as? Data else {
                return nil
            }
            
            return try? JSONDecoder().decode(Order.self, from: jsonData)
        }
        set {
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue) {
                userInfo?[Keys.order.rawValue] = jsonData
            } else {
                userInfo?[Keys.order.rawValue] = nil
            }
        }
    }
    
    var controllerIdentifier: StateRestorationController.Identifier? {
        get {
            if let controllerIdentifierString = userInfo?[Keys.controllerIdentifier.rawValue] as? String {
                return .init(rawValue: controllerIdentifierString)
            } else {
                return nil
            }
        }
        set {
            userInfo?[Keys.controllerIdentifier.rawValue] = newValue?.rawValue
        }
    }
    
    var menuCategory: String? {
        get {
            return userInfo?[Keys.menuCategory.rawValue] as? String
        }
        set {
            userInfo?[Keys.menuCategory.rawValue] = newValue
        }
    }
    
    var menuItem: MenuItem? {
        get {
            guard let jsonData = userInfo?[Keys.menuItem.rawValue] as? Data else {
                return nil
            }
            return try? JSONDecoder().decode(MenuItem.self, from: jsonData)
        }
        set {
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue) {
                userInfo?[Keys.menuItem.rawValue] = jsonData
            } else {
                userInfo?[Keys.menuItem.rawValue] = nil
            }
        }
    }
    
    enum Keys: String {
        
        case order
        case controllerIdentifier
        case menuCategory
        case menuItem
        
    }
    
}
