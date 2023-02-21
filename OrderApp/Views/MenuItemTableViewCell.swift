//
//  MenuItemTableViewCell.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-31.
//

import UIKit

final class MenuItemTableViewCell: UITableViewCell {
    
    var itemName: String? = nil {
        didSet {
            if oldValue != itemName {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    var price: Double? = nil {
        didSet {
            if oldValue != price {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            if oldValue != image {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var contentConfiguration = defaultContentConfiguration().updated(for: state)
        
        contentConfiguration.text = itemName
        contentConfiguration.secondaryText = price?.formatted(.currency(code: "usd"))
        contentConfiguration.image = (image == nil) ? UIImage(systemName: "photo.on.rectangle") : image
        contentConfiguration.prefersSideBySideTextAndSecondaryText = true
        contentConfiguration.imageProperties.maximumSize = CGSize(width: 30, height: 30)
        self.contentConfiguration = contentConfiguration
    }
}
