//
//  Extensions+UIViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-28.
//

import UIKit

extension UIViewController {
    var isOnScreen: Bool {
        viewIfLoaded?.window != nil
    }
}
