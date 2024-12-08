//
//  ChatMessage.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import Foundation
import FirebaseFirestore

struct ChatMessage {
    var id: String? // Firestore document ID
    var senderID: String
    var senderName: String
    var messageText: String
    var timestamp: Date
    var courseID: String?  // Adela: set as Optional for invitation messages
    var courseLink: String?  // Adela: set as Optional for invitation messages

    // Determine if this is an invitation message
    var isInvitation: Bool {
        return courseID != nil || courseLink != nil
    }

    // Adela: Generate attributed message for rich text
    var attributedMessage: NSAttributedString? {
        return ChatMessage.createAttributedMessage(text: messageText, courseID: courseID)
    }

    // Initializer
    init(id: String? = nil, senderID: String, senderName: String, messageText: String, timestamp: Date, courseID: String? = nil, courseLink: String? = nil) {
        self.id = id
        self.senderID = senderID
        self.senderName = senderName
        self.messageText = messageText
        self.timestamp = timestamp
        self.courseID = courseID
        self.courseLink = courseLink
    }

    // Static method to create attributed text for invitation messages
    static func createAttributedMessage(text: String, courseID: String?) -> NSAttributedString? {
        guard let courseID = courseID else { return nil }

        let attributedText = NSMutableAttributedString(string: text + "\n\n")
        let courseName = "Click here to view course details"
        let courseLink = "course://\(courseID)"

        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .link: courseLink
        ]

        let clickableLink = NSAttributedString(string: courseName, attributes: linkAttributes)
        attributedText.append(clickableLink)

        return attributedText
    }
}

extension ChatMessage {
    // Parse a Firestore document into a ChatMessage instance
    static func fromFirestore(document: QueryDocumentSnapshot) -> ChatMessage? {
        let data = document.data()
        guard
            let senderID = data["senderID"] as? String,
            let senderName = data["senderName"] as? String,
            let messageText = data["messageText"] as? String,
            let timestamp = (data["timestamp"] as? Timestamp)?.dateValue()
        else {
            print("Error: Failed to parse ChatMessage from Firestore data.")
            return nil
        }

        let courseID = data["courseID"] as? String
        let courseLink = data["courseLink"] as? String

        return ChatMessage(
            id: document.documentID,
            senderID: senderID,
            senderName: senderName,
            messageText: messageText,
            timestamp: timestamp,
            courseID: courseID,
            courseLink: courseLink
        )
    }
}
