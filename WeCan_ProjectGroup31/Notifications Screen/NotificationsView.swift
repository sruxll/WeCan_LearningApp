//
//  NotificationsView.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/4/24.
//

import UIKit

class NotificationsView: UIView {

    var tableViewNotif: UITableView!
    
    var bottomAddView: UIView!
    // Buttons for the bottom view
    var newNotifButton: UIButton!
    var searchButton: UIButton!
    var trashButton: UIButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setuptableViewNotif()
                
        setupBottomAddView()
        setupBottomAddViewElements() // Add buttons to the bottom view
        
        initConstraints()
    }
    
    func setuptableViewNotif(){
        tableViewNotif = UITableView()
        tableViewNotif.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "notifs")
        tableViewNotif.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewNotif)
    }
    
    func setupBottomAddView(){
        bottomAddView = UIView()
        bottomAddView.backgroundColor = UIColor.systemBlue
        bottomAddView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomAddView)
    }
    
    func setupBottomAddViewElements(){
        // Initialize buttons
        newNotifButton = createButton(title: "Unread", imageName: "folder.badge.plus")
        searchButton = createButton(title: "Search", imageName: "magnifyingglass")
        trashButton = createButton(title: "Trash", imageName: "trash")
        
        // Add buttons to the bottom view
        bottomAddView.addSubview(newNotifButton)
        bottomAddView.addSubview(searchButton)
        bottomAddView.addSubview(trashButton)
        
        // Set constraints for buttons
        newNotifButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newNotifButton.leadingAnchor.constraint(equalTo: bottomAddView.leadingAnchor, constant: 16),
            newNotifButton.centerYAnchor.constraint(equalTo: bottomAddView.centerYAnchor),
            
            searchButton.centerXAnchor.constraint(equalTo: bottomAddView.centerXAnchor),
            searchButton.centerYAnchor.constraint(equalTo: bottomAddView.centerYAnchor),
            
            trashButton.trailingAnchor.constraint(equalTo: bottomAddView.trailingAnchor, constant: -16),
            trashButton.centerYAnchor.constraint(equalTo: bottomAddView.centerYAnchor),
        ])
    }
    
    func createButton(title: String, imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        
        //to get the smaller image and title
        // Create configuration
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        config.imagePlacement = .top // Places the image above the title
        config.imagePadding = 4 // Smaller padding between the image and title
        config.title = title
        
        // Customize title appearance
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.systemFont(ofSize: 12, weight: .medium), // Set smaller font size
            .foregroundColor: UIColor.white // Set title color
        ]))
        
        // Scale down the image
        if let image = UIImage(systemName: imageName) {
            config.image = image.resized(to: CGSize(width: 16, height: 16)) // Resized image
        }
        
        // Apply configuration
        button.configuration = config
        return button
    }
    
    func initConstraints(){
        // Constraints for tableViewNotif
        NSLayoutConstraint.activate([
            tableViewNotif.topAnchor.constraint(equalTo: self.topAnchor),
            tableViewNotif.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableViewNotif.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableViewNotif.bottomAnchor.constraint(equalTo: bottomAddView.topAnchor)
        ])
        
        // Constraints for bottomAddView
        NSLayoutConstraint.activate([
            bottomAddView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomAddView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomAddView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomAddView.heightAnchor.constraint(equalToConstant: 80) // Set height of the bottom view
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
