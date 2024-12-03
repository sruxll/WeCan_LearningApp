//
//  CourseUserListTableViewCell.swift
//  WeCan_ProjectGroup31
//
//  Created by FengAdela on 12/2/24.
//

import UIKit

class CourseUserListTableViewCell: UITableViewCell {
    private let containerView = UIView()
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // Container View
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)

        // User Image
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 30
        containerView.addSubview(userImageView)

        // User Name Label
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        userNameLabel.numberOfLines = 0 // Allow multiline
        containerView.addSubview(userNameLabel)

        // Layout Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            userImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: 60),
            userImageView.widthAnchor.constraint(equalToConstant: 60),

            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            userNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        // Ensure contentView has a minimum height
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        print("Cell constraints set up successfully.")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("LayoutSubviews called: Content View Frame: \(contentView.frame)")
    }

    func configure(with user: User) {
        userNameLabel.text = user.name
        if let url = URL(string: user.photoURL ?? "") {
            userImageView.loadRemoteImage(from: url)
        } else {
            userImageView.image = UIImage(systemName: "person.circle")
        }
        print("Configured cell for user: \(user.name)")
    }
}
