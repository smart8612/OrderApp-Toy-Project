//
//  OrderConfirmationViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-02.
//

import Foundation
import Combine

final class OrderConfirmationViewModel {
    
    weak var delegate: OrderConfirmationViewModelDelegate?
    
    let minutesToPrepare: Int
    private let startingOrderDate = Date()
    
    private var scheduledTimerSubscriber: Cancellable?
    
    init(minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        self.configureTimer()
    }
    
    private var timeIntervalToPrepare: TimeInterval {
        TimeInterval(minutesToPrepare)
    }
    
    private func configureTimer() {
        scheduledTimerSubscriber = Timer.publish(every: 0.0001, on: .main, in: .default)
            .autoconnect()
            .compactMap({ [weak self] date in
                guard let startingOrderDate = self?.startingOrderDate,
                      let timeIntervalToPrepare = self?.timeIntervalToPrepare else {
                    return nil
                }
                return (abs(date.timeIntervalSince(startingOrderDate)), timeIntervalToPrepare)
            })
            .map({ Float($0 / $1) })
            .sink(receiveValue: { [weak self] ratio in
                if ratio >= 1.0 {
                    self?.scheduledTimerSubscriber?.cancel()
                }
                self?.delegate?.returnTime(ratio: ratio)
            })
    }
    
    deinit {
        scheduledTimerSubscriber?.cancel()
    }
    
}
