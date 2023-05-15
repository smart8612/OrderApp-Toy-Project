//
//  AppearanceSettingPage.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/15.
//

import UIKit


struct AppearanceSettingPage: SettingPage {
    
    var title: String? { "Appearance" }
    
    let viewModel = AppearanceSettingsViewModel()
    
    var viewController: UIViewController {
        let viewController = SettingsCollectionViewController(viewModel: viewModel)
        viewController.settingDelegate = viewModel
        viewController.title = title
        return viewController
    }
    
}
