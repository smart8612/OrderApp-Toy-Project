//
//  Extensions+UserDefaults.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/08.
//

import UIKit

extension UserDefaults {
    
    var colorSchema: UIUserInterfaceStyle {
        set {
            Self.standard.set(newValue.rawValue, forKey: Keys.colorSchema.rawValue)
        }
        get {
            let value = Self.standard.integer(forKey: Keys.colorSchema.rawValue)
            return UIUserInterfaceStyle(rawValue: value) ?? .unspecified
        }
    }
    
    var isUnspecifiedColorSchema: Bool {
        colorSchema == .unspecified
    }
    
    var isLightColorSchema: Bool {
        colorSchema == .light
    }
    
    var isDarkColorSchema: Bool {
        colorSchema == .dark
    }
    
    enum Keys: String, CaseIterable {
        case colorSchema
    }
    
}
