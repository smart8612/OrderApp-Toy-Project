//
//  SettingsViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/06/01.
//

import UIKit
import SettingsKit


class SettingsViewController: UIViewController {
    
    private var settingViewController: UIViewController {
        MainSettingsPage().viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let viewController = settingViewController
        addChild(viewController)
        view.addSubview(viewController.view)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        viewController.didMove(toParent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerStateRestoration()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        willMove(toParent: nil)
        children.forEach {
            $0.view.removeConstraints($0.view.constraints)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    private func registerStateRestoration() {
        RestaurantController.shared.updateUserActivity(with: .setting)
    }
    
}
