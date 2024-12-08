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
    var chatPartnerEmail: String?
    let database = Firestore.firestore()

    // Added course property to handle invitation messages
    var course: Course? // Optional: The course associated with the chat (if any)

    override func loadView() {
        view = chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = chatPartnerEmail ?? "Chat"

        chatView.tableView.delegate = self
        chatView.tableView.dataSource = self
        chatView.tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")

        chatView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        chatView.textViewMessage.delegate = self

        loadMessages()
    }

    func loadMessages() {
        guard let currentUserEmail = currentUser?.email, let chatPartnerEmail = chatPartnerEmail else {
            print("Error: Missing user or chat partner email.")
            return
        }

        let chatID = generateChatID(for: currentUserEmail, and: chatPartnerEmail)
        database.collection("chats").document(chatID).collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error loading messages: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.messages = documents.compactMap { ChatMessage.fromFirestore(document: $0) }
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
              let chatPartnerEmail = chatPartnerEmail else {
            print("Missing required information.")
            return
        }

        let chatID = generateChatID(for: currentUser.email!, and: chatPartnerEmail)
        let courseLink = course != nil ? "course://\(course!.id)" : nil

        let formattedText = text
            .replacingOccurrences(of: "{courseName}", with: course?.name ?? "")
            .replacingOccurrences(of: "{courseLink}", with: courseLink ?? "")

        let message = ChatMessage(
            senderID: currentUser.uid,
            senderName: currentUser.displayName ?? "Anonymous",
            messageText: formattedText,
            timestamp: Date(),
            courseID: course?.id,
            courseLink: courseLink
        )

        do {
            try database.collection("chats").document(chatID).collection("messages").addDocument(data: [
                "senderID": message.senderID,
                "senderName": message.senderName,
                "messageText": message.messageText,
                "timestamp": message.timestamp,
                "courseID": message.courseID ?? NSNull(),
                "courseLink": message.courseLink ?? NSNull()
            ])
            print("Message sent successfully!")
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }

        chatView.textViewMessage.text = ""
        
        // Clear the course property after sending the invitation
        if course != nil {
            print("Clearing course information after sending invitation message.")
            course = nil
        }
        
        // Scroll to the bottom of the chat
        DispatchQueue.main.async {
            self.scrollToBottom(animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        cell.configureCell(with: message, isCurrentUser: message.senderID == currentUser?.uid, delegate: self)
        return cell
    }

    private func generateChatID(for user1: String, and user2: String) -> String {
        return [user1.lowercased(), user2.lowercased()].sorted().joined(separator: "_")
    }
    
    //Adela: Handle Course Link
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("Tapped URL: \(URL.absoluteString)")
        if URL.scheme == "course" {
            // Extract courseID from the URL
            if let courseID = URL.host {
                print("Navigating to CourseDetailViewController with courseID: \(courseID)")
                let courseDetailVC = CourseDetailViewController(courseID: courseID)
                navigationController?.pushViewController(courseDetailVC, animated: true)
            }
            return false // Prevent default handling of the link
        }
        return true // Allow default handling for other links
    }

}
