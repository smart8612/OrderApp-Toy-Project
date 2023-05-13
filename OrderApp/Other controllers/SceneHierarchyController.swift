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
    
    private var subscriptions: [Cancellable]?
    private weak var orderTabBarItem: UITabBarItem?
    
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
        window?.overrideUserInterfaceStyle = UserDefaults.standard.colorSchema
    }
    
    private func configureTabBarUI() {
        guard let rootTabBarController = window?.rootViewController as? UITabBarController,
              let orderTabBarItem = rootTabBarController.viewControllers?[1].tabBarItem else {
            return
        }
        
        configureSetting(on: rootTabBarController)
        
        self.orderTabBarItem = orderTabBarItem
    }
    
    private func configureSetting(on tabBarController: UITabBarController) {
        let settingVC = UINavigationController(rootViewController: SettingTabVC)
        settingVC.title = "Setting"
        settingVC.navigationBar.prefersLargeTitles = true
        settingVC.tabBarItem?.image = UIImage(systemName: "gear")
        tabBarController.viewControllers?.append(settingVC)
    }
    
    private let SettingTabVC: SettingsCollectionViewController<MainSettingsViewModel> = {
        let viewController = SettingsCollectionViewController(viewModel: MainSettingsViewModel())
        viewController.title = "Setting"
        return viewController
    }()
    
    private func subscribe() {
        subscriptions = [
            NotificationCenter.default.publisher(
                for: .orderUpdateNotification
            ).sink { [weak self] _ in
                let badgeValue = RestaurantController.shared.order.menuItems.count
                self?.orderTabBarItem?.badgeValue = (badgeValue == 0) ? nil : String(badgeValue)
            },
            NotificationCenter.default.publisher(
                for: UserDefaults.didChangeNotification
            ).sink { [weak self] _ in
              self?.configureGlobalUI()
            }
        ]
    }
    
    private func unsubscribe() {
        subscriptions?.forEach { $0.cancel() }
    }
    
    deinit {
        unsubscribe()
    }
    
}
