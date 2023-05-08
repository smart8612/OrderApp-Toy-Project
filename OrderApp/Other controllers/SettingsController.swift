//
//  SettingsController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/08.
//

import UIKit

struct SettingsController {
    
    let userDefaults = UserDefaults.standard
    
    var colorSchema: UIUserInterfaceStyle {
        set {
            userDefaults.set(newValue.rawValue, forKey: Keys.colorSchema.rawValue)
        }
        get {
            let value = userDefaults.integer(forKey: Keys.colorSchema.rawValue)
            return UIUserInterfaceStyle(rawValue: value) ?? .unspecified
        }
    }
    
    enum Keys: String, CaseIterable {
        case colorSchema
    }
    
}
