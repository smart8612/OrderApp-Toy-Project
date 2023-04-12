//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit

@MainActor
final class MenuItemDetailViewController: UIViewController {
    
    private let menuItem: MenuItem
    private let restaurantController = RestaurantController.shared
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restaurantController.updateUserActivity(with: .menuItemDetail(menuItem))
    }
    
    private func updateUI() {
        nameLabel?.text = menuItem.name
        priceLabel?.text = menuItem.price.formatted(.currency(code: "usd"))
        detailTextLabel?.text = menuItem.detailText
        
        Task {
            guard let data = try? await restaurantController.fetchImage(from: menuItem.imageURL),
                  let image = UIImage(data: data) else {
                return
            }
            self.imageView?.image = image
        }
    }
    
    @IBAction private func orderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1) {
            self.addToOrderButton?.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.addToOrderButton?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        restaurantController.addOrder(with: menuItem)
    }
    
}
