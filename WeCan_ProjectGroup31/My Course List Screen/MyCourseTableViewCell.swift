//
//  MyCourseTableViewCell.swift
//  WeCan_ProjectGroup31
//
//  Created by FengAdela on 12/2/24.
//

import UIKit

class MyCourseTableViewCell: UITableViewCell {
    private let containerView = UIView()
    private let courseImageView = UIImageView()
    private let titleLabel = UILabel()
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
        containerView.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // Light gray color
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)

        // Course Image
        courseImageView.translatesAutoresizingMaskIntoConstraints = false
        courseImageView.contentMode = .scaleAspectFill
        courseImageView.clipsToBounds = true
        courseImageView.layer.cornerRadius = 8
        containerView.addSubview(courseImageView)

        // Title Label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 1
        containerView.addSubview(titleLabel)

        // Progress Bar (Stack View)
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

            courseImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            courseImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            courseImageView.heightAnchor.constraint(equalToConstant: 60),
            courseImageView.widthAnchor.constraint(equalToConstant: 60),

            titleLabel.leadingAnchor.constraint(equalTo: courseImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),

            progressBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            progressBar.heightAnchor.constraint(equalToConstant: 12), // Increased thickness
            progressBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with course: Course, progress: [Int: Bool]) {
        // Set image and title
        if let url = URL(string: course.imageURL) {
            courseImageView.loadRemoteImage(from: url)
        }
        titleLabel.text = course.name

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

