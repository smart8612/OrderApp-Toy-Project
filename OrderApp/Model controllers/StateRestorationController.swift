//
//  StateRestorationController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-08.
//

import Foundation

enum StateRestorationController {
    
    enum Identifier: String {
        case categories, menu, menuItemDetail, order
    }
    
    init?(userActivity: NSUserActivity) {
        guard let identifier = userActivity.controllerIdentifier else {
            return nil
        }
        
        switch identifier {
        case .categories:
            self = .categories
        case .menu:
            if let category = userActivity.menuCategory {
                self = .menu(category: category)
            } else {
                return nil
            }
        case .menuItemDetail:
            if let menuItem = userActivity.menuItem {
                self = .menuItemDetail(menuItem)
            } else {
                return nil
            }
        case .order:
            self = .order
        }
    }
    
    case categories
    case menu(category: String)
    case menuItemDetail(MenuItem)
    case order
    
    var identifier: Identifier {
        switch self {
        case .categories:
            return .categories
        case .menu:
            return .menu
        case .menuItemDetail:
            return .menuItemDetail
        case .order:
            return .order
        }
    }
    
}
