//
//  AppDelegate.swift
//  TwinTale
//
//  Created by Default User on 11/24/25.
//

import UIKit
import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Application Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize Facebook SDK
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        // Configure app appearance
        configureAppearance()
        
        return true
    }
    
    // MARK: - URL Handling
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle Facebook URL callback
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    // MARK: - Appearance Configuration
    private func configureAppearance() {
        // Configure Navigation Bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 0.09, green: 0.49, blue: 0.70, alpha: 1.0)
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 32)
        ]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = .white
        
        // Configure Tab Bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        UITabBar.appearance().tintColor = UIColor(red: 0.09, green: 0.49, blue: 0.70, alpha: 1.0)
    }

    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Release resources for discarded scenes
    }
}
