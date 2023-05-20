//
//  OrderCompleteNotificationCategory.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-07.
//

import Foundation
import UserNotifications
import UserNotificationKit

struct OrderCompleteNotificationCategory: NotificationCategory {
    
    var id: String {
        "OrderConfirmationCategory"
    }
    
    var actions: [UNNotificationAction] {
        [UNNotificationAction(identifier: "confirm", title: "Confirm")]
    }
    
}
