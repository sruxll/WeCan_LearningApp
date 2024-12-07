//
//  Course.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import Foundation

struct Course: Codable {
    let id: String // Unique identifier
    var name: String // Course name
    var description: String // Course description
    var imageURL: String // URL for the course image
    var schedule: [Section] // List of sections in the course
    var subscribedUsers: [String] // List of user IDs subscribed to the course

    // Lightweight initializer with only an ID
    init(id: String) {
        self.id = id
        self.name = "Unknown Course" // Placeholder
        self.description = "Description not available" // Placeholder
        self.imageURL = "" // Placeholder for the image URL
        self.schedule = [] // Empty schedule
        self.subscribedUsers = [] // No subscribed users initially
    }

    // Initialize Course from Firestore document data
    init?(document: [String: Any]) {
        guard
            let id = document["id"] as? String,
            let name = document["name"] as? String,
            let description = document["description"] as? String,
            let imageURL = document["imageURL"] as? String,
            let scheduleData = document["schedule"] as? [[String: Any]]
        else {
            return nil
        }

        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.schedule = scheduleData.compactMap { Section(dictionary: $0) }
        self.subscribedUsers = document["subscribedUsers"] as? [String] ?? []
    }

    // Convert Course to dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "description": description,
            "imageURL": imageURL,
            "schedule": schedule.map { $0.toDictionary() },
            "subscribedUsers": subscribedUsers
        ]
    }
}


struct Section: Codable {
    let sectionNumber: Int // Section number (e.g., 1, 2, etc.)
    let title: String // Title of the section

    // Direct initializer
    init(sectionNumber: Int, title: String) {
        self.sectionNumber = sectionNumber
        self.title = title
    }

    // Initialize Section from dictionary data
    init?(dictionary: [String: Any]) {
        guard
            let sectionNumber = dictionary["sectionNumber"] as? Int,
            let title = dictionary["title"] as? String
        else {
            return nil
        }
        self.sectionNumber = sectionNumber
        self.title = title
    }

    // Convert Section to dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return [
            "sectionNumber": sectionNumber,
            "title": title
        ]
    }
}


