//
//  RootViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/06/05.
//

import UIKit
import OrderClient


final class RootViewController: UIViewController {
    
    var selectedMenu: TabItem = .restaurant {
        didSet { tabOnChanged(from: oldValue) }
    }
    
    private var svc = createSplitViewScene()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSplitViewController()
        tabOnChanged()
    }
    
    private func tabOnChanged(from oldValue: TabItem? = nil) {
        if traitCollection.horizontalSizeClass == .compact {
            svc.setViewController(selectedMenu.viewController, for: .secondary)
        } else {
            guard let oldValue = oldValue else {
                svc.setViewController(selectedMenu.viewController, for: .secondary)
                return
            }
            
            if oldValue == selectedMenu {
                guard let vc = svc.viewController(for: .secondary) as? UINavigationController else { return }
                vc.popToRootViewController(animated: true)
            } else {
                svc.showDetailViewController(selectedMenu.viewController, sender: self)
            }
        }
    }
    
    func restore(menu categoryName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "menu") {
            return MenuTableViewController(coder: $0, category: categoryName)
        }
        push(viewController)
    }
    
    func restore(menuItemDetail: MenuItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        restore(menu: menuItemDetail.category.name)
        let viewController = storyboard.instantiateViewController(identifier: "menuItemDetail") {
            return MenuItemDetailViewController(coder: $0, menuItem: menuItemDetail)
        }
        push(viewController)
    }
    
    private func push(_ viewController: UIViewController) {
        if traitCollection.horizontalSizeClass == .compact {
            guard let tbc = svc.viewController(for: .compact) as? UITabBarController else { return }
            guard let nvc = tbc.selectedViewController as? UINavigationController else { return }
            nvc.pushViewController(viewController, animated: false)
        } else {
            guard let nvc = svc.viewController(for: .secondary) as? UINavigationController else { return }
            nvc.pushViewController(viewController, animated: false)
        }
    }
    
}

// MARK: View Management
extension RootViewController {
    
    // Root View Controller is container view controller for split view controller
    private func addSplitViewController() {
        addChild(svc)
        view.addSubview(svc.view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: svc.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: svc.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: svc.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: svc.view.trailingAnchor)
        ])
        svc.didMove(toParent: self)
    }
    
    private func removeSplitViewController() {
        willMove(toParent: nil)
        children.forEach {
            $0.view.removeConstraints($0.view.constraints)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
}

// MARK: Types
extension RootViewController {
    
    typealias Item = SidebarCollectionViewController.Item
    
    enum TabItem: Int, CaseIterable {
        case restaurant
        case myOrder
        case settings
        
        var item: Item {
            switch self {
            case .restaurant:
                return Item(title: "Restaurant", image: UIImage(systemName: "list.bullet"))
            case .myOrder:
                return Item(title: "My Order", image: UIImage(systemName: "bag"))
            case .settings:
                return Item(title: "Settings", image: UIImage(systemName: "gear"))
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .restaurant:
                return RootViewController.createRestaurantScene()
            case .myOrder:
                return RootViewController.createMyOrderScene()
            case .settings:
                return RootViewController.createSettingScene()
            }
        }
    }
    
}

// MARK: Associated View Controllers
extension RootViewController {
    
    private static func createSplitViewScene() -> UISplitViewController {
        let svc = UISplitViewController(style: .doubleColumn)
        svc.view.translatesAutoresizingMaskIntoConstraints = false
        svc.setViewController(RootViewController.createSidebarScene(), for: .primary)
        svc.setViewController(TabBarViewController(), for: .compact)
        return svc
    }
    
    private static func createSidebarScene() -> UIViewController {
        SidebarCollectionViewController()
    }
    
    private static func createRestaurantScene() -> UIViewController {
        UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "RestaurantScene")
    }
    
    private static func createMyOrderScene() -> UIViewController {
        UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "MyOrderScene")
    }
    
    private static func createSettingScene() -> UIViewController {
        UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "SettingsScene")
    }
    
}
