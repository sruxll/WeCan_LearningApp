//
//  InviteFriendsViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class InviteFriendsViewController: UIViewController {
    private let inviteFriendsView = InviteFriendsView()
    private var friends = [User]() // Mutual friends (users who follow each other)
    private var filteredFriends = [User]() // Friends not subscribed to the course
    private var course: Course
    private let database = Firestore.firestore()

    private let noFriendsLabel: UILabel = {
        let label = UILabel()
        label.text = "It seems all your friends are taking this course 😉"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.numberOfLines = 0 // Allow multi-line text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true // Ensure padding doesn't overflow
        label.isHidden = true // Initially hidden
        return label
    }()

    init(course: Course) {
        self.course = course
        super.init(nibName: nil, bundle: nil)
        fetchFriends()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = inviteFriendsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose a Friend"

        // Table view setup
        inviteFriendsView.tableView.delegate = self
        inviteFriendsView.tableView.dataSource = self
        inviteFriendsView.tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendCell")

        // Add the no friends label to the view
        view.addSubview(noFriendsLabel)
        NSLayoutConstraint.activate([
            noFriendsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFriendsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noFriendsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24), // Add left padding
            noFriendsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24) // Add right padding
        ])
    }

    private func fetchFriends() {
        guard let currentUserEmail = Auth.auth().currentUser?.email?.lowercased() else {
            print("Error: Current user email is nil")
            return
        }

        let userRef = database.collection("users").document(currentUserEmail)

        // Fetch followers
        userRef.collection("followers").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching followers: \(error.localizedDescription)")
                return
            }

            let followers = Set(snapshot?.documents.map { $0.documentID.lowercased() } ?? [])

            // Fetch following
            userRef.collection("following").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching following: \(error.localizedDescription)")
                    return
                }

                let following = Set(snapshot?.documents.map { $0.documentID.lowercased() } ?? [])

                // Intersection of followers and following
                let mutualFriendsEmails = followers.intersection(following)

                // Filter friends not subscribed to the course
                self.filterFriendsNotSubscribed(to: mutualFriendsEmails)
            }
        }
    }

    private func filterFriendsNotSubscribed(to mutualFriendsEmails: Set<String>) {
        guard !mutualFriendsEmails.isEmpty else {
            print("No mutual friends found.")
            filteredFriends = []
            updateViewBasedOnFilteredFriends()
            return
        }

        let group = DispatchGroup()
        var nonSubscribedFriends = [User]()

        for email in mutualFriendsEmails {
            group.enter()
            database.collection("users").document(email).getDocument { [weak self] document, error in
                defer { group.leave() }
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching user document for \(email): \(error.localizedDescription)")
                    return
                }

                if let document = document, let data = document.data(),
                   let user = User(documentData: data) {
                    // Ensure subscribedCourses does not contain the current course ID
                    if !user.subscribedCourses.contains(self.course.id) {
                        nonSubscribedFriends.append(user)
                    }
                }
            }
        }

        group.notify(queue: .main) {
            self.filteredFriends = nonSubscribedFriends
            self.updateViewBasedOnFilteredFriends()
        }
    }

    private func updateViewBasedOnFilteredFriends() {
        if filteredFriends.isEmpty {
            // Show the no friends label and hide the table view
            noFriendsLabel.isHidden = false
            inviteFriendsView.tableView.isHidden = true
        } else {
            // Hide the no friends label and show the table view
            noFriendsLabel.isHidden = true
            inviteFriendsView.tableView.isHidden = false
        }
        inviteFriendsView.tableView.reloadData()
    }
}

// MARK: - Table View Delegate and Data Source
extension InviteFriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        let friend = filteredFriends[indexPath.row]
        cell.configure(with: friend)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend = filteredFriends[indexPath.row]

        // Navigate to chat screen with a pre-generated message
        let chatVC = ChatViewController()
        chatVC.chatPartnerEmail = selectedFriend.email
        chatVC.currentUser = Auth.auth().currentUser
        chatVC.course = course // Pass the course object here

        // Construct the pre-generated message with a clickable link to the course page
        let courseID = course.id
        let courseName = course.name
        let message = "I found an interesting course! Let's learn new skills together!"
        
        let attributedText = NSMutableAttributedString(string: "\(message)\n\n")
        attributedText.append(NSAttributedString(string: courseName, attributes: [
            .link: "course://\(courseID)", // Custom in-app URL scheme
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.systemBlue
        ]))

        chatVC.chatView.textViewMessage.attributedText = attributedText // Pre-fill the attributed text
        chatVC.chatView.textViewMessage.delegate = chatVC // Ensure the delegate is set for link handling
        
        navigationController?.pushViewController(chatVC, animated: true)
    }

}
