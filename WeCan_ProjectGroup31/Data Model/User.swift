//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by AdelaFeng
//

import Foundation

struct User {
    let name: String
    let email: String
    let phone: String
    let photoURL: String?
    // [Final Project: WeCan]
    var subscribedCourses: [String] // List of course IDs the user is subscribed to
    
    // Initialize User from Firestore document data
    init?(documentData: [String: Any]) {
        guard let email = documentData["email"] as? String,
              let name = documentData["name"] as? String,
              let phone = documentData["phone"] as? String else {
            return nil
        }
        self.email = email
        self.name = name
        self.phone = phone
        self.photoURL = documentData["photoURL"] as? String
        self.subscribedCourses = documentData["subscribedCourses"] as? [String] ?? []
    }
}
