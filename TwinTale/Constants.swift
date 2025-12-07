//
//  Constants.swift
//  TwinTale
//
//  Created for TwinTale App
//

import UIKit

// MARK: - App Colors
struct AppColors {
    // Primary brand colors
    static let primaryBlue = UIColor(red: 0.09, green: 0.49, blue: 0.70, alpha: 1.0)
    static let secondaryBlue = UIColor(red: 0.11, green: 0.62, blue: 0.85, alpha: 1.0)
    static let accentBlue = UIColor(red: 0.11, green: 0.57, blue: 0.82, alpha: 1.0)
    
    // Facebook blue
    static let facebookBlue = UIColor(red: 0.24, green: 0.35, blue: 0.60, alpha: 1.0)
    
    // Light blue background
    static let lightBlueBackground = UIColor(red: 0.54, green: 0.71, blue: 1.0, alpha: 1.0)
    static let skyBlue = UIColor(red: 0.54, green: 0.85, blue: 0.96, alpha: 1.0)
    
    // Gradient colors
    static var primaryGradientColors: [CGColor] {
        return [
            primaryBlue.cgColor,
            secondaryBlue.cgColor,
            primaryBlue.cgColor
        ]
    }
    
    // Text colors
    static let primaryText = UIColor.label
    static let secondaryText = UIColor.secondaryLabel
    static let whiteText = UIColor.white
    
    // Success and error
    static let success = UIColor.systemGreen
    static let error = UIColor.systemRed
    static let warning = UIColor.systemOrange
    
    // Coins and medals
    static let coinGold = UIColor.systemYellow
    static let medalBronze = UIColor.systemOrange
}

// MARK: - App Fonts
struct AppFonts {
    static let titleLarge = UIFont.boldSystemFont(ofSize: 32)
    static let titleMedium = UIFont.boldSystemFont(ofSize: 24)
    static let titleSmall = UIFont.boldSystemFont(ofSize: 18)
    
    static let bodyLarge = UIFont.systemFont(ofSize: 18, weight: .medium)
    static let bodyMedium = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let bodySmall = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    static let buttonText = UIFont.systemFont(ofSize: 16, weight: .semibold)
    static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
}

// MARK: - App Dimensions
struct AppDimensions {
    // Button dimensions
    static let buttonHeight: CGFloat = 50
    static let buttonCornerRadius: CGFloat = 25
    
    // Padding
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 24
    static let paddingXLarge: CGFloat = 32
    
    // Shadow
    static let shadowRadius: CGFloat = 10
    static let shadowOpacity: Float = 0.3
    
    // Animation durations
    static let animationFast: TimeInterval = 0.15
    static let animationMedium: TimeInterval = 0.3
    static let animationSlow: TimeInterval = 0.5
}

// MARK: - App Strings
struct AppStrings {
    // Alerts
    static let error = "Error"
    static let success = "Success"
    static let ok = "OK"
    static let cancel = "Cancel"
    
    // Login
    static let welcomeTitle = "🎉 Welcome!"
    static let loginError = "Login Error"
    static let invalidData = "Invalid user data"
    
    // Facebook
    static let facebookLogin = "Login with Facebook"
    static let facebookPermissions = ["public_profile", "email"]
}

// MARK: - User Defaults Keys
struct UserDefaultsKeys {
    static let isLoggedIn = "isLoggedIn"
    static let userId = "userId"
    static let userName = "userName"
    static let userEmail = "userEmail"
    static let userProfilePicture = "userProfilePicture"
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
}

// MARK: - Notification Names
extension Notification.Name {
    static let userDidLogin = Notification.Name("userDidLogin")
    static let userDidLogout = Notification.Name("userDidLogout")
    static let storyCompleted = Notification.Name("storyCompleted")
    static let coinsUpdated = Notification.Name("coinsUpdated")
}
