//
//  Extensions.swift
//  TwinTale
//
//  Created for TwinTale App
//

import UIKit

// MARK: - UIView Extensions
extension UIView {
    
    /// Add shadow to any view
    func addShadow(
        color: UIColor = .black,
        opacity: Float = 0.3,
        offset: CGSize = CGSize(width: 0, height: 4),
        radius: CGFloat = 8
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    /// Add rounded corners to any view
    func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// Add border to any view
    func addBorder(color: UIColor, width: CGFloat = 1.0) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    /// Fade in animation
    func fadeIn(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        alpha = 0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: { _ in
            completion?()
        })
    }
    
    /// Fade out animation
    func fadeOut(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }
    
    /// Bounce animation
    func bounce(scale: CGFloat = 0.95, duration: TimeInterval = 0.1) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { _ in
            UIView.animate(withDuration: duration) {
                self.transform = .identity
            }
        })
    }
    
    /// Shake animation for errors
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.5
        animation.values = [-10, 10, -8, 8, -5, 5, -2, 2, 0]
        layer.add(animation, forKey: "shake")
    }
    
    /// Add gradient background
    func addGradientBackground(colors: [CGColor], locations: [NSNumber]? = nil) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - UIButton Extensions
extension UIButton {
    
    /// Style button as primary
    func stylePrimary() {
        backgroundColor = AppColors.primaryBlue
        setTitleColor(.white, for: .normal)
        titleLabel?.font = AppFonts.buttonText
        roundCorners(radius: AppDimensions.buttonCornerRadius)
        addShadow()
    }
    
    /// Style button as secondary (outline)
    func styleSecondary() {
        backgroundColor = .clear
        setTitleColor(AppColors.primaryBlue, for: .normal)
        titleLabel?.font = AppFonts.buttonText
        roundCorners(radius: AppDimensions.buttonCornerRadius)
        addBorder(color: AppColors.primaryBlue, width: 2)
    }
    
    /// Add press animation
    func addPressAnimation() {
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.9
        }
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}

// MARK: - UIViewController Extensions
extension UIViewController {
    
    /// Show a simple alert
    func showAlert(title: String, message: String, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppStrings.ok, style: .default) { _ in
            action?()
        })
        present(alert, animated: true)
    }
    
    /// Show error alert with haptic feedback
    func showError(message: String) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        showAlert(title: AppStrings.error, message: message)
    }
    
    /// Show success alert with haptic feedback
    func showSuccess(title: String, message: String, action: (() -> Void)? = nil) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        showAlert(title: title, message: message, action: action)
    }
    
    /// Trigger haptic feedback
    func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    /// Hide keyboard when tapping outside
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - String Extensions
extension String {
    
    /// Check if string is a valid email
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    /// Trim whitespace and newlines
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Check if string is empty or just whitespace
    var isBlank: Bool {
        return trimmed.isEmpty
    }
}

// MARK: - UIColor Extensions
extension UIColor {
    
    /// Create color from hex string
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// MARK: - Date Extensions
extension Date {
    
    /// Format date as readable string
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
    
    /// Get relative time string (e.g., "2 hours ago")
    var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
