//
//  ViewController.swift
//  TwinTale
//
//  Created by Default User on 11/24/25.
//

import UIKit

class ViewController: UIViewController {

    // ------------------------------------------------------
    // UI ELEMENTS
    // ------------------------------------------------------
    let logoImageView = UIImageView()
    let textView = UITextView()
    let button1 = UIButton(type: .system)
    let button2 = UIButton(type: .system)
    let button3 = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "89DAF5")
        setUpUI()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


    //Mark:- SETUP UI

    func setUpUI() {

        // --------------------------------------------------
        // CONFIGURE LOGO
        // --------------------------------------------------
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.heightAnchor
            .constraint(equalToConstant: 200).isActive = true


        // --------------------------------------------------
        // CONFIGURE TEXT AREA
        // --------------------------------------------------
        textView.font = .systemFont(ofSize: 16)
        textView.isEditable = false
        textView.heightAnchor
            .constraint(equalToConstant: 75).isActive = true
        textView.backgroundColor = UIColor(hex: "89DAF5")
        textView.text =
        "'Every story begins with a single line... What you create next can change a world.'"


        // --------------------------------------------------
        // CONFIGURE BUTTONS
        // --------------------------------------------------
        // facebook login button
        button1.setTitle("Facebook Login", for: .normal)
        button1.setTitleColor(.white, for: .normal)
        button1.backgroundColor = UIColor(hex: "#1877F2")   // Facebook Blue
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.white.cgColor
        button1.layer.cornerRadius = 8
        button1.clipsToBounds = true
        
        //
        
        // Register Button
        button2.setTitle("Register", for: .normal)
        button2.setTitleColor(.white, for: .normal)
        button2.backgroundColor = UIColor(hex: "#1877F2")   // Facebook Blue
        button2.layer.borderWidth = 1
        button2.layer.borderColor = UIColor.white.cgColor
        button2.layer.cornerRadius = 8
        button2.clipsToBounds = true
        button2.addTarget(self,
                          action: #selector(goToRegistration),
                          for: .touchUpInside)

        
        // login Button
        button3.setTitle("Login", for: .normal)
        button3.setTitleColor(.white, for: .normal)
        button3.backgroundColor = UIColor(hex: "#1877F2")   // Facebook Blue
        button3.layer.borderWidth = 1
        button3.layer.borderColor = UIColor.white.cgColor
        button3.layer.cornerRadius = 8
        button3.clipsToBounds = true
        button3.addTarget(self,
                          action: #selector(goToLogInPage),
                          for: .touchUpInside)
        let buttons = [button1, button2, button3]
        buttons.forEach {
            $0.heightAnchor
                .constraint(equalToConstant: 44).isActive = true
        }
        
         buttons.forEach { btn in
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }


        // --------------------------------------------------
        // CREATE STACK VIEW
        // --------------------------------------------------
        let stack = UIStackView(arrangedSubviews: [
            logoImageView,
            textView,
            button1,
            button2,
            button3
        ])

        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)


        // --------------------------------------------------
        // AUTO LAYOUT
        // --------------------------------------------------
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            stack.widthAnchor.constraint(equalTo: view.widthAnchor,
                                       multiplier: 0.8)
        ])
    }
    
    
    @objc func goToRegistration() {
        performSegue(withIdentifier: "GoToRegistrationPage", sender: self)
    }
    
    @objc func goToLogInPage() {
        performSegue(withIdentifier: "directLogInSegue", sender: self)
    }

        
    }
        
    

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    

}
