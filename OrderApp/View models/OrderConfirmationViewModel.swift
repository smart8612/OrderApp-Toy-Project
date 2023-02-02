//
//  OrderConfirmationViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-02.
//

import Foundation
import Combine

final class OrderConfirmationViewModel: ObservableObject {
    
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
    
    var remainTimeRatio: Float {
        Float(abs(startingOrderDate.timeIntervalSinceNow) / timeIntervalToPrepare)
    }
    
    private func configureTimer() {
        scheduledTimerSubscriber = Timer.publish(every: 0.0001, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                self?.objectWillChange.send()
                if let remainTimeRatio = self?.remainTimeRatio, remainTimeRatio > 1.0 {
                    self?.scheduledTimerSubscriber?.cancel()
                }
            })
    }
    
    deinit {
        scheduledTimerSubscriber?.cancel()
    }
    
}
