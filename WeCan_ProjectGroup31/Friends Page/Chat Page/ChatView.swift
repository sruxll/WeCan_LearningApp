//
//  ChatView.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit

class ChatView: UIView {
    var tableView: UITableView!
//    var textField: UITextField!
    var textViewMessage: UITextView! // Adela: Replaced UITextField with UITextView to allow multi-line text input
    var sendButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupTableView()
//        setupTextField()
        setupTextViewMessage() // Adela: Replaced UITextField with UITextView
        setupSendButton()
        setupConstraints()
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
    }

//    func setupTextField() {
//        textField = UITextField()
//        textField.borderStyle = .roundedRect
//        textField.placeholder = "Enter your message..."
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(textField)
//    }
    
    func setupTextViewMessage() {
        textViewMessage = UITextView()
        textViewMessage.layer.borderWidth = 1
        textViewMessage.layer.borderColor = UIColor.gray.cgColor
        textViewMessage.layer.cornerRadius = 8
        textViewMessage.font = UIFont.systemFont(ofSize: 16)
        textViewMessage.isScrollEnabled = false
        textViewMessage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textViewMessage)
    }

    func setupSendButton() {
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sendButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: textViewMessage.topAnchor, constant: -8),
            
            // Adela: Replaced UITextField with UITextView
    
//            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
//            textField.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            textViewMessage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            textViewMessage.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            textViewMessage.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            textViewMessage.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8), // Leave space for the send button
            
            sendButton.leadingAnchor.constraint(equalTo: textViewMessage.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: textViewMessage.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60) // Fixed width for the button
        ])
    }
    
    // Adela: Adjust the height of textView dynamically based on the content size.
    func textViewDidChange(_ textView: UITextView) {
        // Resize the textView based on its content
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = max(40, estimatedSize.height) // Minimum height of 40
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
