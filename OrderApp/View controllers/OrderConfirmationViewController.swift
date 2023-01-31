//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-30.
//

import UIKit

final class OrderConfirmationViewController: UIViewController {
    
    private let minutesToPrepare: Int
    private let restaurantController = RestaurantController.shared
    
    @IBOutlet private weak var confirmationLabel: UILabel?
    
    required init?(coder: NSCoder, minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        confirmationLabel?.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
    }
    
}
