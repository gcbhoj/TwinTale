//
//  ViewController.swift
//  TwinTale
//
//  Created by Default User on 11/24/25.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let loginManager = LoginManager()
    
    // MARK: - IBOutlets
    @IBOutlet weak var logoImageView: UIImageView?
    @IBOutlet weak var quoteTextView: UITextView?
    @IBOutlet weak var facebookLoginButton: UIButton?
    @IBOutlet weak var createAccountButton: UIButton?
    @IBOutlet weak var signInButton: UIButton?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animateEntrance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupGradientBackground()
        setupLogoImageView()
        setupQuoteTextView()
        setupButtons()
    }
    
    private func setupGradientBackground() {
        // Remove existing gradient if any
        view.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = AppColors.primaryGradientColors
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updateGradientFrame() {
        if let gradientLayer = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    private func setupLogoImageView() {
        guard let logo = logoImageView else { return }
        logo.addShadow(opacity: 0.4, offset: CGSize(width: 0, height: 8), radius: 12)
    }
    
    private func setupQuoteTextView() {
        guard let quote = quoteTextView else { return }
        quote.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        quote.roundCorners(radius: 15)
        quote.isEditable = false
        quote.isSelectable = false
        quote.textContainerInset = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    }
    
    private func setupButtons() {
        // Style Facebook button
        if let fbButton = facebookLoginButton {
            styleFilledButton(fbButton, color: AppColors.facebookBlue)
        }
        
        // Style Create Account button
        if let createButton = createAccountButton {
            styleFilledButton(createButton, color: AppColors.accentBlue)
        }
        
        // Style Sign In button
        if let signButton = signInButton {
            styleOutlineButton(signButton)
        }
    }
    
    private func styleFilledButton(_ button: UIButton, color: UIColor) {
        button.addShadow(opacity: 0.35, offset: CGSize(width: 0, height: 6), radius: 10)
        button.roundCorners(radius: AppDimensions.buttonCornerRadius)
        button.addBorder(color: UIColor.white.withAlphaComponent(0.3), width: 0.5)
        
        // Add press animations
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    private func styleOutlineButton(_ button: UIButton) {
        button.addBorder(color: .white, width: 3.0)
        button.roundCorners(radius: AppDimensions.buttonCornerRadius)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.addShadow(opacity: 0.25, offset: CGSize(width: 0, height: 4), radius: 8)
        
        // Add press animations
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    // MARK: - Animations
    private func animateEntrance() {
        animateLogo()
        animateQuote()
        animateButtons()
    }
    
    private func animateLogo() {
        guard let logo = logoImageView else { return }
        
        logo.alpha = 0
        logo.transform = CGAffineTransform(scaleX: 0.3, y: 0.3).rotated(by: -0.2)
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0.1,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: .curveEaseOut
        ) {
            logo.alpha = 1
            logo.transform = .identity
        }
    }
    
    private func animateQuote() {
        guard let quote = quoteTextView else { return }
        
        quote.alpha = 0
        quote.transform = CGAffineTransform(translationX: 0, y: 30)
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0.5,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            quote.alpha = 1
            quote.transform = .identity
        }
    }
    
    private func animateButtons() {
        animateButton(facebookLoginButton, delay: 0.8)
        animateButton(createAccountButton, delay: 0.95)
        animateButton(signInButton, delay: 1.1)
    }
    
    private func animateButton(_ button: UIButton?, delay: Double) {
        guard let button = button else { return }
        
        button.alpha = 0
        button.transform = CGAffineTransform(translationX: -50, y: 20)
        
        UIView.animate(
            withDuration: 0.6,
            delay: delay,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            button.alpha = 1
            button.transform = .identity
        }
    }
    
    // MARK: - Button Actions
    @objc private func buttonPressed(_ sender: UIButton) {
        triggerHaptic(style: .medium)
        
        UIView.animate(withDuration: AppDimensions.animationFast) {
            sender.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
            sender.alpha = 0.8
        }
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            sender.transform = .identity
            sender.alpha = 1.0
        }
    }
    
    // MARK: - Facebook Login
    @IBAction func facebookLoginButtonTapped(_ sender: UIButton) {
        triggerHaptic(style: .medium)
        performFacebookLogin()
    }
    
    private func performFacebookLogin() {
        loginManager.logIn(permissions: AppStrings.facebookPermissions, from: self) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showError(message: error.localizedDescription)
                return
            }
            
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            
            self.fetchFacebookUserData()
        }
    }
    
    private func fetchFacebookUserData() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, picture.type(large)"])
        
        request.start { [weak self] _, result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showError(message: "Failed to fetch user data: \(error.localizedDescription)")
                return
            }
            
            guard let userData = result as? [String: Any] else {
                self.showError(message: AppStrings.invalidData)
                return
            }
            
            self.handleSuccessfulLogin(userData: userData)
        }
    }
    
    private func handleSuccessfulLogin(userData: [String: Any]) {
        let name = userData["name"] as? String ?? "User"
        let email = userData["email"] as? String ?? ""
        let userId = userData["id"] as? String ?? ""
        
        // Log success
        print("Facebook Login Successful!")
        print("Name: \(name)")
        print("Email: \(email)")
        print("User ID: \(userId)")
        
        // Save user data
        saveUserData(name: name, email: email, userId: userId)
        
        // Show success message
        showSuccess(
            title: AppStrings.welcomeTitle,
            message: "Hello, \(name)!\n\nYou're ready to start your TwinTale adventure."
        ) { [weak self] in
            self?.navigateToHomeScreen()
        }
    }
    
    private func saveUserData(name: String, email: String, userId: String) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: UserDefaultsKeys.isLoggedIn)
        defaults.set(userId, forKey: UserDefaultsKeys.userId)
        defaults.set(name, forKey: UserDefaultsKeys.userName)
        defaults.set(email, forKey: UserDefaultsKeys.userEmail)
        
        // Post notification
        NotificationCenter.default.post(name: .userDidLogin, object: nil)
    }
    
    private func navigateToHomeScreen() {
        print("Navigating to home screen...")
        
        // Smooth transition animation
        UIView.transition(with: view, duration: AppDimensions.animationSlow, options: .transitionCrossDissolve) {
            // Navigation will happen here
            // TODO: Implement navigation to home screen
        }
    }
}
