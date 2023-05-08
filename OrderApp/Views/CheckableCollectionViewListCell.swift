//
//  CheckableCollectionViewListCell.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023/05/08.
//

import UIKit

final class CheckableCollectionViewListCell: UICollectionViewListCell {
    
    var title: String = "" {
        didSet {
            if oldValue != title {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    var value: Bool = false {
        didSet {
            if oldValue != value {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var contentConfiguration = defaultContentConfiguration().updated(for: state)
        contentConfiguration.text = title
        self.contentConfiguration = contentConfiguration
        
        if (value) {
            self.accessories = [.checkmark()]
        } else {
            self.accessories = []
        }
    }
    
}
