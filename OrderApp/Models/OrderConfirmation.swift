//
//  OrderConfirmation.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-04.
//

import Foundation

struct OrderConfirmation {
    
    let minutesToPrepare: Int
    var timeRatio: Double = 0.0
    
    private let startingOrderDate = Date()
    
    var remainTimeRatio: Double {
        orderProgressedTime / timeIntervalToPrepare
    }
    
    private var timeIntervalToPrepare: TimeInterval {
        TimeInterval(minutesToPrepare)
    }
    
    private var orderProgressedTime: TimeInterval {
        abs(startingOrderDate.timeIntervalSinceNow)
    }
    
    mutating func updateTimeRatio() {
        timeRatio = remainTimeRatio
    }
    
}
