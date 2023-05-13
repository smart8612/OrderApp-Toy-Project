//
//  AppearanceSettingController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/13.
//

import Foundation


struct AppearanceSettingController {
    
    private let preferences = UserDefaults.standard
    
    var currentColorSchema: String {
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
    
}
