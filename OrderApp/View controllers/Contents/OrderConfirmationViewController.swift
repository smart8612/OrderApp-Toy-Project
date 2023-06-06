//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-30.
//

import UIKit
import Combine


final class OrderConfirmationViewController: UIViewController {
    
    private let viewModel: OrderConfirmationViewModel
    
    @IBOutlet private weak var confirmationLabel: UILabel?
    @IBOutlet private weak var timeProgressiveView: UIProgressView?
    
    private var subscriprions: [Cancellable] = []
    
    required init?(coder: NSCoder, minutesToPrepare: Int) {
        self.viewModel = OrderConfirmationViewModel(
            minutesToPrepare: minutesToPrepare)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerSubscription()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelSubscription()
    }
    
    @IBAction func dismissButtonClicked(_ sender: UIButton) {
        viewModel.deleteAllOrder()
        dismiss(animated: true)
    }
}

// MARK: Presentation Handling function
extension OrderConfirmationViewController {
    
    private func updateUI() {
        let remainRatio = viewModel.remainTimeRatio
        let minutesToPrepare = viewModel.minutesToPrepare
        applyUI(with: minutesToPrepare, progress: remainRatio)
    }
    
    private func applyUI(with remainTime: Int, progress: Float) {
        confirmationLabel?.text = """
        Thank you for your order! Your wait time is approximately \(remainTime) minutes.
        """
        timeProgressiveView?.setProgress(progress, animated: true)
    }
    
}

// MARK: Subscription Handling function
extension OrderConfirmationViewController {
    
    private func registerSubscription() {
        let viewModelSubscribe = viewModel.objectWillChange
            .sink { [weak self] _ in
                self?.updateUI()
            }
        
        let sceneSubscribe = NotificationCenter.default.publisher(for: UIScene.didActivateNotification)
            .sink { [weak self] _ in
                self?.updateUI()
            }
        
        subscriprions.append(contentsOf: [
            viewModelSubscribe,
            sceneSubscribe
        ])
    }
    
    private func cancelSubscription() {
        subscriprions.forEach { $0.cancel() }
    }
    
}
