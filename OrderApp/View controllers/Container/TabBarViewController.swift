//
//  TabBarViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/06/03.
//

import UIKit
import Combine


final class TabBarViewController: UITabBarController {
    
    private var rootViewController: RootViewController? {
        splitViewController?.parent as? RootViewController
    }
    
    private var subscription: AnyCancellable?
    
    private var orderTableViewController: UIViewController? {
        viewControllers?[1]
    }
    
    private var orderTabBarItem: UITabBarItem? {
        orderTableViewController?.tabBarItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        addChildren()
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
    
    private func addChildren() {
        let childVCs = TabItem.allCases
            .map { ($0.viewController, UITabBarItem(title: $0.item.title , image: $0.item.image, tag: $0.rawValue)) }
            .map { $0.tabBarItem = $1; return $0 }
        setViewControllers(childVCs, animated: false)
    }
    
    private func updateUI() {
        guard let rootViewController = rootViewController else { return }
        let index = rootViewController.selectedMenu.rawValue
        print(index)
        selectedViewController = viewControllers?[index]
        orderTabBarItem?.updateOrderBadge()
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
    
    typealias TabItem = RootViewController.TabItem
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.selectedIndex
        if let tabItem = TabItem(rawValue: selectedIndex) {
            rootViewController?.selectedMenu = tabItem
        }
    }
    
}

fileprivate extension UITabBarItem {
    
    func updateOrderBadge() {
        let badgeValue = RestaurantController.shared.orderCount
        self.badgeValue = (badgeValue == 0) ? nil : String(badgeValue)
    }
    
}
