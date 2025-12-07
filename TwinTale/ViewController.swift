//
//  ViewController.swift
//  TwinTale
//
//  Created by Default User on 11/24/25.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    let loginManager = LoginManager()
    
    // IBOutlets for UI elements (connect these in storyboard)
    @IBOutlet weak var logoImageView: UIImageView?
    @IBOutlet weak var quoteTextView: UITextView?
    @IBOutlet weak var facebookLoginButton: UIButton?
    @IBOutlet weak var createAccountButton: UIButton?
    @IBOutlet weak var signInButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAmazingUI()
        animateEntrance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Amazing UI Setup
    private func setupAmazingUI() {
        // Create stunning gradient background
        setupGradientBackground()
        
        // Style all buttons with premium effects
        if let fbButton = facebookLoginButton {
            styleButton(fbButton, withColor: UIColor(red: 0.24, green: 0.35, blue: 0.60, alpha: 1.0), icon: "📘")
        }
        
        if let createButton = createAccountButton {
            styleButton(createButton, withColor: UIColor(red: 0.11, green: 0.57, blue: 0.82, alpha: 1.0), icon: "✨")
        }
        
        if let signButton = signInButton {
            styleOutlineButton(signButton)
        }
        
        // Add elegant shadow to logo
        if let logo = logoImageView {
            logo.layer.shadowColor = UIColor.black.cgColor
            logo.layer.shadowOffset = CGSize(width: 0, height: 8)
            logo.layer.shadowOpacity = 0.4
            logo.layer.shadowRadius = 12
            logo.layer.masksToBounds = false
        }
        
        // Perfect the quote text view
        if let quote = quoteTextView {
            quote.backgroundColor = UIColor.white.withAlphaComponent(0.15)
            quote.layer.cornerRadius = 15
            quote.layer.masksToBounds = true
            quote.isEditable = false
            quote.isSelectable = false
            quote.textContainerInset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        }
    }
    
    private func setupGradientBackground() {
        // Remove existing gradient if any
        view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.09, green: 0.49, blue: 0.70, alpha: 1.0).cgColor,
            UIColor(red: 0.11, green: 0.62, blue: 0.85, alpha: 1.0).cgColor,
            UIColor(red: 0.09, green: 0.49, blue: 0.70, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func styleButton(_ button: UIButton, withColor color: UIColor, icon: String) {
        // Professional shadow effect
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowOpacity = 0.35
        button.layer.shadowRadius = 10
        button.layer.masksToBounds = false
        
        // Smooth corner radius
        button.layer.cornerRadius = 25
        
        // Add subtle border for depth
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        // Add press animation targets
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    private func styleOutlineButton(_ button: UIButton) {
        // Beautiful outline style
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        // Subtle shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 8
        button.layer.masksToBounds = false
        
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    // MARK: - Stunning Animations
    private func animateEntrance() {
        // Logo animation - bouncy entrance
        logoImageView?.alpha = 0
        logoImageView?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3).rotated(by: -0.2)
        
        UIView.animate(withDuration: 1.0, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.logoImageView?.alpha = 1
            self.logoImageView?.transform = .identity
        })
        
        // Quote animation - elegant fade up
        quoteTextView?.alpha = 0
        quoteTextView?.transform = CGAffineTransform(translationX: 0, y: 30)
        
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.quoteTextView?.alpha = 1
            self.quoteTextView?.transform = .identity
        })
        
        // Buttons animation - staggered cascade
        animateButton(facebookLoginButton, delay: 0.8)
        animateButton(createAccountButton, delay: 0.95)
        animateButton(signInButton, delay: 1.1)
    }
    
    private func animateButton(_ button: UIButton?, delay: Double) {
        guard let button = button else { return }
        
        button.alpha = 0
        button.transform = CGAffineTransform(translationX: -50, y: 20)
        
        UIView.animate(withDuration: 0.6, delay: delay, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            button.alpha = 1
            button.transform = .identity
        })
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        // Haptic feedback for premium feel
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            sender.alpha = 0.8
        })
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            sender.transform = .identity
            sender.alpha = 1.0
        })
    }
    
    // MARK: - Facebook Login
    @IBAction func facebookLoginButtonTapped(_ sender: UIButton) {
        // Premium haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Request only public_profile (email requires Facebook approval)
        loginManager.logIn(permissions: ["public_profile"], from: self) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showStylishAlert(title: "Login Error", message: error.localizedDescription, isError: true)
                return
            }
            
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            
            // Successfully logged in
            self.fetchFacebookUserData()
        }
    }
    
    private func fetchFacebookUserData() {
        // Request only public data (email requires Facebook approval)
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large)"])
        
        request.start { _, result, error in
            if let error = error {
                self.showStylishAlert(title: "Error", message: "Failed to fetch user data: \(error.localizedDescription)", isError: true)
                return
            }
            
            guard let userData = result as? [String: Any] else {
                self.showStylishAlert(title: "Error", message: "Invalid user data", isError: true)
                return
            }
            
            // Extract user information
            let name = userData["name"] as? String ?? "User"
            let userId = userData["id"] as? String ?? ""
            let email = userData["email"] as? String // Optional - may not be available
            
            print("Facebook Login Successful!")
            print("Name: \(name)")
            print("User ID: \(userId)")
            if let email = email {
                print("Email: \(email)")
            }
            
            // Save to Core Data (automatically checks for duplicates and only saves once)
            self.saveUserToCoreData(facebookId: userId, name: name, email: email)
            
            // Show success with celebration
            self.showStylishAlert(title: "🎉 Welcome!", message: "Hello, \(name)!\n\nYou're ready to start your TwinTale adventure.", isError: false) {
                self.navigateToHomeScreen()
            }
        }
    }
    
    // MARK: - Core Data
    private func saveUserToCoreData(facebookId: String, name: String, email: String?) {
        let coreDataManager = CoreDataManager.shared
        
        // saveFacebookUser automatically checks if user exists and only saves once
        if let user = coreDataManager.saveFacebookUser(facebookId: facebookId, name: name, email: email) {
            print("✅ User data saved/updated in Core Data")
            print("   📧 Email: \(user.email ?? "Not available")")
            print("   🗓️ Last login: \(user.formattedLastLoginDate)")
        } else {
            print("⚠️ Failed to save user to Core Data")
        }
    }
    
    private func navigateToHomeScreen() {
        print("Navigating to home screen...")
        
        // Get the window scene and set tab bar as root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let tabBarController = storyboard?.instantiateViewController(withIdentifier: "itR-Z2-kzY") as? UITabBarController {
            
            // Smooth transition to tab bar
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            })
        } else {
            print("Error: Could not find tab bar controller or window")
        }
    }
    
    private func showStylishAlert(title: String, message: String, isError: Bool, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: isError ? .default : .default) { _ in
            completion?()
        })
        
        present(alert, animated: true) {
            // Add haptic feedback
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(isError ? .error : .success)
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        showStylishAlert(title: title, message: message, isError: false, completion: completion)
    }
}

// MARK: - UI Enhancements Extension
extension ViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update gradient frame on rotation
        if let gradientLayer = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
}
