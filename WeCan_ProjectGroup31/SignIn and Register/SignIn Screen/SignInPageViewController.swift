//
//  SignInPageViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 10/25/24.
//

import UIKit
import FirebaseAuth

class SignInPageViewController: UIViewController {

    let signInPage = SignInPageView()
    let childProgressView = ProgressSpinnerViewController()
//    let homePageController = HomePageViewController()
//    let registerPageController = RegisterPageViewController()
    
    override func loadView() {
        view = signInPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInPage.signInButton.addTarget(self, action: #selector(onSignInButtonTapped), for: .touchUpInside)
        signInPage.registerButton.addTarget(self, action: #selector(onRegisterButtonTapped), for: .touchUpInside)
        signInPage.forgotPasswordButton.addTarget(self, action: #selector(onForgotPasswordButtonTapped), for: .touchUpInside)
    }
    
    @objc func onSignInButtonTapped(){
        if let email = signInPage.emailTextField.text,
           let password = signInPage.passwordTextField.text{
            // sign in logic for firebase
            self.signInToFirebase(email: email, password: password)
        }
    }
    
    func signInToFirebase(email: String, password: String){
        // display progress indicator
        showActivityIndicator()
        // authenticating the user
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[self](result, error) in
            if error == nil{
                // user authenticated
                // hide the progress indicator
                self.hideActivityIndicator()
                clearEmailPasswordField()
                NotificationCenter.default.post(name: .userSignIn, object: result?.user)
            }else{
                //alert that no user found or password wrong
                self.showWrongSignInAlert("No user found or password wrong!")
                self.hideActivityIndicator()
            }
        })
    }
    
    @objc func onRegisterButtonTapped(){
        clearEmailPasswordField()
        navigationController?.popViewController(animated: false)
        NotificationCenter.default.post(name: .userJumpToSignUp, object: "")
    }
    
    func clearEmailPasswordField(){
        signInPage.emailTextField.text = ""
        signInPage.passwordTextField.text = ""
    }
    
    @objc func onForgotPasswordButtonTapped(){
        clearEmailPasswordField()
        navigationController?.popViewController(animated: false)
        NotificationCenter.default.post(name: .userForgotPassword, object: "")
    }
    
    func showWrongSignInAlert(_ message: String){
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert .addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

extension SignInPageViewController: ProgressSpinnerDelegate{
    func showActivityIndicator() {
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator() {
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
    
}
