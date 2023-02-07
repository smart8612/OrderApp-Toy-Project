//
//  NotificationRequest.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-04.
//

import Foundation
import UserNotifications

protocol NotificationRequest {
    
    var id: String { get }
    var category: NotificationCategory? { get }
    var content: UNNotificationContent { get }
    var trigger: UNNotificationTrigger { get }
    var request: UNNotificationRequest { get }
    
}

extension NotificationRequest {
    
    var request: UNNotificationRequest {
        UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
    }
    
}
