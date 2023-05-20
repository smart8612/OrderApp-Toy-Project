//
//  OrderStateRestorable.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/20.
//

import Foundation


protocol OrderStateRestorable { }

extension OrderStateRestorable {
    
    var userActivity: NSUserActivity {
        NSUserActivity(activityType: "com.tistory.singularis7.OrderApp.order")
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
