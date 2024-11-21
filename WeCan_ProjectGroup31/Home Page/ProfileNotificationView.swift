//
//  ProfileNotificationView.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 10/26/24.
//

import UIKit

class ProfileNotificationView: UIView {

    var contentWrapper: UIScrollView!
    var profilePhoto: UIButton!
    var labelUsername: UILabel!
    var profileBackground: UIImageView!
    var buttonProfile: UIButton!
    var profileImage: UIImageView!
    var buttonNotification: UIButton!
    var notificationImage: UIImageView!
    var buttonLogout: UIButton!
    var logoutImage: UIImageView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupProfilePhoto()
        setupLabelUsername()
        setupProfileBackground()
        setupButtonProfile()
        setupProfileImage()
        setupButtonNotification()
        setupNotificationImage()
        setupButtonLogout()
        setupLogoutImage()
        
        initConstraints()
    }

    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupProfilePhoto(){
        profilePhoto = UIButton(type: .system)
        profilePhoto.setTitle("", for: .normal)
        profilePhoto.setImage(UIImage(systemName: "person.fill"), for: .normal)
        profilePhoto.contentHorizontalAlignment = .fill
        profilePhoto.contentVerticalAlignment = .fill
        profilePhoto.clipsToBounds = true
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = 110.0
        profilePhoto.imageView?.contentMode = .scaleAspectFill
        profilePhoto.showsMenuAsPrimaryAction = true
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(profilePhoto)
    }
    
    func setupLabelUsername(){
        labelUsername = UILabel()
        labelUsername.text = ""
        labelUsername.font = .boldSystemFont(ofSize: 28)
        labelUsername.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelUsername)
    }
    
    func setupProfileBackground(){
        profileBackground = UIImageView()
        profileBackground.image = UIImage(named: "profile_separator")
        profileBackground.contentMode = .scaleToFill
        profileBackground.clipsToBounds = true
        profileBackground.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(profileBackground)
        contentWrapper.sendSubviewToBack(profileBackground)
    }
    
    func setupButtonProfile(){
        buttonProfile = UIButton(type: .system)
        buttonProfile.setTitle("My Profile", for: .normal)
        buttonProfile.tintColor = .black
        buttonProfile.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonProfile)
    }
    
    func setupProfileImage(){
        profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "person")?.withRenderingMode(.alwaysOriginal)
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(profileImage)
    }
    
    func setupButtonNotification(){
        buttonNotification = UIButton(type: .system)
        buttonNotification.setTitle("Notification", for: .normal)
        buttonNotification.tintColor = .black
        buttonNotification.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonNotification)
    }
    
    func setupNotificationImage(){
        notificationImage = UIImageView()
        notificationImage.image = UIImage(systemName: "message")?.withRenderingMode(.alwaysOriginal)
        notificationImage.contentMode = .scaleAspectFill
        notificationImage.clipsToBounds = true
        notificationImage.layer.masksToBounds = true
        notificationImage.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(notificationImage)
    }
    
    func setupButtonLogout(){
        buttonLogout = UIButton(type: .system)
        buttonLogout.setTitle("Logout", for: .normal)
        buttonLogout.tintColor = .black
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonLogout)
    }
    
    func setupLogoutImage(){
        logoutImage = UIImageView()
        logoutImage.image = UIImage(systemName: "rectangle.portrait.and.arrow.forward")?.withRenderingMode(.alwaysOriginal)
        logoutImage.contentMode = .scaleAspectFill
        logoutImage.clipsToBounds = true
        logoutImage.layer.masksToBounds = true
        logoutImage.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(logoutImage)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),

            profilePhoto.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 40),
            profilePhoto.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            profilePhoto.widthAnchor.constraint(equalToConstant: 220),
            profilePhoto.heightAnchor.constraint(equalToConstant: 220),
     
            labelUsername.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 18),
            labelUsername.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),

            profileBackground.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 20),
            profileBackground.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            profileBackground.heightAnchor.constraint(equalToConstant: 100),
            profileBackground.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor),
            

            
            profileImage.topAnchor.constraint(equalTo: profileBackground.bottomAnchor, constant: 50),
            profileImage.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 80),
            profileImage.heightAnchor.constraint(equalToConstant: 30),
            profileImage.widthAnchor.constraint(equalToConstant: 30),
            
            buttonProfile.topAnchor.constraint(equalTo: profileImage.topAnchor),
            buttonProfile.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 20),
            buttonProfile.heightAnchor.constraint(equalToConstant: 30),
            buttonProfile.widthAnchor.constraint(lessThanOrEqualTo: contentWrapper.widthAnchor),
            
            notificationImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 30),
            notificationImage.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 80),
            notificationImage.heightAnchor.constraint(equalToConstant: 30),
            notificationImage.widthAnchor.constraint(equalToConstant: 30),
            
            buttonNotification.topAnchor.constraint(equalTo: notificationImage.topAnchor),
            buttonNotification.leadingAnchor.constraint(equalTo: notificationImage.trailingAnchor, constant: 20),
            buttonNotification.heightAnchor.constraint(equalToConstant: 30),
            buttonNotification.widthAnchor.constraint(lessThanOrEqualTo: contentWrapper.widthAnchor),
            
            logoutImage.topAnchor.constraint(equalTo: buttonNotification.bottomAnchor, constant: 160),
            logoutImage.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            logoutImage.heightAnchor.constraint(equalToConstant: 30),
            logoutImage.widthAnchor.constraint(equalToConstant: 30),
            
            buttonLogout.topAnchor.constraint(equalTo: logoutImage.topAnchor),
            buttonLogout.leadingAnchor.constraint(equalTo: logoutImage.trailingAnchor, constant: 5),
            buttonLogout.heightAnchor.constraint(equalToConstant: 30),
            buttonLogout.widthAnchor.constraint(lessThanOrEqualTo: contentWrapper.widthAnchor),
            
            buttonLogout.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
