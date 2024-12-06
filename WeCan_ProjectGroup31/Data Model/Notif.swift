//
//  Notif.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/5/24.
//

import Foundation
import FirebaseFirestore

struct Notif: Codable{
    @DocumentID var notifId: String?
    var dateTime = Timestamp(date: Date())
    var messageFrom: String
    var message: String
    var requiresResponse: Bool
    var isNotificationRead: Bool
    var isDeleted: Bool
    
    init(messageFrom: String, message: String, requiresResponse: Bool, isNotificationRead: Bool, isDeleted: Bool){
        self.messageFrom = messageFrom
        self.message = message
        self.requiresResponse = requiresResponse
        self.isNotificationRead = isNotificationRead
        self.isDeleted = isDeleted
    }
}
