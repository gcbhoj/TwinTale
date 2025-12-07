//
//  SceneDelegate.swift
//  TwinTale
//
//  Created by Default User on 11/24/25.
//

import UIKit
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: - Scene Lifecycle
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    // MARK: - URL Handling for Facebook
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        // Handle Facebook URL callback
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Release resources when scene is disconnected
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Restart paused tasks when scene becomes active
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Handle temporary interruptions (e.g., incoming calls)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Undo background changes when returning to foreground
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save data and release resources when entering background
    }
}
