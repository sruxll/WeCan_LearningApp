//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit
import FirebaseFirestore

class FriendsProgressViewController: UIViewController {
    private let friendsProgressView = FriendsProgressView()
    private let course: Course
    private var friendsProgress: [(user: User, progress: [Int: Bool])] = [] // Friends and their progress
    private let database = Firestore.firestore()

    init(course: Course) {
        self.course = course
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = friendsProgressView // Use FriendsProgressView as the main view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = course.name
        
        // Table view setup
        friendsProgressView.tableView.delegate = self
        friendsProgressView.tableView.dataSource = self
        friendsProgressView.tableView.register(FriendsProgressTableViewCell.self, forCellReuseIdentifier: "FriendsProgressCell")

        fetchFriendsProgress() // Fetch data
    }

    private func fetchFriendsProgress() {
        // Fetch only users who have subscribed to this course
        database.collection("users")
            .whereField("subscribedCourses", arrayContains: course.id)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching users: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                var friends: [User] = []
                for document in documents {
                    if let user = User(documentData: document.data()) {
                        friends.append(user)
                    }
                }

                self?.loadProgress(for: friends)
            }
    }

    private func loadProgress(for friends: [User]) {
        let group = DispatchGroup()
        var loadedProgress: [(user: User, progress: [Int: Bool])] = []

        for friend in friends {
            group.enter()
            let progressRef = database.collection("userProgress").document("\(friend.email)_\(course.id)")
            progressRef.getDocument { document, error in
                if let document = document, let progressData = document.data(),
                   let completedSections = progressData["completedSections"] as? [Int] {
                    var progress = [Int: Bool]()
                    completedSections.forEach { progress[$0] = true }
                    loadedProgress.append((user: friend, progress: progress))
                } else {
                    loadedProgress.append((user: friend, progress: [:])) // No progress
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.friendsProgress = loadedProgress
            self.friendsProgressView.tableView.reloadData()
        }
    }
}

// MARK: - Table View Delegate and Data Source
extension FriendsProgressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsProgress.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsProgressCell", for: indexPath) as? FriendsProgressTableViewCell else {
            return UITableViewCell()
        }

        let friendProgress = friendsProgress[indexPath.row]
        cell.configure(with: friendProgress.user, progress: friendProgress.progress, course: course)
        return cell
    }
}
