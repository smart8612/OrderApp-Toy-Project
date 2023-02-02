//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-30.
//

import UIKit

final class OrderConfirmationViewController: UIViewController {
    
    private let minutesToPrepare: Int
    private let startingOrderDate = Date()
    private var timeIntervalToPrepare: TimeInterval {
        TimeInterval(minutesToPrepare)
    }
    
    private let restaurantController = RestaurantController.shared
    
    @IBOutlet private weak var confirmationLabel: UILabel?
    @IBOutlet private weak var timeProgressiveView: UIProgressView!
    
    private var scheduleTimer: Timer?
    
    required init?(coder: NSCoder, minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        scheduleTimer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProgressiveBarUpdateSchedule()
        updateUI()
    }
    
    private func updateUI() {
        confirmationLabel?.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
        timeProgressiveView?.setProgress(0.0, animated: true)
    }
    
    private func configureProgressiveBarUpdateSchedule() {
        scheduleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard var timeIntervalFromStartingOrder = self?.startingOrderDate.timeIntervalSinceNow,
                  let timeIntervalToPrepare = self?.timeIntervalToPrepare else {
                self?.scheduleTimer?.invalidate()
                return
            }
            
            timeIntervalFromStartingOrder = abs(timeIntervalFromStartingOrder)
            
            if timeIntervalFromStartingOrder >= timeIntervalToPrepare {
                self?.timeProgressiveView.setProgress(1.0, animated: true)
                self?.scheduleTimer?.invalidate()
            } else {
                let computeDateRatio = Float(timeIntervalFromStartingOrder / timeIntervalToPrepare)
                self?.timeProgressiveView?.setProgress(computeDateRatio, animated: true)
            }
        }
    }
    
}
