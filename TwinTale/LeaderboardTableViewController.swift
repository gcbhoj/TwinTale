//
//  LeaderboardTableViewController.swift
//  TwinTale
//
//  Created by Default User on 11/28/25.
//

import UIKit

class LeaderboardTableViewController: UITableViewController {

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
        let rankLabel = UILabel()
        rankLabel.text = "#"
        rankLabel.font = UIFont.boldSystemFont(ofSize: 16)

        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)

        let medalImage = UIImageView(image: UIImage(named: "MedalIcon"))
        medalImage.contentMode = .scaleAspectFit
        medalImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        medalImage.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let coinImage = UIImageView(image: UIImage(named: "Coins"))
        coinImage.contentMode = .scaleAspectFit
        coinImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        coinImage.heightAnchor.constraint(equalToConstant: 24).isActive = true

        // --- Stack View ---
        let stack = UIStackView(arrangedSubviews: [rankLabel, nameLabel, medalImage, coinImage])
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderBoardTableViewCell", for: indexPath)

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
