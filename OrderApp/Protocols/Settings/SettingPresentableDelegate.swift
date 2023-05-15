//
//  SettingPresentableDelegate.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/14.
//

import Foundation

protocol SettingPresentableDelegate: AnyObject {
    
    func provideSettingViewController(of item: any SettingItemPresentable, presentAction: ((any SettingPage)?) -> Void)
    
    func action(for item: any SettingItemPresentable)
    
}
