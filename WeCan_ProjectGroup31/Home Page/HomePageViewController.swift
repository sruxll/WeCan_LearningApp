//
//  HomePageViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 10/26/24.
//

import UIKit
import FirebaseAuth

class HomePageViewController: UIViewController {

    let homePage = HomePageView()
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?
    
    let profileNotificationController = ProfileNotificationViewController()
    var landingPageController: LandingPageViewController?
    
    override func loadView() {
        view = homePage
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Home"
        // modify title font
        let titleAttributes: [NSAttributedString.Key: Any] = [.font:UIFont.boldSystemFont(ofSize: 22)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(onProfileBarButtonTapped))
        
        //display profile
        profileNotificationController.currentUser = currentUser
        profileNotificationController.displayUserProfile()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUserLogout(notofication:)), name: .userLogout, object: nil)
        
    }
    
//    func setupRightBarButton(){
//        let barIcon = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(onProfileBarButtonTapped))
//    }
    
    @objc func onProfileBarButtonTapped(){
        navigationController?.pushViewController(profileNotificationController, animated: true)
    }
    
    @objc func notificationUserLogout(notofication: Notification){
        navigationController?.setViewControllers([self.landingPageController!], animated: true)
    }
}
