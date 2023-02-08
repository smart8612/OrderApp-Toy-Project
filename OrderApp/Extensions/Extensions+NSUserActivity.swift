//
//  Extensions+NSUserActivity.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-08.
//

import Foundation

extension NSUserActivity {
    
    var order: Order? {
        get {
            guard let jsonData = userInfo?["order"] as? Data else {
                return nil
            }
            
            return try? JSONDecoder().decode(Order.self, from: jsonData)
        }
        set {
            if let newValue = newValue, let jsonData = try? JSONEncoder().encode(newValue) {
                userInfo?["order"] = jsonData
            } else {
                userInfo?["order"] = nil
            }
        }
    }
    
}
