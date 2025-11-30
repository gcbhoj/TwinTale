//
//  GamePageTableViewController.swift
//  TwinTale
//
//  Created by Default User on 11/28/25.
//

import UIKit

class GamePageTableViewController: UITableViewController {
    
    // MARK: - Message Model
    struct Message {
        let sender: String
        let text: String
    }

    var messages: [Message] = [
        Message(sender: "You", text: "True friends stay by your side when you need them most."),
        Message(sender: "Friend", text: "Absolutely! That's what friends are for."),
        Message(sender: "Jack", text: "Hello, how are you?")
    ]
    
    // MARK: - Timer
    var timerLabel: UITextField!
    var countdownTimer: Timer?
    var remainingSeconds = 60   // 1 minute for 24 hours use 24*60*60

    // MARK: - Footer References
    var inputField: UITextField!
    var sendButton: UIButton!
    var completeStoryButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestingTableViewCell")
        tableView.separatorStyle = .none
        startTimer()
    }

    // MARK: - Timer Functions
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(updateTimer),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    @objc func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            timerLabel.text = formatTime(remainingSeconds)
        } else {
            countdownTimer?.invalidate()
            timerLabel.text = "00:00:00"
            
            // Disable input when timer ends
            inputField.isEnabled = false
            sendButton.isEnabled = false
            completeStoryButton.isEnabled = false
            
            // Automatically navigate to next page
            performSegue(withIdentifier: "goToMoralPage", sender: self)
        }
    }
    
    func formatTime(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }

    // MARK: - TableView Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray6

        // Logo
        let logoImage = UIImageView(image: UIImage(named: "logo"))
        logoImage.contentMode = .scaleAspectFit
        logoImage.widthAnchor.constraint(equalToConstant: 141).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 126).isActive = true

        // Category
        let categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let categoryTypeLabel = UITextField()
        categoryTypeLabel.text = "Friendship"
        categoryTypeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let categoryStack = UIStackView(arrangedSubviews: [categoryLabel, categoryTypeLabel])
        categoryStack.axis = .horizontal
        categoryStack.distribution = .equalSpacing
        
        // Time Left
        let timeLabel = UILabel()
        timeLabel.text = "Time Left"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        timerLabel = UITextField()
        timerLabel.text = formatTime(remainingSeconds)
        timerLabel.font = UIFont.systemFont(ofSize: 16)
        
        let timeStack = UIStackView(arrangedSubviews: [timeLabel, timerLabel])
        timeStack.axis = .horizontal
        timeStack.distribution = .equalSpacing
        
        let textStack = UIStackView(arrangedSubviews: [categoryStack, timeStack])
        textStack.axis = .vertical
        textStack.distribution = .equalSpacing
        
        let mainStack = UIStackView(arrangedSubviews: [logoImage, textStack])
        mainStack.axis = .horizontal
        mainStack.distribution = .equalSpacing
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            mainStack.topAnchor.constraint(equalTo: headerView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }

    // MARK: - TableView Footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.systemGray6
        
        // Input Field
        inputField = UITextField()
        inputField.placeholder = "Enter Your Part..."
        inputField.borderStyle = .roundedRect
        inputField.translatesAutoresizingMaskIntoConstraints = false
        
        // Send Button
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        let inputStack = UIStackView(arrangedSubviews: [inputField, sendButton])
        inputStack.axis = .horizontal
        inputStack.spacing = 8
        inputStack.alignment = .center
        inputStack.distribution = .fillProportionally
        
        // Complete Story Button
        completeStoryButton = UIButton(type: .system)
        completeStoryButton.setTitle("Complete Story", for: .normal)
        completeStoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        completeStoryButton.translatesAutoresizingMaskIntoConstraints = false
        completeStoryButton.addTarget(self, action: #selector(completeTask), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [inputStack, completeStoryButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -8)
        ])

        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120
    }

    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TestingTableViewCell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let msg = messages[indexPath.row]

        // Sender Label
        let senderLabel = UILabel()
        senderLabel.text = msg.sender
        senderLabel.font = UIFont.boldSystemFont(ofSize: 15)

        // Message Label
        let messageLabel = UILabel()
        messageLabel.text = msg.text
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.numberOfLines = 0

        // Stack
        let stack = UIStackView(arrangedSubviews: [senderLabel, messageLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        cell.contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12)
        ])

        return cell
    }

    // MARK: - Button Actions
    @objc func sendMessage() {
        guard let text = inputField.text, !text.isEmpty else { return }
        messages.append(Message(sender: "You", text: text))
        inputField.text = ""
        tableView.reloadData()
    }
    
    @objc func completeTask() {
        // Disable input/buttons
        inputField.isEnabled = false
        sendButton.isEnabled = false
        completeStoryButton.isEnabled = false
        
        // Navigate
        performSegue(withIdentifier: "goToMoralPage", sender: self)
    }

}
