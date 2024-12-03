//
//  ChatTableViewCell.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    var messageLabel: UILabel!
    var nameLabel: UILabel!
    var timeLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Initialize and configure nameLabel
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = .gray
        nameLabel.numberOfLines = 1
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        // Initialize and configure messageLabel
        messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0 // Allow multi-line text
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageLabel)

        // Initialize and configure timeLabel
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .lightGray
        timeLabel.numberOfLines = 1
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
    }

    private func setupConstraints() {
        // Constraints for nameLabel, messageLabel, and timeLabel
        NSLayoutConstraint.activate([
            // Name label at the top
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Message label below the nameLabel
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Time label below the messageLabel
            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configureCell(with message: ChatMessage, isCurrentUser: Bool) {
        // Configure UI elements based on message data
        nameLabel.text = isCurrentUser ? "You" : message.senderName
        messageLabel.text = message.messageText
        timeLabel.text = DateFormatter.localizedString(from: message.timestamp, dateStyle: .short, timeStyle: .short)

        // Adjust alignment and background color dynamically
        if isCurrentUser {
            nameLabel.textAlignment = .right
            messageLabel.textAlignment = .right
            timeLabel.textAlignment = .right
            contentView.backgroundColor = .systemGray6
        } else {
            nameLabel.textAlignment = .left
            messageLabel.textAlignment = .left
            timeLabel.textAlignment = .left
            contentView.backgroundColor = .white
        }
    }

}

