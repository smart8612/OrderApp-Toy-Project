//
//  TabBarViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/06/03.
//

import UIKit
import Combine


final class TabBarViewController: UITabBarController {
    
    private var rootSplitViewController: RootSplitViewController? {
        splitViewController as? RootSplitViewController
    }
    
    private var subscription: AnyCancellable?
    
    private var orderTableViewController: OrderTableViewController? {
        viewControllers?
            .compactMap { $0 as? UINavigationController }
            .compactMap { $0.viewControllers.first as? OrderTableViewController }
            .first as? OrderTableViewController
    }
    
    private var orderTabBarItem: UITabBarItem? {
        orderTableViewController?.tabBarItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribe()
        updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribe()
    }
    
    private func updateUI() {
        orderTabBarItem?.updateOrderBadge()
        selectedIndex = rootSplitViewController?.selectedMenu.rawValue ?? 0
    }
    
    private func subscribe() {
        subscription = NotificationCenter.default.publisher(
            for: .orderUpdateNotification
        ).sink { [weak self] _ in
            self?.updateUI()
        }
    }
    
    private func unsubscribe() {
        subscription?.cancel()
    }
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    typealias TabItem = RootSplitViewController.TabItem
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.selectedIndex
        if let tabItem = TabItem(rawValue: selectedIndex) {
            rootSplitViewController?.selectedMenu = tabItem
        }
    }
    
}

fileprivate extension UITabBarItem {
    
    func updateOrderBadge() {
        let badgeValue = RestaurantController.shared.orderCount
        self.badgeValue = (badgeValue == 0) ? nil : String(badgeValue)
    }
    
}
