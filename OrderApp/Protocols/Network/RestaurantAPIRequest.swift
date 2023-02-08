//
//  RestaurantAPIRequest.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import Foundation

protocol RestaurantAPIRequest: APIRequest {
    
    var baseURL: URL? { get }
    
}

extension RestaurantAPIRequest {
    
    var baseURL: URL? {
        URL(string: "http://localhost:8080/")
    }
    
}
