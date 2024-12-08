//
//  ChatTableViewCell.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit

class ChatTableViewCell: UITableViewCell, UITextViewDelegate {
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var messageWithLinkTextView: UITextView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = .gray
        nameLabel.numberOfLines = 1
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        messageWithLinkTextView = UITextView()
        messageWithLinkTextView.font = UIFont.systemFont(ofSize: 16)
        messageWithLinkTextView.isEditable = false
        messageWithLinkTextView.isScrollEnabled = false
        messageWithLinkTextView.textContainerInset = .zero
        messageWithLinkTextView.backgroundColor = .clear
        messageWithLinkTextView.dataDetectorTypes = [.link] // Enable all links
        messageWithLinkTextView.delegate = self
        messageWithLinkTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageWithLinkTextView)

        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .lightGray
        timeLabel.numberOfLines = 1
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            messageWithLinkTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            messageWithLinkTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageWithLinkTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            timeLabel.topAnchor.constraint(equalTo: messageWithLinkTextView.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configureCell(with message: ChatMessage, isCurrentUser: Bool, delegate: UITextViewDelegate) {
        // Set the UITextView delegate to the passed-in delegate (usually the ChatViewController)
        messageWithLinkTextView.delegate = delegate

        // Reset the cell to clear any previous configurations
        resetCell()

        // Check if the message is an invitation or a regular message
        if message.isInvitation {
            configureInvitationMessage(message: message, isCurrentUser: isCurrentUser)
        } else {
            configureNormalMessage(message: message, isCurrentUser: isCurrentUser)
        }
    }

    private func configureNormalMessage(message: ChatMessage, isCurrentUser: Bool) {
        messageWithLinkTextView.attributedText = NSAttributedString(string: message.messageText)
        messageWithLinkTextView.dataDetectorTypes = [] // Disable link detection for normal messages

        nameLabel.text = isCurrentUser ? "You" : message.senderName
        timeLabel.text = DateFormatter.localizedString(from: message.timestamp, dateStyle: .short, timeStyle: .short)

        nameLabel.textAlignment = isCurrentUser ? .right : .left
        messageWithLinkTextView.textAlignment = isCurrentUser ? .right : .left
        timeLabel.textAlignment = isCurrentUser ? .right : .left
        
        // Set background color for sender's message
        if isCurrentUser {
            contentView.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.9, alpha: 1.0) // Light brown
        } else {
            contentView.backgroundColor = .white // Default for receiver
        }
    }

    private func configureInvitationMessage(message: ChatMessage, isCurrentUser: Bool) {
        let attributedText = NSMutableAttributedString(string: message.messageText + "\n\n")
        if let courseLink = message.courseLink {
            attributedText.append(NSAttributedString(
                string: "Click here to view course details",
                attributes: [
                    .link: URL(string: courseLink)!,
                    .foregroundColor: UIColor.systemBlue
                ]
            ))
        }

        messageWithLinkTextView.attributedText = attributedText
        messageWithLinkTextView.dataDetectorTypes = [.link] // Enable clickable links

        nameLabel.text = isCurrentUser ? "You" : message.senderName
        timeLabel.text = DateFormatter.localizedString(from: message.timestamp, dateStyle: .short, timeStyle: .short)

        // Adjust alignment
        nameLabel.textAlignment = isCurrentUser ? .right : .left
        messageWithLinkTextView.textAlignment = isCurrentUser ? .right : .left
        timeLabel.textAlignment = isCurrentUser ? .right : .left
        
        // Set background color for sender's message
        if isCurrentUser {
            contentView.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.9, alpha: 1.0) // Light brown color
        } else {
            contentView.backgroundColor = .white // Default for receiver
        }
    }

    private func resetCell() {
        nameLabel.text = nil
        timeLabel.text = nil
        messageWithLinkTextView.attributedText = nil
        messageWithLinkTextView.dataDetectorTypes = [] // Clear links
        messageWithLinkTextView.textAlignment = .left
    }
}
