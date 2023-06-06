//
//  SceneHierarchyController.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-02-04.
//

import UIKit
import Combine

final class SceneHierarchyController {
    
    weak var delegate: SceneHierarchyControllerDelegate?
    private var subscriptions: [Cancellable]?
    
    private weak var window: UIWindow?
    
    func configure(with delegate: SceneHierarchyControllerDelegate) {
        self.delegate = delegate
        window = self.delegate?.loadUIHirarchy()
        configureUI()
        subscribe()
    }
    
    private func findViewController<T: UIViewController>(on type: T.Type) -> T? {
        guard let window = window else { return nil }
        guard let rootViewController = window.rootViewController else { return nil }
        
        if let rootViewController = rootViewController as? T {
            return rootViewController
        }
        
        var searchQueue = rootViewController.children
        while !searchQueue.isEmpty {
            let childVC = searchQueue.removeFirst()
            
            if let childVC = childVC as? T {
                return childVC
            } else {
                searchQueue.append(contentsOf: childVC.children)
            }
        }
        
        return nil
    }
    
    func restore(state src: StateRestorationController) {
        guard let rootScene = findViewController(on: RootViewController.self) else { return }
        
        switch src {
        case .categories:
            rootScene.selectedMenu = .restaurant
        case .menu(let category):
            rootScene.selectedMenu = .restaurant
            rootScene.restore(menu: category)
        case .menuItemDetail(let menuItem):
            rootScene.selectedMenu = .restaurant
            rootScene.restore(menuItemDetail: menuItem)
        case .order:
            rootScene.selectedMenu = .myOrder
        }
    }
    
    deinit {
        cancelAllSubscriptions()
    }
    
}

// MARK: UI Presentation Handler
fileprivate extension SceneHierarchyController {
    
    private func configureUI() {
        configureGlobalUI()
    }
    
    private func configureGlobalUI() {
        window?.overrideUserInterfaceStyle = UserDefaults.standard.colorSchema
    }

}

// MARK: Combine Subscription Handler
fileprivate extension SceneHierarchyController {
    
    private func subscribe() {
        subscriptions = [
            NotificationCenter.default.publisher(
                for: UserDefaults.didChangeNotification
            ).sink { [weak self] _ in
              self?.configureGlobalUI()
            }
        ]
    }
    
    private func cancelAllSubscriptions() {
        subscriptions?.forEach { $0.cancel() }
    }
    
}
