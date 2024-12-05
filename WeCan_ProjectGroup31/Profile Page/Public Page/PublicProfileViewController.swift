//
//  PublicProfileViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PublicProfileViewController: UIViewController {
    
    var profileNotificationView = ProfileNotificationView()
    var publicUserName: String?
    var publicUserImageURL: URL?
    var publicUserId: String? // Public Profile User ID from Firebase
    let currentUser = Auth.auth().currentUser // Current authenticated user
    
    // Follow/Unfollow Button
    private var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var isFollowing = false // Track follow/unfollow state
    let database = Firestore.firestore() // Firestore instance
    
    override func loadView() {
        view = profileNotificationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Public Profile"
        
        if let currentUser = Auth.auth().currentUser {
            print("Current user ID: \(currentUser.uid)")
        } else {
            print("Error: Current user is nil.")
        }
        
        if let publicUserId = publicUserId {
            print("Public user ID: \(publicUserId)")
        } else {
            print("Error: Public user ID is nil.")
        }
        
        setupUIForPublicProfile()
        setupFollowButton()
        checkFollowStatus() // Check if already following
        setupMyCoursesButton()
    }
    
    func setupMyCoursesButton() {
        profileNotificationView.buttonCourses.addTarget(self, action: #selector(onMyCoursesTapped), for: .touchUpInside)
    }

    
    @objc func onMyCoursesTapped() {
            // Navigate to ActiveUsersViewController
            let myCourseVC = MyCoursesViewController()
            navigationController?.pushViewController(myCourseVC, animated: true)
        }
    
    func setupUIForPublicProfile() {
        // Hide unnecessary items
        profileNotificationView.labelEmail.isHidden = true
        profileNotificationView.profileBackground.isHidden = true
        profileNotificationView.buttonNotification.isHidden = true
        profileNotificationView.notificationImage.isHidden = true
        profileNotificationView.buttonLogout.isHidden = true
        profileNotificationView.logoutImage.isHidden = true
        profileNotificationView.buttonFriends.isHidden = true
        profileNotificationView.friendsImage.isHidden = true
        
        // Setting for name and profile photo
        profileNotificationView.labelUsername.text = publicUserName ?? "No Name"
        if let url = publicUserImageURL {
            profileNotificationView.profilePhoto.loadRemoteImage(from: url)
        } else {
            profileNotificationView.profilePhoto.setImage(UIImage(systemName: "person.fill"), for: .normal)
        }
    }
    
    func setupFollowButton() {
        view.addSubview(followButton)
        
        NSLayoutConstraint.activate([
            followButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            followButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            followButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            followButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        followButton.addTarget(self, action: #selector(onFollowButtonTapped), for: .touchUpInside)
    }
    
    func checkFollowStatus() {
        guard let currentUserId = currentUser?.email, let publicUserId = publicUserId else { return }
        
        let followingRef = database.collection("users").document(currentUserId).collection("following").document(publicUserId)
        followingRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let document = document, document.exists {
                self.isFollowing = true
                self.updateFollowButtonState()
            } else {
                self.isFollowing = false
                self.updateFollowButtonState()
            }
        }
    }
    
    func updateFollowButtonState() {
        followButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
        followButton.backgroundColor = isFollowing ? .systemRed : .systemBlue
    }
    
    @objc func onFollowButtonTapped() {
        guard let currentUserEmail = currentUser?.email, let publicUserId = publicUserId else {
            print("Current user or public user ID is nil")
            return
        }
        
        isFollowing.toggle()
        updateFollowButtonState()
        
        // email as userId
        let currentUserFollowingRef = database.collection("users").document(currentUserEmail).collection("following").document(publicUserId)
        let publicUserFollowersRef = database.collection("users").document(publicUserId).collection("followers").document(currentUserEmail)
        
        if isFollowing {
            // Add following and followers relationship
            currentUserFollowingRef.setData(["timestamp": FieldValue.serverTimestamp()]) { [weak self] error in
                if let error = error {
                    print("Error adding following: \(error.localizedDescription)")
                    self?.isFollowing = false // Revert state on error
                    self?.updateFollowButtonState()
                } else {
                    print("Successfully added following")
                }
            }
            
            publicUserFollowersRef.setData(["timestamp": FieldValue.serverTimestamp()]) { error in
                if let error = error {
                    print("Error adding followers: \(error.localizedDescription)")
                } else {
                    print("Successfully added followers")
                }
            }
        } else {
            // Remove following and followers relationship
            currentUserFollowingRef.delete { [weak self] error in
                if let error = error {
                    print("Error removing following: \(error.localizedDescription)")
                    self?.isFollowing = true // Revert state on error
                    self?.updateFollowButtonState()
                } else {
                    print("Successfully removed following")
                }
            }
            
            publicUserFollowersRef.delete { error in
                if let error = error {
                    print("Error removing followers: \(error.localizedDescription)")
                } else {
                    print("Successfully removed followers")
                }
            }
        }
    }
}


