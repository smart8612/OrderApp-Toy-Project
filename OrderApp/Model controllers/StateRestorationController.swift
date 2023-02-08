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
