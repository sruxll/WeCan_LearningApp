//
//  ChatTableViewCell.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
//    var messageLabel: UILabel!
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var messageWithLinkTextView: UITextView! // Adela: Supports clickable links

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

//        // Initialize and configure messageLabel
//        messageLabel = UILabel()
//        messageLabel.font = UIFont.systemFont(ofSize: 16)
//        messageLabel.numberOfLines = 0 // Allow multi-line text
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(messageLabel)
        
        // Initialize and configure messageWithLinkTextView
        messageWithLinkTextView = UITextView()
        messageWithLinkTextView.font = UIFont.systemFont(ofSize: 16)
        messageWithLinkTextView.isEditable = false // Prevent editing
        messageWithLinkTextView.isScrollEnabled = false // Adjust size to fit content
        messageWithLinkTextView.dataDetectorTypes = [.link] // Detect and enable clickable links
        messageWithLinkTextView.textContainerInset = .zero // Remove extra padding
        messageWithLinkTextView.backgroundColor = .clear
        messageWithLinkTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageWithLinkTextView)

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
            messageWithLinkTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            messageWithLinkTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageWithLinkTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Time label below the messageLabel
            timeLabel.topAnchor.constraint(equalTo: messageWithLinkTextView.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configureCell(with message: ChatMessage, isCurrentUser: Bool) {
        nameLabel.text = isCurrentUser ? "You" : message.senderName

        if let attributedMessage = message.attributedMessage {
            messageWithLinkTextView.attributedText = attributedMessage
            messageWithLinkTextView.isUserInteractionEnabled = true
            messageWithLinkTextView.dataDetectorTypes = .link
        } else {
            messageWithLinkTextView.text = message.messageText
        }

        timeLabel.text = DateFormatter.localizedString(from: message.timestamp, dateStyle: .short, timeStyle: .short)

        // Adjust alignment dynamically
        if isCurrentUser {
            nameLabel.textAlignment = .right
            messageWithLinkTextView.textAlignment = .right
            timeLabel.textAlignment = .right
        } else {
            nameLabel.textAlignment = .left
            messageWithLinkTextView.textAlignment = .left
            timeLabel.textAlignment = .left
        }
    }

}

