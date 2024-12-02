//
//  EditProfileView.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit

class EditProfileView: UIView {
    
    var contentWrapper: UIScrollView!
    var buttonTakePhoto: UIButton!
    var textFieldName: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupContentWrapper()
        setupProfilePhotoButton()
        setupNameTextField()
        initConstraints()
    }
    
    func setupContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentWrapper)
    }
    
    func setupProfilePhotoButton() {
        buttonTakePhoto = UIButton(type: .system)
        buttonTakePhoto.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        buttonTakePhoto.contentHorizontalAlignment = .fill
        buttonTakePhoto.contentVerticalAlignment = .fill
        buttonTakePhoto.layer.cornerRadius = 60
        buttonTakePhoto.layer.masksToBounds = true
        buttonTakePhoto.imageView?.contentMode = .scaleAspectFill
        buttonTakePhoto.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonTakePhoto)
    }
    
    func setupNameTextField() {
        textFieldName = UITextField()
        textFieldName.placeholder = "Enter your name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.clearButtonMode = .whileEditing
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textFieldName)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            buttonTakePhoto.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 40),
            buttonTakePhoto.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            buttonTakePhoto.widthAnchor.constraint(equalToConstant: 120),
            buttonTakePhoto.heightAnchor.constraint(equalToConstant: 120),
            
            textFieldName.topAnchor.constraint(equalTo: buttonTakePhoto.bottomAnchor, constant: 20),
            textFieldName.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 20),
            textFieldName.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -20),
            textFieldName.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
