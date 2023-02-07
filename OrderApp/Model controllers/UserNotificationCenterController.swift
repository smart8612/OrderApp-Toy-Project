//
//  UserNotificationCenterController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-04.
//

import Foundation
import UserNotifications

final class UserNotificationCenterController {
    
    static let shared = UserNotificationCenterController()
    
    private init() {}
    
    private let center = UNUserNotificationCenter.current()
    
    private var usedAuthorizationOptions: UNAuthorizationOptions {
        [.alert, .badge, .sound]
    }
    
    func configure(with object: UNUserNotificationCenterDelegate) {
        center.delegate = object
        authorizeIfNeeded()
    }
    
    func send<Request: NotificationRequest>(request: Request, completionHandler: ((Error?) -> Void)? = nil) {
        authorizeIfNeeded { [weak self] granted in
            guard granted else {
                DispatchQueue.main.async {
                    completionHandler?(NotificationRequestError.unauthorizedNotification)
                }
                return
            }
            self?.center.add(request.request, withCompletionHandler: completionHandler)
        }
    }
    
    private func authorizeIfNeeded(completion: ((Bool) -> ())? = nil) {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                completion?(true)
            case .notDetermined:
                self.center.requestAuthorization(options: self.usedAuthorizationOptions) { granted, _ in
                    completion?(granted)
                }
            case .denied, .provisional, .ephemeral:
                completion?(false)
            default:
                completion?(false)
            }
        }
    }
    
    enum NotificationRequestError: Error {
        case unauthorizedNotification
    }
    
}
