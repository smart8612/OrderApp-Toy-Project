//
//  MainSettingPage.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/15.
//

import UIKit


struct MainSettingPage: SettingPage {
    
    var title: String? { "Setting" }
    
    let viewModel = MainSettingsViewModel()
    
    var viewController: UIViewController {
        let viewController = SettingsCollectionViewController(viewModel: viewModel)
        viewController.settingDelegate = viewModel
        viewController.title = title
        return viewController
    }
    
}
