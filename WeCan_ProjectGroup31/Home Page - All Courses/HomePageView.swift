//
//  HomePageView.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit

class HomePageView: UIView {

    let tableView = UITableView()
    let addCourseButton = UIButton() // Button to add a new course

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        
        // Set up the table view
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Set up the Add Course button
        addSubview(addCourseButton)
        addCourseButton.translatesAutoresizingMaskIntoConstraints = false
        addCourseButton.setImage(UIImage(systemName: "pencil.tip.crop.circle.badge.plus"), for: .normal)
        addCourseButton.tintColor = .systemBlue // Set the icon color to systemBlue
        addCourseButton.backgroundColor = .clear // No background color
        addCourseButton.contentMode = .scaleAspectFit
        addCourseButton.frame.size = CGSize(width: 100, height: 100)
        
        // Position the button at the bottom right
        NSLayoutConstraint.activate([
            addCourseButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addCourseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addCourseButton.widthAnchor.constraint(equalToConstant: 60),
            addCourseButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

