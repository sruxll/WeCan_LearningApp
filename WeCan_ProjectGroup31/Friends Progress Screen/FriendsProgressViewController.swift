//
//  FriendsProgressViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FriendsProgressViewController: UIViewController {
    private let friendsProgressView = FriendsProgressView()
    private let course: Course
    private var friendsProgress: [(user: User, progress: [Int: Bool])] = [] // Friends and their progress
    private let database = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser

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

        // Add home button to navigation bar
        setupNavigationBar()
        
        fetchFriendsData(for: course.id) // Fetch data
    }
    
    private func setupNavigationBar() {
        let homeButton = UIBarButtonItem(
            image: UIImage(systemName: "house.fill"),
            style: .plain,
            target: self,
            action: #selector(onTapHomeButton)
        )
        navigationItem.rightBarButtonItem = homeButton
    }

    @objc private func onTapHomeButton() {
        let homePageVC = HomePageViewController()
        navigationController?.pushViewController(homePageVC, animated: true)
    }

    private func fetchFriendsData(for courseId: String) {
        guard let currentUserEmail = currentUser?.email?.lowercased() else {
            print("Error: Current user email is nil")
            return
        }

        // Fetch followers
        database.collection("users").document(currentUserEmail).collection("followers").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching followers: \(error.localizedDescription)")
                return
            }

            let followers = Set(snapshot?.documents.map { $0.documentID.lowercased() } ?? [])

            // Fetch following
            self.database.collection("users").document(currentUserEmail).collection("following").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching following: \(error.localizedDescription)")
                    return
                }

                let following = Set(snapshot?.documents.map { $0.documentID.lowercased() } ?? [])

                // Identify mutual followers (real friends)
                let mutualFriendsEmails = followers.intersection(following)

                // Filter friends taking the same course
                self.filterFriendsTakingCourse(mutualFriendsEmails: Array(mutualFriendsEmails), courseId: courseId)
            }
        }
    }

    private func filterFriendsTakingCourse(mutualFriendsEmails: [String], courseId: String) {
        let group = DispatchGroup()
        var filteredFriends = [String]()

        for email in mutualFriendsEmails {
            group.enter()
            database.collection("users").document(email).getDocument { document, error in
                if let document = document, let data = document.data(),
                   let subscribedCourses = data["subscribedCourses"] as? [String],
                   subscribedCourses.contains(courseId) {
                    filteredFriends.append(email)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.fetchFriendsProgress(for: filteredFriends)
        }
    }

    private func fetchFriendsProgress(for friendEmails: [String]) {
        let group = DispatchGroup()
        var loadedProgress: [(user: User, progress: [Int: Bool])] = []

        for email in friendEmails {
            group.enter()
            database.collection("users").document(email).getDocument { [weak self] document, error in
                guard let self = self else { return group.leave() }
                guard let document = document, let userData = document.data(),
                      let user = User(documentData: userData) else {
                    print("Error: Could not load user data for \(email)")
                    return group.leave()
                }

                let progressRef = self.database.collection("userProgress").document("\(email)_\(self.course.id)")
                progressRef.getDocument { document, error in
                    defer { group.leave() }
                    if let document = document, let progressData = document.data(),
                       let completedSections = progressData["completedSections"] as? [Int] {
                        var progress = [Int: Bool]()
                        completedSections.forEach { progress[$0] = true }
                        loadedProgress.append((user: user, progress: progress))
                    } else {
                        loadedProgress.append((user: user, progress: [:]))
                    }
                }
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
