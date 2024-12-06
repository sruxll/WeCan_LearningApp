//
//  NotificationDetailsView.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/4/24.
//

import UIKit

class NotificationDetailsView: UIView {

    var contentWrapper: UIScrollView!
    var textViewDisplayNotif:UITextView!
    var labelMessageFrom: UILabel!
    var labelDatetime: UILabel!
    var buttonMoveToTrash: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        // initializing the UI elements and constraints
        setupContentWrapper()
        setuptextViewDisplayNotif()
        setuplabelMessageFrom()
        setuplabelDatetime()
        setupbuttonMoveToTrash()
        
        initConstraints()
    }
    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setuptextViewDisplayNotif(){
        textViewDisplayNotif = UITextView()
        textViewDisplayNotif.font = UIFont.systemFont(ofSize: 16)
        textViewDisplayNotif.textColor = .black
        textViewDisplayNotif.isEditable = false
        textViewDisplayNotif.isScrollEnabled = true
        textViewDisplayNotif.backgroundColor = .white
        textViewDisplayNotif.layer.borderColor = UIColor.lightGray.cgColor
        textViewDisplayNotif.layer.borderWidth = 1.0
        textViewDisplayNotif.layer.cornerRadius = 8
        textViewDisplayNotif.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(textViewDisplayNotif)
    }
    
    func setuplabelMessageFrom(){
        labelMessageFrom = UILabel()
        labelMessageFrom.textColor = .black
        labelMessageFrom.font = UIFont.boldSystemFont(ofSize: 18)
        labelMessageFrom.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelMessageFrom)
    }
    
    func setuplabelDatetime(){
        labelDatetime = UILabel()
        labelDatetime.textColor = .gray
        labelDatetime.font = UIFont.systemFont(ofSize: 16)
        labelDatetime.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelDatetime)
    }
    
    func setupbuttonMoveToTrash(){
        buttonMoveToTrash = UIButton(configuration: UIButton.Configuration.borderedProminent())
        buttonMoveToTrash.setTitle("Move to Trash", for: .normal)
        buttonMoveToTrash.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonMoveToTrash)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            labelMessageFrom.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 5),
            labelMessageFrom.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: 25),
            labelMessageFrom.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor, multiplier: 0.5),
            
            labelDatetime.topAnchor.constraint(equalTo: labelMessageFrom.topAnchor),
            labelDatetime.centerYAnchor.constraint(equalTo: labelMessageFrom.centerYAnchor),
            labelDatetime.leadingAnchor.constraint(equalTo: labelMessageFrom.trailingAnchor, constant: 5),
            labelDatetime.widthAnchor.constraint(lessThanOrEqualTo: contentWrapper.widthAnchor),
            
            textViewDisplayNotif.topAnchor.constraint(equalTo: labelDatetime.bottomAnchor, constant: 30),
            textViewDisplayNotif.leadingAnchor.constraint(equalTo: labelMessageFrom.leadingAnchor),
            textViewDisplayNotif.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor, multiplier: 0.87),
            textViewDisplayNotif.heightAnchor.constraint(equalToConstant: 200),
            
            buttonMoveToTrash.topAnchor.constraint(equalTo: textViewDisplayNotif.bottomAnchor, constant: 50),
            buttonMoveToTrash.widthAnchor.constraint(equalTo: contentWrapper.widthAnchor, multiplier: 0.6),
            buttonMoveToTrash.heightAnchor.constraint(equalToConstant: 50),
            buttonMoveToTrash.centerXAnchor.constraint(equalTo: contentWrapper.centerXAnchor),
            buttonMoveToTrash.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor),

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
