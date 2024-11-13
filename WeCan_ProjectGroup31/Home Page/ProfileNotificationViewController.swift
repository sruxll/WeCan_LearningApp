//
//  ProfileNotificationViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 10/26/24.
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
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "profile_background")!)
//        self.view.layer.contents = UIImage(named: "profile_background")!.cgImage

        // Do any additional setup after loading the view.
        profileNotification.buttonLogout.addTarget(self, action: #selector(onLogoutButtonTapped), for: .touchUpInside)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        profileNotification.profileBackground.frame = self.view.bounds
//    }
    @objc func onLogoutButtonTapped(){
        NotificationCenter.default.post(name: .userLogout, object: "")
    }
    
    func displayUserProfile(){
        profileNotification.labelUsername.text = currentUser?.displayName
        if let url = currentUser?.photoURL{
            profileNotification.profilePhoto.loadRemoteImage(from: url)
        }
    }

}
