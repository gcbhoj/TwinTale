//
//  LeaderboardTableViewCell.swift
//  TwinTale
//
//  Created by Default User on 11/28/25.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let medalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let coinsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.systemOrange
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(rankLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(medalLabel)
        containerView.addSubview(coinsLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            rankLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 30),
            
            nameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            medalLabel.trailingAnchor.constraint(equalTo: coinsLabel.leadingAnchor, constant: -20),
            medalLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            medalLabel.widthAnchor.constraint(equalToConstant: 40),
            
            coinsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coinsLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            coinsLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Configuration
    func configure(rank: Int, name: String, medals: Int, coins: Int) {
        // Set rank with special styling for top 3
        switch rank {
        case 1:
            rankLabel.text = "🥇"
        case 2:
            rankLabel.text = "🥈"
        case 3:
            rankLabel.text = "🥉"
        default:
            rankLabel.text = "\(rank)"
        }
        
        nameLabel.text = name
        medalLabel.text = "🏅 \(medals)"
        coinsLabel.text = "\(coins)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animate(withDuration: 0.1) {
            self.alpha = highlighted ? 0.7 : 1.0
        }
    }
}
