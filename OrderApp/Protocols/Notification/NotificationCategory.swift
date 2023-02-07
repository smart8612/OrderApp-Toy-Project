//
//  NotificationCategory.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-07.
//

import Foundation
import UserNotifications

protocol NotificationCategory {
    
    var id: String { get }
    var actions: [UNNotificationAction] { get }
    var category: UNNotificationCategory { get }
    
}

extension NotificationCategory {
    
    var category: UNNotificationCategory {
        UNNotificationCategory(
            identifier: id,
            actions: actions,
            intentIdentifiers: []
        )
    }
    
}
