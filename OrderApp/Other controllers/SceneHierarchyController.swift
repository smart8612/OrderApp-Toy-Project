//
//  SceneHierarchyController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-04.
//

import UIKit
import Combine

final class SceneHierarchyController {
    
    weak var delegate: SceneHierarchyControllerDelegate?
    private var subscriptions: [Cancellable]?
    
    private weak var window: UIWindow?
    
    private var rootTabBarController: UITabBarController? {
        window?.rootTabBarController
    }
    
    private var orderTabBarItem: UITabBarItem? {
        rootTabBarController?.orderViewController?.tabBarItem
    }
    
    func configure(with delegate: SceneHierarchyControllerDelegate) {
        self.delegate = delegate
        window = self.delegate?.loadUIHirarchy()
        configureUI()
        subscribe()
    }
    
    deinit {
        cancelAllSubscriptions()
    }
    
}

// MARK: UI Presentation Handler
fileprivate extension SceneHierarchyController {
    
    private func configureUI() {
        configureGlobalUI()
    }
    
    private func configureGlobalUI() {
        window?.overrideUserInterfaceStyle = UserDefaults.standard.colorSchema
    }

}

// MARK: Combine Subscription Handler
fileprivate extension SceneHierarchyController {
    
    private func subscribe() {
        subscriptions = [
            NotificationCenter.default.publisher(
                for: .orderUpdateNotification
            ).sink { [weak self] _ in
                self?.orderTabBarItem?.updateOrderBadge()
            },
            NotificationCenter.default.publisher(
                for: UserDefaults.didChangeNotification
            ).sink { [weak self] _ in
              self?.configureGlobalUI()
            }
        ]
    }
    
    private func cancelAllSubscriptions() {
        subscriptions?.forEach { $0.cancel() }
    }
    
}

// MARK: UIWindow Handler
fileprivate extension UIWindow {
    
    var rootTabBarController: UITabBarController? {
        self.rootViewController as? UITabBarController
    }
    
}

// MARK: Root Tab Bar Controller Handler
fileprivate extension UITabBarController {
    
    var orderViewController: UIViewController? {
        self.viewControllers?[1]
    }
    
}

// MARK: Order Tab Bar Item Handler
fileprivate extension UITabBarItem {
    
    func updateOrderBadge() {
        let badgeValue = RestaurantController.shared.order.menuItems.count
        self.badgeValue = (badgeValue == 0) ? nil : String(badgeValue)
    }
    
}
