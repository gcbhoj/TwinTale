//
//  RegistrationPageControllerViewController.swift
//  TwinTale
//
//  Created by Default User on 12/7/25.
//

import UIKit
import CoreData
import CryptoKit

class RegistrationPageControllerViewController: UIViewController {
    
    // --------------------------------------------------
    // UI ELEMENTS
    // --------------------------------------------------
    let logoImageView = UIImageView()
    let headerView = UILabel()
    let nameField = UITextField()
    let emailField = UITextField()
    let phoneField = UITextField()
    let passwordField = UITextField()
    let confirmPasswordField = UITextField()
    
    let registerButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    
    
    // --------------------------------------------------
    // VIEW DID LOAD
    // --------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "79D8B4")
        setupUI()
        
        // Add button action
        registerButton.addTarget(self,
                                 action: #selector(registerPressed),
                                 for: .touchUpInside)
    }
    
    
    
    // --------------------------------------------------
    // CORE DATA CONTEXT
    // --------------------------------------------------
    func persistentContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }
    
    
    
    // --------------------------------------------------
    // TEXT FIELD CREATOR
    // --------------------------------------------------
    func makeInputField(_ placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return tf
    }
    
    
    
    // --------------------------------------------------
    // UI SETUP
    // --------------------------------------------------
    func setupUI() {
        
        // --------------------------
        // LOGO
        // --------------------------
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoImageView.widthAnchor.constraint(equalToConstant: 140),
            logoImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        
        // heading
        headerView.text = "Registration"
        headerView.font = .systemFont(ofSize: 18)
        headerView.heightAnchor
            .constraint(equalToConstant: 75).isActive = true
        headerView.textAlignment = .center
        
        // --------------------------
        // INPUT PLACEHOLDERS
        // --------------------------
        nameField.placeholder = "Full Name"
        emailField.placeholder = "Email Address"
        phoneField.placeholder = "Phone Number (Optional)"
        passwordField.placeholder = "Password"
        confirmPasswordField.placeholder = "Confirm Password"
        
        let fields = [
            nameField, emailField,
            phoneField, passwordField,
            confirmPasswordField
        ]
        
        fields.forEach {
            $0.borderStyle = .roundedRect
            $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        
        // --------------------------
        // BUTTONS
        // --------------------------
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = UIColor(hex: "#1877F2")   // Facebook Blue
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.layer.cornerRadius = 8
        registerButton.clipsToBounds = true
        registerButton.addTarget(self,
                          action: #selector(registerPressed),
                          for: .touchUpInside)
        
        
        cancelButton.setTitle("Have Account? Sign In", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor(hex: "#1877F2")   // Facebook Blue
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.cornerRadius = 8
        cancelButton.clipsToBounds = true
        cancelButton.addTarget(
            self,
            action: #selector(goToLogin),
            for: .touchUpInside
        )
        
        // --------------------------
        // STACK
        // --------------------------
        let stack = UIStackView(arrangedSubviews: [
            headerView,
            nameField,
            emailField,
            phoneField,
            passwordField,
            confirmPasswordField,
            registerButton,
            cancelButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80)
        ])
    }
    
    
    
    // --------------------------------------------------
    // BUTTON PRESS HANDLER
    // --------------------------------------------------
    @objc func registerPressed() {
        
        let error = verifyUserInput(
            user_Name: nameField.text,
            userEmail: emailField.text,
            phoneNumber: phoneField.text,
            password: passwordField.text,
            confirmPassword: confirmPasswordField.text
        )
        
        if let message = error {
            // ERROR CASE – do NOT redirect
            showAlert(message)
            return
        }
        
        // SUCCESS CASE – redirect here
        showAlert("User saved successfully!")
        nameField.text = ""
        emailField.text = ""
        phoneField.text = ""
        passwordField.text = ""
        confirmPasswordField.text = ""
        performSegue(withIdentifier: "GoToLoginPage", sender: self)
    }

    
    @objc func goToLogin(){
        performSegue(withIdentifier: "GoToLoginPage", sender: self)
    }
    
    
    
    // --------------------------------------------------
    // ALERT
    // --------------------------------------------------
    func showAlert(_ msg: String) {
        let alert = UIAlertController(
            title: "Message",
            message: msg,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    
    // --------------------------------------------------
    // VERIFY USER INPUT
    // --------------------------------------------------
    func verifyUserInput(
        user_Name: String?,
        userEmail: String?,
        phoneNumber: String?,
        password: String?,
        confirmPassword: String?
    ) -> String? {
        
        guard let name = user_Name,
              !name.isEmpty else {
            return "User Name is required."
        }
        
        guard let email = userEmail,
              !email.isEmpty else {
            return "Email is required."
        }
        
        guard let pass = password,
              !pass.isEmpty else {
            return "Password is required."
        }
        
        guard let confirm = confirmPassword,
              confirm == pass else {
            return "Passwords do not match."
        }
        
        
        let hashed = hashPassword(pass)
        
        saveNewUser(user_Name: name,
                    userEmail: email,
                    phoneNumber: phoneNumber,
                    password: hashed)
        
        return nil
    }
    
    
    
    
    // --------------------------------------------------
    // PASSWORD HASH
    // --------------------------------------------------
    func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    
    
    // --------------------------------------------------
    // SAVE NEW USER
    // --------------------------------------------------
    func saveNewUser(
        user_Name: String,
        userEmail: String,
        phoneNumber: String?,
        password: String
    ) {
        
        let context = persistentContext()
        
        if userExists(userEmail: userEmail) {
            print("User already exists.")
            return
        }
        
        let user = NewUser(context: context)
        
        user.userId = generateUserId()
        user.user_Name = user_Name
        user.userEmail = userEmail
        user.phoneNumber = phoneNumber
        user.password = password
        
        do {
            try context.save()
        } catch {
            print("Save failed: \(error)")
        }
    }
    
    
    
    // --------------------------------------------------
    // CHECK EXISTING USER
    // --------------------------------------------------
    func userExists(userEmail: String) -> Bool {
        
        let context = persistentContext()
        
        let request: NSFetchRequest<NewUser> = NewUser.fetchRequest()
        request.predicate = NSPredicate(format: "userEmail == %@", userEmail)
        
        do {
            return try context.count(for: request) > 0
        } catch {
            return false
        }
    }
    
    
    
    // --------------------------------------------------
    // GENERATE RANDOM ID
    // --------------------------------------------------
    func generateUserId() -> String {
        return String(Int.random(in: 1000...9999))
    }
    
}





    
    
    
    
    


