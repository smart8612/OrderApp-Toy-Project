//
//  AppDelegate.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit
import UserNotifications
import UserNotificationKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let userNotificationCenterController = UserNotificationCenterController.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        userNotificationCenterController.configure(with: self)
        userNotificationCenterController.setCategories([OrderCompleteNotificationCategory()])
        configureSharedURLCache()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

// MARK: Handling User Notification Event
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification here
        // ** MUST call completion handler when finished! **
        
        switch response.actionIdentifier {
        case "confirm":
            print("confirm category clicked")
        default:
            break
        }
        
        completionHandler()
    }
    
}

// MARK: Configure Caching For URLSession Code
extension AppDelegate {
    
    private func configureSharedURLCache() {
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(
            memoryCapacity: 25_000_000,
            diskCapacity: 50_000_000,
            diskPath: temporaryDirectory
        )
        URLCache.shared = urlCache
    }
    
}
