//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit
import OrderClient


final class MenuItemDetailViewController: UIViewController {
    
    private let menuItem: MenuItem
    private let restaurantController = RestaurantController.shared
    private var imageLoadTask: Task<Void, Never>?
    
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var priceLabel: UILabel?
    @IBOutlet private weak var detailTextLabel: UILabel?
    @IBOutlet private weak var addToOrderButton: UIButton?
    
    required init?(coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerStateRestoration()
        updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cancelImageLoadTask()
    }
    
    @IBAction private func orderButtonTapped(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.1
        ) {
            self.addToOrderButton?.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.addToOrderButton?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        restaurantController.addOrder(with: menuItem)
    }
    
}

// MARK: Presentation Handling function
extension MenuItemDetailViewController {
    
    @objc
    private func updateUI() {
        nameLabel?.text = menuItem.name
        priceLabel?.text = menuItem.price.formatted(.currency(code: "usd"))
        detailTextLabel?.text = menuItem.detailText
        
        imageLoadTask = Task {
            guard let data = try? await restaurantController.fetchImage(from: menuItem.imageURL),
                  let image = UIImage(data: data) else {
                return
            }
            self.imageView?.image = image
        }
    }
    
}

// MARK: Register Handling function
extension MenuItemDetailViewController {
    
    private func registerStateRestoration() {
        restaurantController.updateUserActivity(with: .menuItemDetail(menuItem))
    }
    
}

// MARK: Task Handling function
extension MenuItemDetailViewController {
    
    private func cancelImageLoadTask() {
        imageLoadTask?.cancel()
    }
    
}
