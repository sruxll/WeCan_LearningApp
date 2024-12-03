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
    
    init(senderID: String, senderName: String, messageText: String, timestamp: Date) {
        self.senderID = senderID
        self.senderName = senderName
        self.messageText = messageText
        self.timestamp = timestamp
    }
}
