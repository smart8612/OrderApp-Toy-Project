//
//  SceneHirarchyControllerDelegate.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-04.
//

import UIKit

protocol SceneHirarchyControllerDelegate: AnyObject {
    
    func loadUIHirarchy() -> UIWindow?
    
}
