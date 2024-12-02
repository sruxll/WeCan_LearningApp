//
//  ProfileNotificationViewController.swift
//  WeCan_ProjectGroup31
//

import UIKit
import FirebaseAuth

class ProfileNotificationViewController: UIViewController {
    
    var profileNotification = ProfileNotificationView()
    var currentUser: FirebaseAuth.User?
    
    override func loadView() {
        view = profileNotification
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Profile"
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "profile_background")!)
//        self.view.layer.contents = UIImage(named: "profile_background")!.cgImage
        
        setupEditButton()

        profileNotification.buttonLogout.addTarget(self, action: #selector(onLogoutButtonTapped), for: .touchUpInside)
        
        profileNotification.buttonCourses.addTarget(self, action: #selector(onMyCoursesTapped), for: .touchUpInside)
        
        profileNotification.buttonFriends.addTarget(self, action: #selector(onMyFriendsTapped), for: .touchUpInside)
    }
    
    @objc func onMyCoursesTapped() {
            // Navigate to ActiveUsersViewController
            let activeUsersVC = ActiveUsersViewController()
            navigationController?.pushViewController(activeUsersVC, animated: true)
        }
    
    @objc func onLogoutButtonTapped(){
        NotificationCenter.default.post(name: .userLogout, object: "")
    }
    
    func displayUserProfile(){
        profileNotification.labelUsername.text = currentUser?.displayName
        profileNotification.labelEmail.text = currentUser?.email
        if let url = currentUser?.photoURL{
            profileNotification.profilePhoto.loadRemoteImage(from: url)
        }else{
            profileNotification.profilePhoto.setImage(UIImage(systemName: "person.fill"), for: .normal)
        }
    }
    
    func setupEditButton() {
        // Add a delete button to the navigation bar
        let editButton = UIBarButtonItem(title: "Edit Profile", style: .plain, target: self, action: #selector(onEditTapped))
        editButton.tintColor = .red // Set the color to red to indicate a destructive action
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func onEditTapped() {
        print("to Edit screen")
        // Create an instance of EditProfileViewController
        let editProfileVC = EditProfileViewController()
        editProfileVC.currentUser = currentUser

        // Closure to handle profile update
        editProfileVC.onProfileUpdated = { [weak self] updatedUser in
           self?.currentUser = updatedUser
           self?.displayUserProfile() // Update UI with the new data
        }

        // Push to the Edit Profile screen
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc func onMyFriendsTapped() {
        print("to Friends screen")
        let friendsVC = FriendsViewController()
        navigationController?.pushViewController(friendsVC, animated: true)
    }

}
