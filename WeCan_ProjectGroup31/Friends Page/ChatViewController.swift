//
//  ChatViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    let chatView = ChatView()
    var messages = [ChatMessage]()
    var currentUser: FirebaseAuth.User?
    var chatPartnerEmail: String? // The selected chat partner's email
    let database = Firestore.firestore()
    var course: Course? // Adela: Pass the course object for the usage of inviation message

    override func loadView() {
        view = chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = chatPartnerEmail ?? "Chat"

        chatView.tableView.delegate = self
        chatView.tableView.dataSource = self
        chatView.tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")

        // Enable automatic dimension for dynamic cell height
        chatView.tableView.rowHeight = UITableView.automaticDimension
        chatView.tableView.estimatedRowHeight = 100

        chatView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        chatView.textViewMessage.delegate = self // Adela: set UITextViewDelegate for the textViewMessage

        loadMessages()
        print("ChatViewController loaded with course: \(course?.name ?? "None"), ID: \(course?.id ?? "None")")
    }

    func loadMessages() {
        guard let currentUserEmail = currentUser?.email,
              let chatPartnerEmail = chatPartnerEmail else {
            print("Error: Missing current user or chat partner email.")
            return
        }

        let chatID = generateChatID(for: currentUserEmail, and: chatPartnerEmail)
        print("Generated chatID: \(chatID)")

        database.collection("chats").document(chatID).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error loading messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.messages = documents.compactMap { try? $0.data(as: ChatMessage.self) }
                self.chatView.tableView.reloadData()
                // Scroll to the bottom after reloading
                self.scrollToBottom(animated: true)
            }
    }

    func scrollToBottom(animated: Bool) {
        guard messages.count > 0 else { return }
        let lastRowIndex = messages.count - 1
        let indexPath = IndexPath(row: lastRowIndex, section: 0)
        chatView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }

    @objc func sendMessage() {
        guard let text = chatView.textViewMessage.text, !text.isEmpty,
              let currentUser = currentUser,
              let currentUserEmail = currentUser.email,
              let chatPartnerEmail = chatPartnerEmail else {
            print("Missing required user information or chat partner email.")
            return
        }

        let chatID = generateChatID(for: currentUserEmail, and: chatPartnerEmail)
        
        //Adela: Include the course link in the message
        let courseLink = course?.id != nil ? "course://\(course!.id)" : nil
        print("Course Link: \(courseLink ?? "None")")
        print("Course ID: \(course?.id ?? "None")")
        
        // Adela: Replace placeholders in the invitation message
        let formattedText = text
            .replacingOccurrences(of: "{courseName}", with: course?.name ?? "")
            .replacingOccurrences(of: "{courseLink}", with: courseLink ?? "")
        
        let message = ChatMessage(
            senderID: currentUser.uid,
            senderName: currentUser.displayName ?? "Anonymous",
            messageText: formattedText, //Adela: Use the formatted message text
            timestamp: Date(),
            courseID: course?.id,
            courseLink: courseLink //Adela: Include the course link explicitly
        )

        // Save message to Firebase
        do {
            try database.collection("chats").document(chatID).collection("messages").addDocument(from: message)
            print("Message sent successfully!")
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }

        // Save chat references for both users
        saveChatReference(for: currentUserEmail, chatPartnerEmail: chatPartnerEmail, chatID: chatID)
        saveChatReference(for: chatPartnerEmail, chatPartnerEmail: currentUserEmail, chatID: chatID)

        chatView.textViewMessage.text = ""
        // Scroll to the bottom after sending a message
        DispatchQueue.main.async {
            self.scrollToBottom(animated: true)
        }
    }

    private func generateChatID(for user1: String, and user2: String) -> String {
        let sortedEmails = [user1.lowercased(), user2.lowercased()].sorted().joined(separator: "_")
        return sortedEmails
    }

    private func saveChatReference(for userEmail: String, chatPartnerEmail: String, chatID: String) {
        let userRef = database.collection("users").document(userEmail)

        userRef.getDocument { document, error in
            if let error = error {
                print("Error checking user document existence: \(error.localizedDescription)")
                return
            }

            if document?.exists == true {
                // Only update the chats collection if the document exists
                userRef.collection("chats").document(chatID).setData([
                    "chatID": chatID,
                    "partnerEmail": chatPartnerEmail,
                    "lastMessage": self.messages.last?.messageText ?? "",
                    "timestamp": FieldValue.serverTimestamp()
                ], merge: true) { error in
                    if let error = error {
                        print("Error saving chat reference: \(error.localizedDescription)")
                    } else {
                        print("Chat reference updated successfully for user: \(userEmail)")
                    }
                }
            } else {
                // If the document does not exist, create it and add the chats collection
                userRef.setData(["email": userEmail]) { error in
                    if let error = error {
                        print("Error creating user document: \(error.localizedDescription)")
                        return
                    }

                    // Add the chat reference after creating the document
                    userRef.collection("chats").document(chatID).setData([
                        "chatID": chatID,
                        "partnerEmail": chatPartnerEmail,
                        "lastMessage": self.messages.last?.messageText ?? "",
                        "timestamp": FieldValue.serverTimestamp()
                    ], merge: true) { error in
                        if let error = error {
                            print("Error saving chat reference: \(error.localizedDescription)")
                        } else {
                            print("Chat reference saved successfully for user: \(userEmail)")
                        }
                    }
                }
            }
        }
    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
//        cell.configureCell(with: message, isCurrentUser: message.senderID == currentUser?.uid)
        
        // Adela: enable rich text
        if let attributedMessage = message.attributedMessage {
            cell.messageWithLinkTextView.attributedText = attributedMessage
            cell.messageWithLinkTextView.isUserInteractionEnabled = true
            cell.messageWithLinkTextView.delegate = self
        } else {
            cell.configureCell(with: message, isCurrentUser: message.senderID == currentUser?.uid)
        }
        
        return cell
    }
    
    //Adela: Handle Course Link
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "course" {
            // Extract courseID from the URL
            if let courseID = URL.host {
                // Navigate to CourseDetailViewController
                let courseDetailVC = CourseDetailViewController(courseID: courseID)
                navigationController?.pushViewController(courseDetailVC, animated: true)
            }
            return false // Prevent default handling
        }
        return true // Allow other links to work as expected
    }
}
