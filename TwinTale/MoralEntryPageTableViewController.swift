//
//  MoralEntryPageTableViewController.swift
//  TwinTale
//
//  Created by Default User on 11/30/25.
//

import UIKit

class MoralEntryPageTableViewController: UITableViewController {
    
    @IBOutlet var timeRemainingField : UITextField!
    
    struct Moral {
        let sender: String
        let text: String
    }

    var morals: [Moral] = [
        Moral(sender: "You", text: "True friends stay by your side when you need them most."),
        Moral(sender: "Friend", text: "Absolutely! That's what friends are for."),
        Moral(sender:"Jack", text:"Hello HOw are You?")
    ]
    
    var timer: Timer?
    var remainingSeconds = 30 * 60    // 30 minutes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make cell height expand automatically
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        startTimer()
    }
    
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
            timer?.invalidate()
            timer = nil
            redirectToNextPage()
        }
        
        updateTimeField()
    }
    
    func updateTimeField() {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        timeRemainingField.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func redirectToNextPage() {
        performSegue(withIdentifier: "goToNextPage", sender: self)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return morals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoralEntryPageTableViewCell", for: indexPath)

        let moral = morals[indexPath.row]
        
        // Enable multiline text
        cell.textLabel?.numberOfLines = 0

        // Show sender + message text
        cell.textLabel?.text = "\(moral.sender):\n\(moral.text)"   // <-- FIXED

        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
