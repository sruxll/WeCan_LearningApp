//
//  FriendsProgressViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by FengAdela on 12/2/24.
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
        
        fetchFriendsData() // Fetch current user's friends
    }
    
    private func setupNavigationBar() {
        let homeButton = UIBarButtonItem(
            image: UIImage(systemName: "house.fill"), // "User/People" symbol
            style: .plain,
            target: self,
            action: #selector(onTapHomeButton)
        )
        navigationItem.rightBarButtonItem = homeButton
    }

    @objc private func onTapHomeButton() {
        // Navigate to ProfileNotificationViewController
        let homePageVC = HomePageViewController()
        navigationController?.pushViewController(homePageVC, animated: true)
    }
    
    private func fetchFriendsData() {
            guard let currentUserEmail = currentUser?.email else {
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

                let followerEmails = snapshot?.documents.map { $0.documentID } ?? []

                // Fetch following
                self.database.collection("users").document(currentUserEmail).collection("following").getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error fetching following: \(error.localizedDescription)")
                        return
                    }

                    let followingEmails = snapshot?.documents.map { $0.documentID } ?? []
                    let friendEmails = Set(followerEmails).union(followingEmails)
                    self.fetchFriendsProgress(for: Array(friendEmails))
                }
            }
        }

    private func fetchFriendsProgress(for friendEmails: [String]) {
        var friends: [User] = []
        let group = DispatchGroup()

        for email in friendEmails {
            group.enter()
            database.collection("users").document(email).getDocument { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching user document: \(error)")
                } else if let data = snapshot?.data(), let user = User(documentData: data) {
                    friends.append(user)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.loadProgress(for: friends)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let selectedFriend = friendsProgress[indexPath.row].user
            
            // Navigate to the public profile page
            let publicProfileVC = PublicProfileViewController()
            publicProfileVC.publicUserName = selectedFriend.name
            publicProfileVC.publicUserImageURL = selectedFriend.photoURL.flatMap { URL(string: $0) }
            publicProfileVC.publicUserId = selectedFriend.email
            navigationController?.pushViewController(publicProfileVC, animated: true)
    }
}

