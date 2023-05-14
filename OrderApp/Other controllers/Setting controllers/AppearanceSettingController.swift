//
//  AppearanceSettingController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/13.
//

import UIKit


struct AppearanceSettingController {
    
    private let preferences = UserDefaults.standard
    
    var currentColorSchemaDescription: String {
        switch preferences.colorSchema {
        case .unspecified:
            return "System Mode"
        case .light:
            return "Light Mode"
        case .dark:
            return "Dark Mode"
        @unknown default:
            return "System Mode"
        }
    }
    
    var isUnspecifiedColorSchema: Bool {
        preferences.colorSchema == .unspecified
    }
    
    var isLightColorSchema: Bool {
        preferences.colorSchema == .light
    }
    
    var isDarkColorSchema: Bool {
        preferences.colorSchema == .dark
    }
    
    func changeColorSchema(to schema: UIUserInterfaceStyle) {
        preferences.colorSchema = schema
    }
    
}
