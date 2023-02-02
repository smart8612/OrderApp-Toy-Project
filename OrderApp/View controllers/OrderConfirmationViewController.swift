//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-30.
//

import UIKit
import Combine

final class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet private weak var confirmationLabel: UILabel?
    @IBOutlet private weak var timeProgressiveView: UIProgressView?
    
    private let viewModel: OrderConfirmationViewModel
    private var viewModelSubscribe: Cancellable?
    
    required init?(coder: NSCoder, minutesToPrepare: Int) {
        self.viewModel = OrderConfirmationViewModel(minutesToPrepare: minutesToPrepare)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubscription()
        updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModelSubscribe?.cancel()
    }
    
    private func configureSubscription() {
        viewModelSubscribe = viewModel.objectWillChange.sink { [weak self] _ in
            guard let remainRatio = self?.viewModel.remainTimeRatio else { return }
            self?.timeProgressiveView?.setProgress(remainRatio, animated: true)
        }
    }
    
    private func updateUI() {
        confirmationLabel?.text = "Thank you for your order! Your wait time is approximately \(viewModel.minutesToPrepare) minutes."
        timeProgressiveView?.setProgress(0.0, animated: true)
    }
    
}
