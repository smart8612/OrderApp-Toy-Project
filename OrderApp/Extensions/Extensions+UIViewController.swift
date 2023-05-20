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
        displayAlert(
            preferredStyle: .alert,
            title: title,
            message: error.localizedDescription,
            actions: [
                UIAlertAction(title: "Dismiss", style: .default)
            ]
        )
    }
    
    func displayAlert(preferredStyle: UIAlertController.Style, title: String, message: String, actions: [UIAlertAction]) {
        guard self.isOnScreen else { return }
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
    
}
