//
//  ForgotPasswordViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 11/16/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ForgotPasswordViewController: UIViewController {
    let forgotPasswordEmail = ForgotPasswordEmailView()
    //let forgotPasswordNewPasswordController = ForgotPasswordNewPasswordViewController()
    let database = Firestore.firestore()
    
    override func loadView() {
        view = forgotPasswordEmail
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        forgotPasswordEmail.sendButton.addTarget(self, action: #selector(onSendButtonTapped), for: .touchUpInside)
        
        forgotPasswordEmail.registerButton.addTarget(self, action: #selector(onRegisterButtonTapped), for: .touchUpInside)
    }

    @objc func onSendButtonTapped(){
        if let email = forgotPasswordEmail.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty{
            let userRef = self.database.collection("users").document(email)
            userRef.getDocument(completion: {(document, error) in
                if let doc = document{
                    if doc.exists{
                        Auth.auth().sendPasswordReset(withEmail: email, actionCodeSettings: nil) { error in
                            if let error = error {
                                self.showAlert(error.localizedDescription)
                            } else {
                                
                                let sendResetPasswordLinkAlert = UIAlertController(
                                 title: "✅  Reset Link Sent!",
                                 message: """
                                    A password reset link has been sent to your email.

                                    👉 Check your inbox (and spam folder).

                                    👉 Follow the link to set a new password.

                                    Once complete, return to the Sign In page to log in.
                                    """,
                                 preferredStyle: .actionSheet
                                )
                                sendResetPasswordLinkAlert.addAction(UIAlertAction(title: "Go to Sign In", style: .default, handler: {(_) in
                                    self.clearEmailField()
                                    self.navigationController?.popViewController(animated: false)
                                    NotificationCenter.default.post(name: .userPasswordReset, object: "")
                                }))
                                self.present(sendResetPasswordLinkAlert, animated: true)
                            }
                        }
                    } else {
                        self.clearEmailField()
                        self.showAlert("The email hasn't been registered! Please input a valid registered email.")
                    }
                }
            })
        }else{
            self.showAlert("Email cannot be empty!")
        }
    }
    
    @objc func onRegisterButtonTapped(){
        clearEmailField()
        navigationController?.popViewController(animated: false)
        NotificationCenter.default.post(name: .userJumpToSignUp, object: "")
    }
    
    func clearEmailField(){
        forgotPasswordEmail.emailTextField.text = ""
    }
}
