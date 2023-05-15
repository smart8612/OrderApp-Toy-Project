//
//  SettingPage.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/15.
//

import Foundation


protocol SettingPage {
    
    associatedtype ViewModelType: SettingPresentable
    
    var title: String? { get }
    var viewModel: ViewModelType { get }
    var viewController: UIViewController { get }
    
}

extension SettingPage {
    
    var viewControllerEmbeddedInNavigationController: UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.title = title
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
}
