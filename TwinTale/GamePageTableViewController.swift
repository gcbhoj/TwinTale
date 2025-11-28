//
//  GamePageTableViewController.swift
//  TwinTale
//
//  Created by Default User on 11/28/25.
//

import UIKit

class GamePageTableViewController: UITableViewController {
    
    @IBOutlet var timeRemainingField : UITextField!
    
    struct Message {
        let sender: String
        let text: String
    }

    var messages: [Message] = [
        Message(sender: "You", text: "True friends stay by your side when you need them most."),
        Message(sender: "Friend", text: "Absolutely! That's what friends are for."),
        Message(sender:"Jack", text:"Hello HOw are You?")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make cell height expand automatically
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count     // <-- FIXED
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamePageTableViewCell", for: indexPath)

        let message = messages[indexPath.row]
        
        // Enable multiline text
        cell.textLabel?.numberOfLines = 0

        // Show sender + message text
        cell.textLabel?.text = "\(message.sender):\n\(message.text)"   // <-- FIXED

        return cell
    }
}
