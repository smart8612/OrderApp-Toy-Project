//
//  SettingsViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/06/01.
//

import UIKit
import SettingKit


class SettingsViewController: UIViewController {
    
    private var settingViewController: UIViewController {
        MainSettingPage().viewController
    }
    
    override func viewDidLoad() {
        let viewController = settingViewController
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
}
