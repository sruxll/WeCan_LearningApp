//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit
import FirebaseFirestore

class CourseUserListViewController: UIViewController {
    private let courseUserListView = CourseUserListView()
    private var subscribedUsers = [User]() // List of users subscribed to the course
    private let database = Firestore.firestore()
    private let courseID: String

    init(courseID: String) {
        self.courseID = courseID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = courseUserListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Course User List"

        // Table view setup
        courseUserListView.tableView.delegate = self
        courseUserListView.tableView.dataSource = self
        courseUserListView.tableView.register(CourseUserListTableViewCell.self, forCellReuseIdentifier: "UserCell")

        // Fetch subscribed users
        fetchSubscribedUsers()
    }

    private func fetchSubscribedUsers() {
        // Fetch the course document to get the list of subscribed users
        database.collection("courses").document(courseID).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching course document: \(error)")
                return
            }

            guard let data = document?.data(),
                  let subscribedUserEmails = data["subscribedUsers"] as? [String] else {
                print("No subscribed users found for this course.")
                return
            }

            print("Subscribed user emails: \(subscribedUserEmails)")
            self?.loadUsers(userEmails: subscribedUserEmails)
        }
    }

    private func loadUsers(userEmails: [String]) {
        let group = DispatchGroup()
        var loadedUsers = [User]()

        for userEmail in userEmails {
            group.enter()
            database.collection("users").document(userEmail).getDocument { document, error in
                defer { group.leave() }

                if let error = error {
                    print("Error fetching user document: \(error)")
                    return
                }

                if let document = document, let userData = document.data(),
                   let user = User(documentData: userData) {
                    loadedUsers.append(user)
                }
            }
        }

        group.notify(queue: .main) {
            self.subscribedUsers = loadedUsers
            print("Loaded users: \(self.subscribedUsers.map { $0.name })")
            self.courseUserListView.tableView.reloadData()
        }
    }
}

// MARK: - Table View Delegate and Data Source
extension CourseUserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribedUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? CourseUserListTableViewCell else {
            return UITableViewCell()
        }
        let user = subscribedUsers[indexPath.row]
        print("Configuring cell for user: \(user.name)") // Debug log
        cell.configure(with: user)
        return cell
    }
}
