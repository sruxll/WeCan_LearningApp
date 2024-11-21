//
//  LandingPageViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 10/15/24.
//

import UIKit
import FirebaseAuth

class LandingPageViewController: UIViewController {

    var landingPage = LandingPageView()
    let signInPageController = SignInPageViewController()
    let registerPageController = RegisterPageViewController()
    let homePageController = HomePageViewController()
    let forgotPasswordController = ForgotPasswordViewController()
    
    override func loadView() {
        view = landingPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homePageController.landingPageController = self

        landingPage.signInButoon.addTarget(self, action: #selector(onButtonSignInTapped), for: .touchUpInside)
        landingPage.registerButoon.addTarget(self, action: #selector(onButtonRegisterTapped), for: .touchUpInside)
        
        // notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUserSigin(notification:)), name: .userSignIn, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUserSigin(notification:)), name: .userSignUp, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUserJumpToSigUp(notification:)), name: .userJumpToSignUp, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUserJumpToSigIn(notification:)), name: .userJumpToSignIn, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUserForgotPassword(notification:)), name: .userForgotPassword, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUserJumpToSigIn(notification:)), name: .userPasswordReset, object: nil)
        
    }
    
    @objc func onButtonSignInTapped(){
        navigationController?.pushViewController(signInPageController, animated: true)
    }
    
    @objc func onButtonRegisterTapped(){
        navigationController?.pushViewController(registerPageController, animated: true)
    }

    @objc func notificationUserSigin(notification: Notification){
        let user = notification.object as? FirebaseAuth.User
        homePageController.currentUser = user
        navigationController?.setViewControllers([self.homePageController], animated: false)
    }
    
    @objc func notificationUserJumpToSigUp(notification: Notification){
        navigationController?.pushViewController(registerPageController, animated: false)
    }
    
    @objc func notificationUserJumpToSigIn(notification: Notification){
        navigationController?.pushViewController(signInPageController, animated: false)
    }
    
    @objc func notificationUserForgotPassword(notification: Notification){
        navigationController?.pushViewController(forgotPasswordController, animated: false)
    }
}

