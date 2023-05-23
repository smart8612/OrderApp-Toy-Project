//
//  MenuItem.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import Foundation

struct MenuItem {
    
    var id: Int
    var name: String
    var detailText: String
    var price: Double
    var category: Category
    var imageURL: URL
    
}

extension MenuItem: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case detailText = "description"
        case price
        case category
        case imageURL = "image_url"
    }
    
}
