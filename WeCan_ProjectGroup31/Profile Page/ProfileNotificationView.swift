//
//  ProfileNotificationView.swift
//  WeCan_ProjectGroup31
//

import UIKit

class ProfileNotificationView: UIView {

    var contentWrapper: UIScrollView!
    var profilePhoto: UIButton!
    var labelUsername: UILabel!
    var labelEmail: UILabel!
    var profileBackground: UIImageView!
    var buttonCourses: UIButton!
    var courseImage: UIImageView!
    var buttonNotification: UIButton!
    var notificationImage: UIImageView!
    var buttonLogout: UIButton!
    var logoutImage: UIImageView!
    
    var buttonFriends: UIButton!
    var friendsImage: UIImageView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupProfilePhoto()
        setupLabelUsername()
        setupLabelEmail()
        setupProfileBackground()
        setupButtonCourse()
        setupCourseImage()
        setupButtonNotification()
        setupNotificationImage()
        setupButtonLogout()
        setupLogoutImage()
        
        setupButtonFriends()
        setupFriendsImage()
        
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
    
    func setupLabelEmail(){
        labelEmail = UILabel()
        labelEmail.text = ""
        labelEmail.font = .systemFont(ofSize: 16)
        labelEmail.textColor = .gray
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelEmail)
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
    
    func setupButtonCourse(){
        buttonCourses = UIButton(type: .system)
        buttonCourses.setTitle("My Courses", for: .normal)
        buttonCourses.tintColor = .black
        buttonCourses.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonCourses)
    }
    
    func setupCourseImage(){
        courseImage = UIImageView()
        courseImage.image = UIImage(systemName: "books.vertical.circle")?.withRenderingMode(.alwaysOriginal)
        courseImage.contentMode = .scaleAspectFill
        courseImage.tintColor = .purple
        courseImage.clipsToBounds = true
        courseImage.layer.masksToBounds = true
        courseImage.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(courseImage)
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
    
    func setupButtonFriends(){
        buttonFriends = UIButton(type: .system)
        buttonFriends.setTitle("My Friends", for: .normal)
        buttonFriends.tintColor = .black
        buttonFriends.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonFriends)
    }
    
    func setupFriendsImage(){
        friendsImage = UIImageView()
        friendsImage.image = UIImage(systemName: "figure.2")?.withRenderingMode(.alwaysOriginal)
        friendsImage.contentMode = .scaleAspectFill
        friendsImage.tintColor = .orange
        friendsImage.clipsToBounds = true
        friendsImage.layer.masksToBounds = true
        friendsImage.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(friendsImage)
    }
    
    func initConstraints() {
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

            labelEmail.topAnchor.constraint(equalTo: labelUsername.bottomAnchor, constant: 8),
            labelEmail.centerXAnchor.constraint(equalTo: labelUsername.centerXAnchor),
            labelEmail.leadingAnchor.constraint(greaterThanOrEqualTo: profileBackground.leadingAnchor, constant: 16),
            labelEmail.trailingAnchor.constraint(lessThanOrEqualTo: profileBackground.trailingAnchor, constant: -16),
            labelEmail.bottomAnchor.constraint(lessThanOrEqualTo: profileBackground.bottomAnchor, constant: -8),

            courseImage.topAnchor.constraint(equalTo: profileBackground.bottomAnchor, constant: 50),
            courseImage.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 80),
            courseImage.heightAnchor.constraint(equalToConstant: 30),
            courseImage.widthAnchor.constraint(equalToConstant: 30),
            
            buttonCourses.topAnchor.constraint(equalTo: courseImage.topAnchor),
            buttonCourses.leadingAnchor.constraint(equalTo: courseImage.trailingAnchor, constant: 20),
            buttonCourses.heightAnchor.constraint(equalToConstant: 30),
            buttonCourses.widthAnchor.constraint(lessThanOrEqualTo: contentWrapper.widthAnchor),

            friendsImage.topAnchor.constraint(equalTo: courseImage.bottomAnchor, constant: 30),
            friendsImage.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 80),
            friendsImage.heightAnchor.constraint(equalToConstant: 30),
            friendsImage.widthAnchor.constraint(equalToConstant: 30),

            buttonFriends.topAnchor.constraint(equalTo: friendsImage.topAnchor),
            buttonFriends.leadingAnchor.constraint(equalTo: friendsImage.trailingAnchor, constant: 20),
            buttonFriends.heightAnchor.constraint(equalToConstant: 30),
            buttonFriends.widthAnchor.constraint(lessThanOrEqualTo: contentWrapper.widthAnchor),

            notificationImage.topAnchor.constraint(equalTo: friendsImage.bottomAnchor, constant: 30),
            notificationImage.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 80),
            notificationImage.heightAnchor.constraint(equalToConstant: 30),
            notificationImage.widthAnchor.constraint(equalToConstant: 30),

            buttonNotification.topAnchor.constraint(equalTo: notificationImage.topAnchor),
            buttonNotification.leadingAnchor.constraint(equalTo: notificationImage.trailingAnchor, constant: 20),
            buttonNotification.heightAnchor.constraint(equalToConstant: 30),
            buttonNotification.widthAnchor.constraint(lessThanOrEqualTo: contentWrapper.widthAnchor),

            logoutImage.topAnchor.constraint(equalTo: buttonNotification.bottomAnchor, constant: 100),
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
