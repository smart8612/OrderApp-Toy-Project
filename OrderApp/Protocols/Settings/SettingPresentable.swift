//
//  SettingPresentable.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/14.
//

import Foundation

protocol SettingPresentable {
    
    associatedtype Section: SettingSectionPresentable
    associatedtype Item: SettingItemPresentable
    
    var items: [Item] { get }
    
}
