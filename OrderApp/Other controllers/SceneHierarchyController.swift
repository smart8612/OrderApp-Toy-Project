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
