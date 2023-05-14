//
//  SettingsViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/08.
//

import Foundation
import UIKit


final class MainSettingsViewModel: SettingPresentable {
    
    private var appearanceSettingController = AppearanceSettingController()
    
    var items: [Item] {
        [
            Item(
                title: "Themes",
                description: appearanceSettingController.currentColorSchemaDescription,
                section: .general,
                isGroup: true,
                isChecked: false
            )
        ]
    }
    
    enum Section: SettingSectionPresentable {
        case general
        
        var title: String? {
            switch self {
            case .general:
                return "General"
            }
        }
        
        var description: String? {
            switch self {
            case .general:
                return "Configure app's general usage experiences."
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

extension MainSettingsViewModel: SettingPresentableDelegate {
    
    func provideSettingViewController(of item: any SettingItemPresentable,
        presentAction: (any SettingItemPresentable, UIViewController) -> Void) {
        if item as! MainSettingsViewModel.Item == items[0] {
            let viewModel = AppearanceSettingsViewModel()
            let viewController = SettingsCollectionViewController(viewModel: viewModel)
            presentAction(item, viewController)
        }
    }
    
}













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
                isChecked: appearanceSettingController.isUnspecifiedColorSchema
            ),
            Item(
                title: "Dark Mode",
                section: .theme,
                isGroup: false,
                isChecked: appearanceSettingController.isUnspecifiedColorSchema
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
                return "Configure app's colot theme schema."
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

protocol SettingSectionPresentable: Hashable {
    
    var title: String? { get }
    var description: String? { get }
    
}

protocol SettingItemPresentable: Hashable {
    
    associatedtype Section: SettingSectionPresentable
    
    var title: String { get }
    var description: String? { get }
    var section: Section { get }
    
    var isGroup: Bool { get }
    var isChecked: Bool { get }
    
}

protocol SettingPresentable {
    
    associatedtype Section: SettingSectionPresentable
    associatedtype Item: SettingItemPresentable
    
    var items: [Item] { get }
    
}


protocol SettingPresentableDelegate: AnyObject {
    
    func provideSettingViewController(of item: any SettingItemPresentable, presentAction: (any SettingItemPresentable, UIViewController) -> Void)
    
}
