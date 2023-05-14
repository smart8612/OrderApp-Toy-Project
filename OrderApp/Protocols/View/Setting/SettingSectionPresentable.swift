//
//  SettingSectionPresentable.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/14.
//

import Foundation

protocol SettingSectionPresentable: Hashable {
    
    var title: String? { get }
    var description: String? { get }
    
}
