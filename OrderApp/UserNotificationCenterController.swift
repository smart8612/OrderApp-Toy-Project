//
//  UserNotificationCenterController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-04.
//

import Foundation
import UserNotifications

final class UserNotificationCenterController: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = UserNotificationCenterController()
    
    private override init() {
        super.init()
    }
    
    private let center = UNUserNotificationCenter.current()
    
    private var usedAuthorizationOptions: UNAuthorizationOptions {
        [.alert, .badge, .sound, .provisional]
    }
    
    func configure() {
        center.delegate = self
    }
    
    func send<Request: NotificationRequest>(request: Request, withCompletionHandler: ((Error?) -> Void)?) {
        center.add(request.request, withCompletionHandler: withCompletionHandler)
    }
    
    private func requestPermissions() {
        center.requestAuthorization(options: usedAuthorizationOptions) { granted, error in
            if let error = error {
                // Handle error
                print(error.localizedDescription)
            } else {
                // Enable or disable features based on authorization
            }
        }
    }
    
}
