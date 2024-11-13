//
//  LandingPageView.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 10/25/24.
//

import UIKit

class LandingPageView: UIView {

    var contentWrapper: UIScrollView!
    var appWelcomePic: UIImageView!
    var appTitleLabel: UILabel!
    var appDescriptionLabel1: UILabel!
    var appDescriptionLabel2: UILabel!
    var signInButoon: UIButton!
    var registerButoon: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupAppWelcomePic()
        setupAppTitleLabel()
        setupAppDescriptionLabel1()
        setupAppDescriptionLabel2()
        setupSignInButoon()
        setupRegisterButoon()
        
        initConstraints()
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupAppWelcomePic(){
        appWelcomePic = UIImageView()
        appWelcomePic.image = UIImage(named: "WeCan_logo")
        appWelcomePic.contentMode = .scaleAspectFit
        appWelcomePic.clipsToBounds = true
        appWelcomePic.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(appWelcomePic)
    }
    
    func setupAppTitleLabel(){
        appTitleLabel = UILabel()
        appTitleLabel.text = "Welcome!!"
        appTitleLabel.font = .boldSystemFont(ofSize: 24)
        appTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(appTitleLabel)
    }
    
    func setupAppDescriptionLabel1(){
        appDescriptionLabel1 = UILabel()
        appDescriptionLabel1.text = "Online learning platform"
        appDescriptionLabel1.font = .boldSystemFont(ofSize: 14)
        appDescriptionLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(appDescriptionLabel1)
    }
    
    func setupAppDescriptionLabel2(){
        appDescriptionLabel2 = UILabel()
        appDescriptionLabel2.text = "Helping people acquire new skils"
        appDescriptionLabel2.font = .boldSystemFont(ofSize: 14)
        appDescriptionLabel2.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(appDescriptionLabel2)
    }
    
    func setupSignInButoon(){
        signInButoon = UIButton(configuration: UIButton.Configuration.borderedProminent())
        signInButoon.setTitle("Sign In", for: .normal)
        signInButoon.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(signInButoon)
    }
    
    func setupRegisterButoon(){
        registerButoon = UIButton(configuration: UIButton.Configuration.borderedProminent())
        registerButoon.setTitle("Register", for: .normal)
        registerButoon.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(registerButoon)
    }
    
//    func setupStackButtonView(){
//        let buttonStackView = UIStackView(arrangedSubviews: [signInButoon, registerButoon])
//        buttonStackView.axis = .horizontal
//        buttonStackView.spacing = 20
//        buttonStackView.distribution = .fillEqually
//        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
//        contentWrapper.addSubview(buttonStackView)
//    }
    
    func initConstraints(){
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 50
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            appWelcomePic.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 0),
            appWelcomePic.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            appWelcomePic.heightAnchor.constraint(equalToConstant: 400),
            appWelcomePic.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor),
            
            appTitleLabel.topAnchor.constraint(equalTo: appWelcomePic.bottomAnchor, constant: 40),
            appTitleLabel.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            appDescriptionLabel1.topAnchor.constraint(equalTo: appTitleLabel.bottomAnchor, constant: 25),
            appDescriptionLabel1.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            appDescriptionLabel2.topAnchor.constraint(equalTo: appDescriptionLabel1.bottomAnchor, constant: 10),
            appDescriptionLabel2.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            signInButoon.topAnchor.constraint(equalTo: appDescriptionLabel2.bottomAnchor, constant: 60),
            signInButoon.widthAnchor.constraint(equalToConstant: buttonWidth),
            signInButoon.heightAnchor.constraint(equalToConstant: buttonHeight),
            signInButoon.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor, constant: -60),
            
            registerButoon.topAnchor.constraint(equalTo: appDescriptionLabel2.bottomAnchor, constant: 60),
            registerButoon.widthAnchor.constraint(equalToConstant: buttonWidth),
            registerButoon.heightAnchor.constraint(equalToConstant: buttonHeight),
            registerButoon.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor, constant: 60),
            
            registerButoon.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
