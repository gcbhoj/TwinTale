//
//  TestingTableViewController.swift
//  TwinTale
//
//  Created by Default User on 11/30/25.
//

import UIKit

class TestingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray6

        // --- Create elements ---
        let logoImage = UIImageView(image: UIImage(named: "logo"))
        logoImage.contentMode = .scaleAspectFit
        logoImage.widthAnchor.constraint(equalToConstant: 141).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 126).isActive = true

        let categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let categoryTypeLabel = UITextField()
        categoryTypeLabel.text = "Friendship"
        categoryTypeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let categoryStack = UIStackView(arrangedSubviews: [categoryLabel, categoryTypeLabel])
        categoryStack.axis = .horizontal
        categoryStack.alignment = .center
        categoryStack.distribution = .equalSpacing
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLabel = UILabel()
        timeLabel.text = "Time Left"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let timeLeftDisplay = UITextField()
        timeLeftDisplay.text = "30:00"
        timeLeftDisplay.font = UIFont.systemFont(ofSize: 16)
        
        let timeDisplayStack = UIStackView(arrangedSubviews: [timeLabel,timeLeftDisplay])
        timeDisplayStack.axis = .horizontal
        timeDisplayStack.alignment = .center
        timeDisplayStack.distribution = .equalSpacing
        timeDisplayStack.translatesAutoresizingMaskIntoConstraints = false
        
        let textStack = UIStackView(arrangedSubviews: [categoryStack,timeDisplayStack])
        textStack.axis = .vertical
        textStack.alignment = .center
        textStack.distribution = .equalSpacing
        textStack.translatesAutoresizingMaskIntoConstraints = false
        

        // --- Stack View ---
        let stack = UIStackView(arrangedSubviews: [logoImage, textStack])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(stack)

        // Constraints
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: headerView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])

        return headerView
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestingTableViewCell", for: indexPath)

        // Configure the cell...

        return cell
    }
    
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
