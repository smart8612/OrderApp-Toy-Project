//
//  RootSplitViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/06/01.
//

import UIKit


final class RootSplitViewController: UISplitViewController {
    
    var selectedMenu: TabItem = .restaurant {
        didSet { updateUIForSecondary(oldSelectedMenu: oldValue) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
    }
    
    private func updateUIForSecondary(oldSelectedMenu: TabItem) {
        guard traitCollection.horizontalSizeClass != .compact else { return }
        if oldSelectedMenu == selectedMenu {
            guard let secondaryVC = viewController(for: .secondary) as? UINavigationController else { return }
            secondaryVC.popToRootViewController(animated: true)
        } else {
            showDetailViewController(selectedMenu.viewController, sender: self)
        }
    }
    
    private func updateUI() {
        guard traitCollection.horizontalSizeClass != .compact else { return }
        showDetailViewController(selectedMenu.viewController, sender: self)
    }
    
}

// MARK: Types
extension RootSplitViewController {
    
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
                return RootSplitViewController.createRestaurantScene()
            case .myOrder:
                return RootSplitViewController.createMyOrderScene()
            case .settings:
                return RootSplitViewController.createSettingScene()
            }
        }
    }
    
}

// MARK: Associated View Controllers
extension RootSplitViewController {
    
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
