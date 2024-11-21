//
//  ForgotPasswordEmailView.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 11/16/24.
//

import UIKit

class ForgotPasswordEmailView: UIView {

    var contentWrapper: UIScrollView!
    var forgotPasswordPic: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel1: UILabel!
    //var descriptionLabel2: UILabel!
    var emailTextField: UITextField!
    var sendButton: UIButton!
    var registerButton: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupforgotPasswordPic()
        setupTitleLabel()
        setupDescriptionLabel1()
        //setupDescriptionLabel2()
        setupEmailTextField()
        setupsendButton()
        setupregisterButton()
        
        initConstraints()
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupforgotPasswordPic(){
        forgotPasswordPic = UIImageView()
        forgotPasswordPic.image = UIImage(systemName: "person.badge.key")?.withRenderingMode(.alwaysOriginal)
        forgotPasswordPic.contentMode = .scaleToFill
        forgotPasswordPic.clipsToBounds = true
        forgotPasswordPic.layer.masksToBounds = true
        forgotPasswordPic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(forgotPasswordPic)
    }
    
    func setupTitleLabel(){
        titleLabel = UILabel()
        titleLabel.text = "Forgot Password?"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(titleLabel)
    }
    
    func setupDescriptionLabel1(){
        descriptionLabel1 = UILabel()
        descriptionLabel1.text = "Enter your email to reset password"
        descriptionLabel1.font = .boldSystemFont(ofSize: 16)
        descriptionLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(descriptionLabel1)
    }
    
//    func setupDescriptionLabel2(){
//        descriptionLabel2 = UILabel()
//        descriptionLabel2.text = "you have been missed"
//        descriptionLabel2.font = .boldSystemFont(ofSize: 16)
//        descriptionLabel2.translatesAutoresizingMaskIntoConstraints = false
//        contentWrapper.addSubview(descriptionLabel2)
//    }
    
    func setupEmailTextField(){
        emailTextField = UITextField()
        emailTextField.placeholder = "Enter Email"
        emailTextField.autocapitalizationType = .none
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(emailTextField)
    }
    
    func setupsendButton(){
        sendButton = UIButton(configuration: UIButton.Configuration.borderedProminent())
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(sendButton)
    }
    
    func setupregisterButton(){
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
            
            forgotPasswordPic.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 70),
            forgotPasswordPic.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            forgotPasswordPic.widthAnchor.constraint(equalToConstant: 90),
            forgotPasswordPic.heightAnchor.constraint(equalToConstant: 90),
            
            descriptionLabel1.topAnchor.constraint(equalTo: forgotPasswordPic.bottomAnchor, constant: 70),
            descriptionLabel1.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            
            emailTextField.topAnchor.constraint(equalTo: descriptionLabel1.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            emailTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            registerButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            registerButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            sendButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 70),
            sendButton.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor, multiplier: 0.9),
            sendButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            sendButton.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            sendButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
