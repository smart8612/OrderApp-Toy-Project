//
//  SettingsViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/08.
//

import Foundation

final class SettingsViewModel {
    
    private let preferences = UserDefaults.standard
    
    var items: [Section: [Item<Int>]] {
        [.theme: [
            Item(title: "Use device theme", value: ColorSchema.unspecified.rawValue,
                 isChecked: preferences.isUnspecifiedColorSchema),
            Item(title: "Dark theme", value: ColorSchema.dark.rawValue,
                 isChecked: preferences.isDarkColorSchema),
            Item(title: "Light theme", value: ColorSchema.light.rawValue,
                 isChecked: preferences.isLightColorSchema)
        ]]
    }
    
    enum ColorSchema: Int {
        case unspecified = 0
        case light = 1
        case dark = 2
    }
    
    enum Section: CaseIterable {
        case theme
    }
    
    struct Item<T: Hashable>: Hashable {
        var title: String
        var value: T
        var isChecked: Bool
    }
    
}
