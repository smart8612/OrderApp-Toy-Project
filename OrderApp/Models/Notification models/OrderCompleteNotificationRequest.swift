//
//  OrderCompleteNotificationRequest.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-05.
//

import Foundation
import UserNotifications

struct OrderCompleteNotificationRequest: NotificationRequest {
    
    let minutesToPrepare: Int
    let title: String
    let body: String
    
    private let secondPerMinute = 1.0
    
    var secondsToPrepare: TimeInterval {
        TimeInterval(minutesToPrepare) * secondPerMinute
    }
    
    var id: String {
        UUID().uuidString
    }
    
    var category: NotificationCategory? {
        OrderCompleteNotificationCategory()
    }
    
    var content: UNNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.sound = .default
        content.title = title
        content.body = body
        
        if let categoryId = category?.id {
            content.categoryIdentifier = categoryId
        }
        
        return content
    }
    
    var trigger: UNNotificationTrigger {
        UNTimeIntervalNotificationTrigger(
            timeInterval: secondsToPrepare,
            repeats: false)
    }
    
}
