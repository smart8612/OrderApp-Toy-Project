//
//  RootSplitViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/06/01.
//

import UIKit


final class RootSplitViewController: UISplitViewController {
    
    var selectedMenu: TabItem = .restaurant {
        didSet { updateUI() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        updateUI()
    }
    
    private func updateUI() {
        if !isCollapsed {
            setViewController(selectedMenu.viewController, for: .secondary)
        }
    }
    
}

// MARK: UISplitViewController Delegate
extension RootSplitViewController: UISplitViewControllerDelegate {
    
    func splitViewControllerDidExpand(_ svc: UISplitViewController) {
        updateUI()
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
                return RootSplitViewController.restaurantSceneViewContoller
            case .myOrder:
                return RootSplitViewController.myOrderSceneViewController
            case .settings:
                return RootSplitViewController.settingsSceneViewController
            }
        }
    }
    
}

// MARK: Associated View Controllers
extension RootSplitViewController {
    
    private static var restaurantSceneViewContoller: UIViewController = {
        UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "RestaurantScene")
    }()
    
    private static var myOrderSceneViewController: UIViewController = {
        UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "MyOrderScene")
    }()
    
    private static var settingsSceneViewController: UIViewController = {
        UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "SettingsScene")
    }()
    
}
