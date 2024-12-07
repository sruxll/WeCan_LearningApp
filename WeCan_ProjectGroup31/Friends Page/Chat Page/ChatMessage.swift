//
//  ChatMessage.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestore

struct ChatMessage: Codable {
    @DocumentID var id: String?
    var senderID: String
    var senderName: String
    var messageText: String
    var timestamp: Date
    var courseID: String?  //Adela: variable for course ID, which is optional
    var courseLink: String? //Adela: Store the course link explicitly
    
    //Adela: For rich text
    var attributedMessage: NSAttributedString? {
        return ChatMessage.createAttributedMessage(text: messageText, courseID: courseID)
    }
    
    init(senderID: String, senderName: String, messageText: String, timestamp: Date, courseID: String? = nil, courseLink: String? = nil) {
        self.senderID = senderID
        self.senderName = senderName
        self.messageText = messageText
        self.timestamp = timestamp
        self.courseID = courseID
        self.courseLink = courseLink
    }
    
    // Adela: Create the attributed message dynamically
    static func createAttributedMessage(text: String, courseID: String?) -> NSAttributedString? {
        guard let courseID = courseID else { return nil }

        // Create a base attributed string
        let attributedText = NSMutableAttributedString(string: text + "\n\n")

        // Add clickable course name with the course link
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
