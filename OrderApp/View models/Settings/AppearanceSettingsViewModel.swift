//
//  AppearanceSettingsViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/14.
//

import Foundation


final class AppearanceSettingsViewModel: SettingPresentable {
    
    private var appearanceSettingController = AppearanceSettingController()
    
    var items: [Item] {
        [
            Item(
                title: "System Default",
                section: .theme,
                isGroup: false,
                isChecked: appearanceSettingController.isUnspecifiedColorSchema
            ),
            Item(
                title: "Light Mode",
                section: .theme,
                isGroup: false,
                isChecked: appearanceSettingController.isLightColorSchema
            ),
            Item(
                title: "Dark Mode",
                section: .theme,
                isGroup: false,
                isChecked: appearanceSettingController.isDarkColorSchema
            ),
        ]
    }
    
    enum Section: SettingSectionPresentable {
        case theme
        
        var title: String? {
            switch self {
            case .theme:
                return "Theme"
            }
        }
        
        var description: String? {
            switch self {
            case .theme:
                return "Configure app's color theme schema."
            }
        }
    }
    
    struct Item: SettingItemPresentable {
        
        var title: String
        var description: String?
        var section: Section
        
        var isGroup: Bool
        var isChecked: Bool
        
    }
    
}

extension AppearanceSettingsViewModel: SettingPresentableDelegate {
    
    func provideSettingViewController(of item: any SettingItemPresentable, presentAction: ((any SettingPage)?) -> Void) {
        presentAction(nil)
    }
    
    func action(for item: any SettingItemPresentable) {
        guard let item = item as? AppearanceSettingsViewModel.Item else { return }
        let items = items
        
        if item == items[0] {
            appearanceSettingController.changeColorSchema(to: .unspecified)
        } else if item == items[1] {
            appearanceSettingController.changeColorSchema(to: .light)
        } else if item == items[2] {
            appearanceSettingController.changeColorSchema(to: .dark)
        }
    }
    
}
