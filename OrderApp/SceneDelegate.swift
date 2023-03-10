//
//  SceneDelegate.swift
//  OrderApp
//
//  Created by JeongTaek Han on 2023-01-27.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var sceneHirarchyController = SceneHierarchyController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        sceneHirarchyController.configure(with: self)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

// MARK: State Restoration Handling Code
extension SceneDelegate {
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return RestaurantController.shared.userActivity
    }
    
    func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity) {
        if let restoredOrder = stateRestorationActivity.order {
            RestaurantController.shared.restore(order: restoredOrder)
        }
        
        guard let restorationController = StateRestorationController(userActivity: stateRestorationActivity),
              let tabBarController = window?.rootViewController as? UITabBarController,
                  tabBarController.viewControllers?.count == 2,
              let categoryTableViewController = (tabBarController.viewControllers?.first as? UINavigationController)?.topViewController as? CategoryTableViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch restorationController {
        case .categories:
            break
        case .menu(let category):
            let viewController = storyboard.instantiateViewController(identifier: "menu") {
                return MenuTableViewController(coder: $0, category: category)
            }
            categoryTableViewController.navigationController?
                .pushViewController(viewController, animated: true)
        case .menuItemDetail(let menuItem):
            let menuViewController = storyboard.instantiateViewController(identifier: "menu") {
                return MenuTableViewController(coder: $0, category: menuItem.category)
            }
            let menuDetailViewController = storyboard.instantiateViewController(identifier: "menuItemDetail") {
                return MenuItemDetailViewController(coder: $0, menuItem: menuItem)
            }
            categoryTableViewController.navigationController?
                .pushViewController(menuViewController, animated: false)
            categoryTableViewController.navigationController?
                .pushViewController(menuDetailViewController, animated: false)
        case .order:
            tabBarController.selectedIndex = 1
        }
        
        
    }
    
}

// MARK: RootViewController Handling Code
extension SceneDelegate: SceneHierarchyControllerDelegate {
    
    func loadUIHirarchy() -> UIWindow? {
        return self.window
    }
    
}
