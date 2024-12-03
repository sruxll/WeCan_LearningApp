//
//  FriendsProgressTableViewCell.swift
//  WeCan_ProjectGroup31
//
//  Created by FengAdela on 12/2/24.
//

import UIKit

class FriendsProgressTableViewCell: UITableViewCell {
    private let containerView = UIView()
    private let userImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let progressBar = UIStackView() // Horizontal stack view for segmented progress bar

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
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // Light gray background
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
        userNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        containerView.addSubview(userNameLabel)

        // Progress Bar
        progressBar.axis = .horizontal
        progressBar.spacing = 6 // Add spacing between segments
        progressBar.distribution = .fillEqually // Ensure all segments are evenly spaced
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressBar)

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
            userNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),

            progressBar.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: userNameLabel.trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            progressBar.heightAnchor.constraint(equalToConstant: 12), // Increased thickness
            progressBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with user: User, progress: [Int: Bool], course: Course) {
        // Set user image
        if let url = URL(string: user.photoURL ?? "") {
            userImageView.loadRemoteImage(from: url)
        } else {
            userImageView.image = UIImage(systemName: "person.circle")
        }

        // Set user name
        userNameLabel.text = user.name

        // Configure progress bar
        progressBar.arrangedSubviews.forEach { $0.removeFromSuperview() } // Clear existing segments

        for (index, section) in course.schedule.enumerated() {
            let isCompleted = progress[section.sectionNumber] ?? false
            let segment = UIView()
            segment.backgroundColor = isCompleted ? .systemGreen : .systemGray4

            // Apply angled effect
            segment.layer.cornerRadius = 6
            if index == 0 {
                segment.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            } else if index == course.schedule.count - 1 {
                segment.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            } else {
                segment.layer.maskedCorners = []
            }
            segment.layer.masksToBounds = true

            progressBar.addArrangedSubview(segment)
        }
    }
}
