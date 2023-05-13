//
//  SettingsViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/08.
//

import Foundation


final class MainSettingsViewModel: SettingPresentable {
    
    private var appearanceSettingController = AppearanceSettingController()
    
    var items: [Item] {
        [
            Item(
                title: "Themes",
                description: appearanceSettingController.currentColorSchema,
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
