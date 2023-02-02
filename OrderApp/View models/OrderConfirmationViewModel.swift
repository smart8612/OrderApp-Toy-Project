//
//  OrderConfirmationViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-02.
//

import Foundation

final class OrderConfirmationViewModel {
    
    weak var delegate: OrderConfirmationViewModelDelegate?
    
    let minutesToPrepare: Int
    private let startingOrderDate = Date()
    
    private var scheduledTimer: Timer?
    
    init(minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        self.configureTimer()
    }
    
    private var timeIntervalToPrepare: TimeInterval {
        TimeInterval(minutesToPrepare)
    }
    
    private var timeIntervalFromStartingOrder: TimeInterval {
        abs(startingOrderDate.timeIntervalSinceNow)
    }
    
    private func configureTimer() {
        scheduledTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let timeIntervalFromStartingOrder = self?.timeIntervalFromStartingOrder,
                  let timeIntervalToPrepare = self?.timeIntervalToPrepare else {
                self?.scheduledTimer?.invalidate()
                return
            }
            
            if timeIntervalFromStartingOrder >= timeIntervalToPrepare {
                self?.delegate?.returnTime(ratio: 1.0)
                self?.scheduledTimer?.invalidate()
            } else {
                let computeDateRatio = Float(timeIntervalFromStartingOrder / timeIntervalToPrepare)
                self?.delegate?.returnTime(ratio: computeDateRatio)
            }
        }
    }
    
    deinit {
        scheduledTimer?.invalidate()
    }
    
}
