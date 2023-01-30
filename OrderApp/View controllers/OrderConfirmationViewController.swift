//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-30.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    private let minutesToPrepare: Int
    
    @IBOutlet var confirmationLabel: UILabel!
    
    required init?(coder: NSCoder, minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        
    }
    
}
