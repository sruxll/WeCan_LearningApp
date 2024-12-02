//
//  ChatViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friendData: [String: Any]? // Data for the selected friend
    private var tableView: UITableView!
    private var chatMessages: [String] = ["Hello!", "Hi, how are you?", "I'm good, thanks!"] // Sample chat messages
    
    private let messageInputBar: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your message..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = friendData?["username"] as? String ?? "Chat"
        view.backgroundColor = .white
        setupTableView()
        setupMessageInputBar()
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChatCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }
    
    func setupMessageInputBar() {
        view.addSubview(messageInputBar)
        messageInputBar.addSubview(messageTextField)
        messageInputBar.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            messageInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageInputBar.heightAnchor.constraint(equalToConstant: 60),
            
            messageTextField.leadingAnchor.constraint(equalTo: messageInputBar.leadingAnchor, constant: 10),
            messageTextField.centerYAnchor.constraint(equalTo: messageInputBar.centerYAnchor),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),
            
            sendButton.trailingAnchor.constraint(equalTo: messageInputBar.trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: messageInputBar.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        sendButton.addTarget(self, action: #selector(onSendButtonTapped), for: .touchUpInside)
    }
    
    @objc func onSendButtonTapped() {
        guard let message = messageTextField.text, !message.isEmpty else { return }
        chatMessages.append(message)
        messageTextField.text = nil
        tableView.reloadData()
        scrollToBottom()
    }
    
    func scrollToBottom() {
        let indexPath = IndexPath(row: chatMessages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        cell.textLabel?.text = chatMessages[indexPath.row]
        return cell
    }
}

