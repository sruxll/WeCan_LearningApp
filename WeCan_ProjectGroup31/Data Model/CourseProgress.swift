//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by AdelaFeng
//

import Foundation

struct CourseProgress {
    let course: Course
    let completedSections: [Int]

    var progressPercentage: Double {
        guard !course.schedule.isEmpty else { return 0 }
        return Double(completedSections.count) / Double(course.schedule.count) * 100
    }
}
