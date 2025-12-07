//
//  LeaderboardTableViewController.swift
//  TwinTale
//
//  Created by Default User on 11/28/25.
//

import UIKit

class LeaderboardTableViewController: UITableViewController {
    
    // MARK: - Properties
    private let cellIdentifier = "LeaderBoardTableViewCell"
    
    // Sample data - replace with real data source later
    private var leaderboardData: [(name: String, medals: Int, coins: Int)] = [
        ("Emma", 15, 2500),
        ("Liam", 12, 2100),
        ("Olivia", 10, 1800),
        ("Noah", 9, 1650),
        ("Ava", 8, 1400),
        ("Elijah", 7, 1200),
        ("Sophia", 6, 1000),
        ("Lucas", 5, 850),
        ("Isabella", 4, 700),
        ("Mason", 3, 550)
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Style the table view
        tableView.backgroundColor = UIColor.systemBackground
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        // Add subtle shadow to navigation bar area
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        // Enable smooth scrolling
        tableView.showsVerticalScrollIndicator = true
    }
    
    // MARK: - Table View Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray6

        // --- Create elements with improved styling ---
        let rankLabel = UILabel()
        rankLabel.text = "#"
        rankLabel.font = UIFont.boldSystemFont(ofSize: 16)
        rankLabel.textColor = UIColor.label

        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = UIColor.label

        let medalImage = UIImageView(image: UIImage(named: "MedalIcon"))
        medalImage.contentMode = .scaleAspectFit
        medalImage.tintColor = UIColor.systemOrange
        medalImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        medalImage.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let coinImage = UIImageView(image: UIImage(named: "Coins"))
        coinImage.contentMode = .scaleAspectFit
        coinImage.tintColor = UIColor.systemYellow
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
            stack.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        // Configure with data
        let data = leaderboardData[indexPath.row]
        
        // Add rank styling for top 3
        if indexPath.row < 3 {
            cell.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.1)
        } else {
            cell.backgroundColor = UIColor.systemBackground
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
