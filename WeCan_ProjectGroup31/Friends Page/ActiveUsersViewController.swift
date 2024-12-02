//
//  ActiveUsersViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ActiveUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var activeUsers: [[String: Any]] = [] // Array to store Firebase user data
    let database = Firestore.firestore()
    let currentUser = Auth.auth().currentUser // Reference to current user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Active Users"
        view.backgroundColor = .white
        setupTableView()
        fetchActiveUsers()
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchActiveUsers() {
        database.collection("users").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self.activeUsers = documents.compactMap { document in
                let data = document.data()
                // Exclude current user
                if let email = data["email"] as? String, email != self.currentUser?.email {
                    return data
                }
                return nil
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let userData = activeUsers[indexPath.row]
        
        // Display username
        if let username = userData["username"] as? String {
            cell.textLabel?.text = username
        } else {
            cell.textLabel?.text = "Unknown User"
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedUserData = activeUsers[indexPath.row]
        
        // Navigate to the public profile page
        let publicProfileVC = PublicProfileViewController()
        publicProfileVC.publicUserName = selectedUserData["username"] as? String
        if let photoURLString = selectedUserData["photoURL"] as? String {
            publicProfileVC.publicUserImageURL = URL(string: photoURLString)
        }
        publicProfileVC.publicUserId = selectedUserData["email"] as? String // use email as publicUserId
        navigationController?.pushViewController(publicProfileVC, animated: true)
    }
}

