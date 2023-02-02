//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-30.
//

import UIKit

final class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet private weak var confirmationLabel: UILabel?
    @IBOutlet private weak var timeProgressiveView: UIProgressView!
    
    private let viewModel: OrderConfirmationViewModel
    
    required init?(coder: NSCoder, minutesToPrepare: Int) {
        self.viewModel = OrderConfirmationViewModel(minutesToPrepare: minutesToPrepare)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        updateUI()
    }
    
    private func updateUI() {
        confirmationLabel?.text = "Thank you for your order! Your wait time is approximately \(viewModel.minutesToPrepare) minutes."
        timeProgressiveView?.setProgress(0.0, animated: true)
    }
    
}

extension OrderConfirmationViewController: OrderConfirmationViewModelDelegate {
    
    func returnTime(ratio: Float) {
        self.timeProgressiveView.setProgress(ratio, animated: true)
    }
    
}
