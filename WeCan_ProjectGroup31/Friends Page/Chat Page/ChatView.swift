//
//  ChatView.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit

class ChatView: UIView {
    var tableView: UITableView!
    var textField: UITextField!
    var sendButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupTableView()
        setupTextField()
        setupSendButton()
        setupConstraints()
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
    }

    func setupTextField() {
        textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter your message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
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
            tableView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -8),
            
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
