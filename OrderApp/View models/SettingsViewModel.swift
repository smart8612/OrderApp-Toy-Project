//
//  SettingsViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/08.
//

import Foundation


struct SettingsViewModel {
    
    var items: [Section: [Item<Int>]] {
        Item<Int>.Keys.allCases.reduce(into: [Section: [Item<Int>]]()) { partialResult, itemCase in
            if partialResult[itemCase.item.section.section] == nil {
                partialResult[itemCase.item.section.section] = [itemCase.item]
            } else {
                partialResult[itemCase.item.section.section]?.append(itemCase.item)
            }
        }
    }
    
    struct Section: Hashable {
        var name: String
        var title: String?
        var description: String?
    }
    
    struct Item<T: Hashable>: Hashable {
        var section: Section.Keys
        var title: String
        var value: T
        var isChecked: Bool
    }
    
}

extension SettingsViewModel.Section {
    
    enum Keys: CaseIterable {
        case theme
        
        var section: SettingsViewModel.Section {
            switch self {
            case .theme:
                return SettingsViewModel.Section(
                    name: "theme",
                    title: "Theme",
                    description: "You can change app's color schema."
                )
            }
        }
    }
    
}

extension SettingsViewModel.Item {
    
    enum ColorSchema: Int {
        case unspecified = 0
        case light = 1
        case dark = 2
    }
    
    enum Keys: CaseIterable {
        case unspectified
        case light
        case dark
        
        var item: SettingsViewModel.Item<Int> {
            switch self {
            case .unspectified:
                return SettingsViewModel.Item<Int>(
                    section: .theme,
                    title: "Use device theme",
                    value: ColorSchema.unspecified.rawValue,
                    isChecked: UserDefaults.standard.isUnspecifiedColorSchema
                )
            case .light:
                return SettingsViewModel.Item<Int>(
                    section: .theme,
                    title: "Light theme",
                    value: ColorSchema.light.rawValue,
                    isChecked: UserDefaults.standard.isLightColorSchema
                )
            case .dark:
                return SettingsViewModel.Item<Int>(
                    section: .theme,
                    title: "Dark theme",
                    value: ColorSchema.dark.rawValue,
                    isChecked: UserDefaults.standard.isDarkColorSchema
                )
            }
        }
    }
    
}
