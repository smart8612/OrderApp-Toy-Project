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
    
    func displayError(_ error: Error, title: String) {
        guard self.isOnScreen else { return }
        let alert = UIAlertController(
            title: title,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(alert, animated: true)
    }
    
}
