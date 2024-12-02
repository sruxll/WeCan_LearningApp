//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by AdelaFeng
//

import Foundation

struct Course {
    let id: String // Unique identifier
    let name: String // Course name
    let description: String // Course description
    let imageURL: String // URL for the course image
    let schedule: [Section] // List of sections in the course
    var subscribedUsers: [String] // List of user IDs subscribed to the course

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

struct Section {
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

