//
//  RegisterPageView.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 10/25/24.
//

import UIKit

class RegisterPageView: UIView {

    var contentWrapper: UIScrollView!
    var titleLabel: UILabel!
    var descriptionLabel1: UILabel!
    var descriptionLabel2: UILabel!
    var textFieldEmail: UITextField!
    var textFieldPassword: UITextField!
    var textFieldName: UITextField!
    var buttonTakePhoto: UIButton!
    var labelDisplayText: UILabel!
//    var textFieldPhoneNumber: UITextField!
//    var buttonSelectPhoneType: UIButton!
//    var textFieldAddress: UITextField!
//    var textFieldCity: UITextField!
//    var textFieldZipcode: UITextField!
    var buttonSignUp: UIButton!
    var accountDesLabel: UILabel!
    var signInButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.backgroundColor = .white
        // MARK: initializing the UI elements and constraints
        setupContentWrapper()
        setupTitleLabel()
        setupDescriptionLabel1()
        setupDescriptionLabel2()
        setupTextFieldEmail()
        setupTextFieldPassword()
        setupTextFieldName()
        setupButtonTakePhoto()
        setupLabelDisplayText()
//        setupTextFieldPhoneNumber()
//        setupButtonSelectPhoneType()
//        setupTextFieldAddress()
//        setupTextFieldCity()
//        setupTextFieldZipcode()
        setupButtonSignUp()
        setupAccountDesLabel()
        setupSignInButton()
        
        initConstraints()
    }
    
    //MARK: initializing the UI elements
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupTitleLabel(){
        titleLabel = UILabel()
        titleLabel.text = "Let's register"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(titleLabel)
    }
    
    func setupDescriptionLabel1(){
        descriptionLabel1 = UILabel()
        descriptionLabel1.text = "Hello!"
        descriptionLabel1.font = .boldSystemFont(ofSize: 16)
        descriptionLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(descriptionLabel1)
    }
    
    func setupDescriptionLabel2(){
        descriptionLabel2 = UILabel()
        descriptionLabel2.text = "We’re excited to have you with us"
        descriptionLabel2.font = .boldSystemFont(ofSize: 16)
        descriptionLabel2.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(descriptionLabel2)
    }
    
    func setupTextFieldEmail() {
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Email"
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.keyboardType = UIKeyboardType.emailAddress
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textFieldEmail)
    }
    
    func setupTextFieldPassword() {
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Password"
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textFieldPassword)
    }
    
    func setupTextFieldName() {
        textFieldName = UITextField()
        textFieldName.placeholder = "Username"
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textFieldName)
    }
    
    func setupButtonTakePhoto() {
        buttonTakePhoto = UIButton(type: .system)
        buttonTakePhoto.setTitle("", for: .normal)
        buttonTakePhoto.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        buttonTakePhoto.contentHorizontalAlignment = .fill
        buttonTakePhoto.contentVerticalAlignment = .fill
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFill
        buttonTakePhoto.showsMenuAsPrimaryAction = true
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonTakePhoto)
    }
    
    func setupLabelDisplayText() {
        labelDisplayText = UILabel()
        labelDisplayText.text = "Take Photo"
        labelDisplayText.font = labelDisplayText.font.withSize(16)
        labelDisplayText.textColor = UIColor.gray
        labelDisplayText.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelDisplayText)
    }
    
//    func setupTextFieldPhoneNumber() {
//        textFieldPhoneNumber = UITextField()
//        textFieldPhoneNumber.placeholder = "Phone"
//        textFieldPhoneNumber.borderStyle = .roundedRect
//        textFieldPhoneNumber.keyboardType = UIKeyboardType.phonePad
//        textFieldPhoneNumber.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(textFieldPhoneNumber)
//    }
//
//    func setupButtonSelectPhoneType(){
//        buttonSelectPhoneType = UIButton(type: .system)
//        buttonSelectPhoneType.setTitle("Home", for: .normal)
//        buttonSelectPhoneType.showsMenuAsPrimaryAction = true
//        buttonSelectPhoneType.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(buttonSelectPhoneType)
//    }
//
//    func setupTextFieldAddress() {
//        textFieldAddress = UITextField()
//        textFieldAddress.placeholder = "Address (Optional)"
//        textFieldAddress.borderStyle = .roundedRect
//        textFieldAddress.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(textFieldAddress)
//    }
//
//    func setupTextFieldCity() {
//        textFieldCity = UITextField()
//        textFieldCity.placeholder = "City, State (Optional)"
//        textFieldCity.borderStyle = .roundedRect
//        textFieldCity.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(textFieldCity)
//    }
//
//    func setupTextFieldZipcode() {
//        textFieldZipcode = UITextField()
//        textFieldZipcode.placeholder = "ZIP (Optional)"
//        textFieldZipcode.borderStyle = .roundedRect
//        textFieldZipcode.keyboardType = UIKeyboardType.numberPad
//        textFieldZipcode.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(textFieldZipcode)
//    }
    
    func setupButtonSignUp() {
        buttonSignUp = UIButton(configuration: UIButton.Configuration.borderedProminent())
        buttonSignUp.setTitle("Sign Up", for: .normal)
        buttonSignUp.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonSignUp)
    }
    
    func setupAccountDesLabel(){
        accountDesLabel = UILabel()
        accountDesLabel.text = "Already have an account?"
        accountDesLabel.font = .boldSystemFont(ofSize: 14)
        accountDesLabel.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(accountDesLabel)
    }
    
    func setupSignInButton(){
        signInButton = UIButton(type: .system)
        signInButton.setTitle("Login", for: .normal)
        signInButton.tintColor = .systemBlue
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(signInButton)
    }
    
    // MARK: initializing constraints
    func initConstraints() {
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
            
            buttonTakePhoto.topAnchor.constraint(equalTo: descriptionLabel2.bottomAnchor, constant: 70),
            buttonTakePhoto.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 70),
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 70),
            
            labelDisplayText.topAnchor.constraint(equalTo: buttonTakePhoto.bottomAnchor, constant: 1),
            labelDisplayText.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            textFieldEmail.topAnchor.constraint(equalTo: labelDisplayText.bottomAnchor, constant: 50),
            textFieldEmail.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 10),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            textFieldName.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 10),
            textFieldName.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            textFieldName.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            
//            textFieldPhoneNumber.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
//            textFieldPhoneNumber.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
//            textFieldPhoneNumber.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -100),
//            buttonSelectPhoneType.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
//            buttonSelectPhoneType.leadingAnchor.constraint(equalTo: textFieldPhoneNumber.trailingAnchor, constant: 10),
//            textFieldAddress.topAnchor.constraint(equalTo: textFieldPhoneNumber.bottomAnchor, constant: 16),
//            textFieldAddress.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
//            textFieldAddress.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
//            textFieldCity.topAnchor.constraint(equalTo: textFieldAddress.bottomAnchor, constant: 16),
//            textFieldCity.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
//            textFieldCity.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
//            textFieldZipcode.topAnchor.constraint(equalTo: textFieldCity.bottomAnchor, constant: 16),
//            textFieldZipcode.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
//            textFieldZipcode.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            buttonSignUp.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 80),
            buttonSignUp.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor, multiplier: 0.9),
            buttonSignUp.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonSignUp.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            
            signInButton.topAnchor.constraint(equalTo: buttonSignUp.bottomAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            signInButton.widthAnchor.constraint(equalToConstant: 50),
            
            //accountDesLabel.topAnchor.constraint(equalTo: signInButton.topAnchor),
            accountDesLabel.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor),
            accountDesLabel.trailingAnchor.constraint(equalTo: signInButton.leadingAnchor, constant: -10),
            accountDesLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            
            signInButton.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
