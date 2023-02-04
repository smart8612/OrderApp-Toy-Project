//
//  SceneHierarchyControllerDelegate.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-04.
//

import UIKit

protocol SceneHierarchyControllerDelegate: AnyObject {
    
    func loadUIHirarchy() -> UIWindow?
    
}
