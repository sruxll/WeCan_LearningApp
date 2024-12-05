//
//  CourseUserListViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by FengAdela on 12/2/24.
//

import UIKit
import FirebaseFirestore

class CourseUserListViewController: UIViewController {
    private let courseUserListView = CourseUserListView()
    private var subscribedUsers = [User]()
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

        courseUserListView.tableView.delegate = self
        courseUserListView.tableView.dataSource = self
        courseUserListView.tableView.register(CourseUserListTableViewCell.self, forCellReuseIdentifier: "UserCell")
        
        // Add home button to navigation bar
        setupNavigationBar()

        fetchSubscribedUsers()
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

    private func fetchSubscribedUsers() {
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

        for email in userEmails {
            group.enter()
            database.collection("users").document(email).getDocument { document, error in
                defer { group.leave() }

                if let error = error {
                    print("Error fetching user document for \(email): \(error)")
                    return
                }

                if let document = document, let userData = document.data(),
                   let user = User(documentData: userData) {
                    loadedUsers.append(user)
                } else {
                    print("No document found for user email: \(email)")
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
        print("Number of rows: \(subscribedUsers.count)")
        return subscribedUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? CourseUserListTableViewCell else {
            return UITableViewCell()
        }
        let user = subscribedUsers[indexPath.row]
        print("Configuring cell for user: \(user.name)")
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUser = subscribedUsers[indexPath.row]
        
        // Navigate to the public profile page
        let publicProfileVC = PublicProfileViewController()
        publicProfileVC.publicUserName = selectedUser.name
        publicProfileVC.publicUserImageURL = selectedUser.photoURL.flatMap { URL(string: $0) }
        publicProfileVC.publicUserId = selectedUser.email
        navigationController?.pushViewController(publicProfileVC, animated: true)
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            tableView.deselectRow(at: indexPath, animated: true)
//            let selectedUser = subscribedUsers[indexPath.row]
//            
//            // Navigate to the public profile page
//            let publicProfileVC = PublicProfileViewController()
//        publicProfileVC.publicUserName = selectedUser.name
//            if let photoURLString = selectedUserData["photoURL"] as? String {
//                publicProfileVC.publicUserImageURL = URL(string: photoURLString)
//            }
//            publicProfileVC.publicUserId = selectedUserData["email"] as? String // use email as publicUserId
//            navigationController?.pushViewController(publicProfileVC, animated: true)
//        }
}
