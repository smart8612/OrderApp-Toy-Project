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
            title: title,
            message: error.localizedDescription,
            actionTitle: "Dismiss"
        )
    }
    
    func displayAlert(title: String, message: String, actionTitle: String) {
        guard self.isOnScreen else { return }
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default))
        present(alertController, animated: true)
    }
    
}
