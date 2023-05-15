//
//  SettingItemPresentable.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/14.
//

import Foundation

protocol SettingItemPresentable: Hashable {
    
    associatedtype Section: SettingSectionPresentable
    
    var title: String { get }
    var description: String? { get }
    var section: Section { get }
    
    var isGroup: Bool { get }
    var isChecked: Bool { get }
    
}
