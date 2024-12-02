//
//  FriendsViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var followers: [[String: Any]] = []
    var following: [[String: Any]] = []
    let database = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    private var followersLabel: UILabel!
    private var followersTableView: UITableView!
    private var followingLabel: UILabel!
    private var followingTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Friends"
        view.backgroundColor = .white
        setupUI()
        fetchFriendsData()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        // Followers Section
        followersLabel = createLabel(withText: "Followers: 0")
        followersTableView = createTableView()
        
        // Following Section
        followingLabel = createLabel(withText: "Following: 0")
        followingTableView = createTableView()
        
        // StackViews for Followers and Following
        let followersStackView = createStackView(arrangedSubviews: [followersLabel, followersTableView])
        let followingStackView = createStackView(arrangedSubviews: [followingLabel, followingTableView])
        
        // Horizontal StackView for columns
        let horizontalStackView = UIStackView(arrangedSubviews: [followersStackView, followingStackView])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .fill
        horizontalStackView.spacing = 10
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalStackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            horizontalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // Helper to create UILabel
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // Helper to create UITableView
    private func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        return tableView
    }
    
    // Helper to create UIStackView
    private func createStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    // MARK: - Fetch Friends Data
    func fetchFriendsData() {
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
            self.fetchUserDetails(for: followerEmails, completion: { users in
                self.followers = users
                DispatchQueue.main.async {
                    self.followersLabel.text = "Followers: \(self.followers.count)"
                    self.followersTableView.reloadData()
                }
            })
        }
        
        // Fetch following
        database.collection("users").document(currentUserEmail).collection("following").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching following: \(error.localizedDescription)")
                return
            }
            
            let followingEmails = snapshot?.documents.map { $0.documentID } ?? []
            self.fetchUserDetails(for: followingEmails, completion: { users in
                self.following = users
                DispatchQueue.main.async {
                    self.followingLabel.text = "Following: \(self.following.count)"
                    self.followingTableView.reloadData()
                }
            })
        }
    }
    
    // Fetch user details from the 'users' collection
    func fetchUserDetails(for emails: [String], completion: @escaping ([[String: Any]]) -> Void) {
        var userDetails: [[String: Any]] = []
        let group = DispatchGroup()
        
        for email in emails {
            group.enter()
            database.collection("users").document(email).getDocument { (snapshot, error) in
                if let error = error {
                    print("Error fetching user details for \(email): \(error.localizedDescription)")
                } else if let data = snapshot?.data() {
                    userDetails.append(data)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(userDetails)
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == followersTableView ? followers.count : following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let data = tableView == followersTableView ? followers[indexPath.row] : following[indexPath.row]
        cell.configure(with: data)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedFriendData = tableView == followersTableView ? followers[indexPath.row] : following[indexPath.row]
        
        // Navigate to chat screen
        let chatVC = ChatViewController()
        chatVC.friendData = selectedFriendData
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

// MARK: - FriendCell
class FriendCell: UITableViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: [String: Any]) {
        nameLabel.text = data["username"] as? String ?? "Unknown User"
        if let photoURLString = data["photoURL"] as? String, let url = URL(string: photoURLString) {
            profileImageView.loadRemoteImage(from: url)
        } else {
            profileImageView.image = UIImage(systemName: "person.fill")
        }
    }
}


