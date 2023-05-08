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
    
    private weak var window: UIWindow?
    
    private var orderUpdateSubscribe: Cancellable?
    private weak var orderTabBarItem: UITabBarItem?
    
    private let settings = SettingsController()
    
    func configure(with delegate: SceneHierarchyControllerDelegate) {
        self.delegate = delegate
        window = self.delegate?.loadUIHirarchy()
        configureUI()
        subscribe()
    }
    
    private func configureUI() {
        configureGlobalUI()
        configureTabBarUI()
    }
    
    private func configureGlobalUI() {
        window?.overrideUserInterfaceStyle = settings.colorSchema
    }
    
    private func configureTabBarUI() {
        guard let rootTabBarController = window?.rootViewController as? UITabBarController,
              let orderTabBarItem = rootTabBarController.viewControllers?[1].tabBarItem else {
            return
        }
        
        self.orderTabBarItem = orderTabBarItem
    }
    
    private func subscribe() {
        orderUpdateSubscribe = NotificationCenter.default.publisher(
            for: .orderUpdateNotification,
            object: nil
        ).sink(receiveValue: { [weak self] _ in
            let badgeValue = RestaurantController.shared.order.menuItems.count
            self?.orderTabBarItem?.badgeValue = (badgeValue == 0) ? nil : String(badgeValue)
        })
    }
    
    private func unsubscribe() {
        orderUpdateSubscribe?.cancel()
    }
    
    deinit {
        unsubscribe()
    }
    
}
