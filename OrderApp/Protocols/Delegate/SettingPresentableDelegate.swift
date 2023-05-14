//
//  SettingPresentableDelegate.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/14.
//

import UIKit

protocol SettingPresentableDelegate: AnyObject {
    
    func provideSettingViewController(of item: any SettingItemPresentable, presentAction: (any SettingItemPresentable, UIViewController) -> Void)
    
}
