//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by AdelaFeng
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyCoursesViewController: UIViewController {
    private let myCoursesView = MyCoursesView()
    private var subscribedCourses = [Course]() // List of user's subscribed courses
    private var userProgress = [String: [Int: Bool]]() // Maps course ID to section progress
    private let database = Firestore.firestore()

    override func loadView() {
        view = myCoursesView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Courses"

        // Table view setup
        myCoursesView.tableView.delegate = self
        myCoursesView.tableView.dataSource = self
        myCoursesView.tableView.register(MyCourseTableViewCell.self, forCellReuseIdentifier: "MyCourseCell")

        // Fetch subscribed courses and progress
        fetchSubscribedCourses()
    }

    private func fetchSubscribedCourses() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }

        let userRef = database.collection("users").document(userEmail)
        userRef.getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching user: \(error)")
                return
            }
            guard let data = document?.data(),
                  let user = User(documentData: data) else { return }

            let courseIDs = user.subscribedCourses
            self?.loadCourses(courseIDs: courseIDs)
        }
    }

    private func loadCourses(courseIDs: [String]) {
        let group = DispatchGroup()
        var loadedCourses = [Course]()
        var loadedProgress = [String: [Int: Bool]]()

        for courseID in courseIDs {
            group.enter()
            database.collection("courses").document(courseID).getDocument { document, error in
                if let document = document, let courseData = document.data(),
                   let course = Course(document: courseData) {
                    loadedCourses.append(course)
                }
                group.leave()
            }

            group.enter()
            database.collection("userProgress").document("\(Auth.auth().currentUser?.email ?? "")_\(courseID)").getDocument { document, error in
                if let document = document, let progressData = document.data(),
                   let completedSections = progressData["completedSections"] as? [Int] {
                    var progress = [Int: Bool]()
                    completedSections.forEach { progress[$0] = true }
                    loadedProgress[courseID] = progress
                } else {
                    loadedProgress[courseID] = [:] // Initialize empty progress
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.subscribedCourses = loadedCourses
            self.userProgress = loadedProgress
            self.myCoursesView.tableView.reloadData()
        }
    }
}

// MARK: - Table View Delegate and Data Source
extension MyCoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribedCourses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCourseCell", for: indexPath) as? MyCourseTableViewCell else {
            return UITableViewCell()
        }
        let course = subscribedCourses[indexPath.row]
        let progress = userProgress[course.id] ?? [:]
        cell.configure(with: course, progress: progress)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = subscribedCourses[indexPath.row]
        // Navigate to Course Detail
        let courseDetailVC = CourseDetailViewController(course: course, isCourseAdded: true)
        navigationController?.pushViewController(courseDetailVC, animated: true)
    }
}
