//
//  LoginPageController.swift
//  TwinTale
//
//  Created by Default User on 12/7/25.
//

import UIKit
import CoreData
import CryptoKit

class LoginPageController: UIViewController {
    
    let logoImageView = UIImageView()
    let headingView = UILabel()
    let emailField = UITextField()
    let passwordField = UITextField()
    let logInButton = UIButton(type: .system)
    
    var loggedInUser: NewUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "88B6F4")
        
        setUpUI()
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToHome" {
            
            let vc = segue.destination as! HomeController
            vc.loggedInUser = loggedInUser
        }
    }
    
    // Mark: - CORE DATA CONTEXT
    
    func persistentContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    }
    
    
    //MArk:- Authenticate User
    @objc func authenticateUser() {
            
            guard let email = emailField.text,
                  let password = passwordField.text else {
                showAlert("Please enter email and password")
                return
            }
            
            if let user = verifyUserNameAndPassword(userEmail: email, password: password) {
                
                // SAVE Logged user
                self.loggedInUser = user
                
                // GO TO HOME
                performSegue(withIdentifier: "GoToHome", sender: self)
                
            } else {
                showAlert("Invalid username or password")
            }
        }
    
    
    //MARK:- Verying user name and password
    
    func verifyUserNameAndPassword(userEmail: String,
                                 password: String) -> NewUser? {
        
        let context = persistentContext()
        
        // Hash password exactly same way as when saving
        let hashed = hashPassword(password)
        
        let request: NSFetchRequest<NewUser> = NewUser.fetchRequest()
        request.predicate = NSPredicate(
            format: "userEmail == %@ AND password == %@",
            userEmail,
            hashed
        )
        
        do {
            let results = try context.fetch(request)
            
            return results.first   // returns user object or nil
            
        } catch {
            print("Verification failed:", error)
            return nil
        }
    }


    
    
    //MARK:- Set up UI
    
    func setUpUI(){
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
        
        //heading view
        
        headingView.text = " Log In"
        headingView.font = .systemFont(ofSize: 18)
        headingView.heightAnchor
            .constraint(equalToConstant: 75).isActive = true
        headingView.textAlignment = .center
        
        
        // Input Fields
        emailField.placeholder = "Email Address"
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        
        let fields = [
            emailField,
            passwordField
        ]
        
        fields.forEach {
            $0.borderStyle = .roundedRect
            $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        //login Button
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.backgroundColor = UIColor(hex: "#1877F2")   // Facebook Blue
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = UIColor.white.cgColor
        logInButton.layer.cornerRadius = 8
        logInButton.clipsToBounds = true
        logInButton.addTarget(self,
                          action: #selector(authenticateUser),
                          for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logInButton.widthAnchor.constraint(equalToConstant: 200),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // STACK
        
        let stack = UIStackView(arrangedSubviews: [
            headingView,
            emailField,
            passwordField,
            logInButton
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
    
    
    // Mark:-TEXT FIELD CREATOR
    
    func makeInputField(_ placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return tf
    }
    
    
    // Mark: CHECK EXISTING USER
    
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
    

    // Mark:- PASSWORD HASH

    func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    
 
    // ALERT

    func showAlert(_ msg: String) {
        let alert = UIAlertController(
            title: "Message",
            message: msg,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
