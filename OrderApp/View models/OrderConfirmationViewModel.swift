//
//  OrderConfirmationViewModel.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-02.
//

import Foundation
import Combine

final class OrderConfirmationViewModel: ObservableObject {
    
    @Published private var orderConfirmation: OrderConfirmation
    
    private var scheduledTimerSubscriber: Cancellable?
    private let updateCycle: TimeInterval = 0.0001
    
    init(minutesToPrepare: Int) {
        self.orderConfirmation = OrderConfirmation(
            minutesToPrepare: minutesToPrepare)
        self.subscribeTimer()
        self.scheduleNotification()
    }
    
    var remainTimeRatio: Float {
        Float(orderConfirmation.remainTimeRatio)
    }
    
    var minutesToPrepare: Int {
        orderConfirmation.minutesToPrepare
    }
    
    private func scheduleNotification() {
        let request = OrderCompleteNotificationRequest(
            minutesToPrepare: minutesToPrepare,
            title: "Order Complete",
            body: "Your Order is Completed"
        )
        UserNotificationCenterController.shared.send(request: request)
    }
    
    private func subscribeTimer() {
        scheduledTimerSubscriber = Timer.publish(every: updateCycle, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                if let remainTimeRatio = self?.remainTimeRatio, remainTimeRatio > 1.0 {
                    self?.unsubscribe()
                } else {
                    self?.updateRemainTime()
                }
            })
    }
    
    private func updateRemainTime() {
        orderConfirmation.updateTimeRatio()
    }
    
    private func unsubscribe() {
        scheduledTimerSubscriber?.cancel()
    }
    
    deinit {
        unsubscribe()
    }
    
}
