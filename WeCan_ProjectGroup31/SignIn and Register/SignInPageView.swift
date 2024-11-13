//
//  SignInPageView.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 10/25/24.
//

import UIKit

class SignInPageView: UIView {

    var contentWrapper: UIScrollView!
    var profilePic: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel1: UILabel!
    var descriptionLabel2: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var forgotPasswordButton: UIButton!
    var signInButton: UIButton!
    var noAccountDesLabel: UILabel!
    var registerButton: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupProfilePic()
        setupTitleLabel()
        setupDescriptionLabel1()
        setupDescriptionLabel2()
        setupEmailTextField()
        setupPasswordTextField()
        setupforgotPasswordButton()
        setupsignInButton()
        setupNoAccountDesLabel()
        setupRegisterButton()
        
        initConstraints()
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupProfilePic(){
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        profilePic.contentMode = .scaleToFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePic)
    }
    
    func setupTitleLabel(){
        titleLabel = UILabel()
        titleLabel.text = "Let's sign you in"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(titleLabel)
    }
    
    func setupDescriptionLabel1(){
        descriptionLabel1 = UILabel()
        descriptionLabel1.text = "Welcome Back,"
        descriptionLabel1.font = .boldSystemFont(ofSize: 16)
        descriptionLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(descriptionLabel1)
    }
    
    func setupDescriptionLabel2(){
        descriptionLabel2 = UILabel()
        descriptionLabel2.text = "you have been missed"
        descriptionLabel2.font = .boldSystemFont(ofSize: 16)
        descriptionLabel2.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(descriptionLabel2)
    }
    
    func setupEmailTextField(){
        emailTextField = UITextField()
        emailTextField.placeholder = "Email"
        emailTextField.text = "bob@email.com"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(emailTextField)
    }
    
    func setupPasswordTextField(){
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.text = "abc123"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(passwordTextField)
    }
    
    func setupforgotPasswordButton(){
        forgotPasswordButton = UIButton(type: .system)
        forgotPasswordButton.setTitle("Forgot Password ?", for: .normal)
        forgotPasswordButton.tintColor = .systemBlue
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(forgotPasswordButton)
    }
    
    func setupsignInButton(){
        signInButton = UIButton(configuration: UIButton.Configuration.borderedProminent())
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(signInButton)
    }
    
    func setupNoAccountDesLabel(){
        noAccountDesLabel = UILabel()
        noAccountDesLabel.text = "Don't have an account?"
        noAccountDesLabel.font = .boldSystemFont(ofSize: 14)
        noAccountDesLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(noAccountDesLabel)
    }
    
    func setupRegisterButton(){
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register Now", for: .normal)
        registerButton.tintColor = .systemBlue
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(registerButton)
    }
    
    func initConstraints(){
        let buttonHeight: CGFloat = 50
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            
            descriptionLabel1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel1.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            
            descriptionLabel2.topAnchor.constraint(equalTo: descriptionLabel1.bottomAnchor, constant: 8),
            descriptionLabel2.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            
            profilePic.topAnchor.constraint(equalTo: descriptionLabel2.bottomAnchor, constant: 70),
            profilePic.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            profilePic.widthAnchor.constraint(equalToConstant: 90),
            profilePic.heightAnchor.constraint(equalToConstant: 90),
            
            emailTextField.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            emailTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
//            emailTextField.widthAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            passwordTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
//            passwordTextField.widthAnchor.constraint(equalToConstant: 40),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            signInButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 80),
            signInButton.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor, multiplier: 0.9),
            signInButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            signInButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            registerButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            registerButton.widthAnchor.constraint(equalToConstant: 100),
            
//            noAccountDesLabel.topAnchor.constraint(equalTo: registerButton.topAnchor),
            noAccountDesLabel.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor),
            noAccountDesLabel.trailingAnchor.constraint(equalTo: registerButton.leadingAnchor, constant: -10),
            noAccountDesLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            
            registerButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
