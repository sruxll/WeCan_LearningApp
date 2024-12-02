//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit

class CourseUserListTableViewCell: UITableViewCell {
    private let userImageView = UIImageView()
    private let nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        // Add rounded corners and light gray background to the content view
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)

        // User Image View
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 30 // Circular edges
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.addSubview(userImageView)

        // Name Label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .black
        contentView.addSubview(nameLabel)

        // Layout Constraints
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor), // Maintain square aspect ratio

            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with user: User) {
        nameLabel.text = user.name
        if let photoURL = user.photoURL, let url = URL(string: photoURL) {
            userImageView.loadRemoteImage(from: url)
        } else {
            userImageView.image = UIImage(systemName: "person.circle")
        }
    }
}
