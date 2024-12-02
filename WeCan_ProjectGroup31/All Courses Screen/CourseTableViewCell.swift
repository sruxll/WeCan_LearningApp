//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    let courseImageView = UIImageView()
    let courseNameLabel = UILabel()
    let courseDescriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Course Image
        courseImageView.contentMode = .scaleAspectFill
        courseImageView.clipsToBounds = true
        courseImageView.layer.cornerRadius = 8
        contentView.addSubview(courseImageView)

        // Course Name
        courseNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        contentView.addSubview(courseNameLabel)

        // Course Description
        courseDescriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        courseDescriptionLabel.textColor = .darkGray
        courseDescriptionLabel.numberOfLines = 2
        contentView.addSubview(courseDescriptionLabel)
    }

    private func setupConstraints() {
        courseImageView.translatesAutoresizingMaskIntoConstraints = false
        courseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        courseDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Course Image Constraints
            courseImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            courseImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            courseImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            courseImageView.widthAnchor.constraint(equalToConstant: 80),
            courseImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 80),

            // Course Name Constraints
            courseNameLabel.leadingAnchor.constraint(equalTo: courseImageView.trailingAnchor, constant: 16),
            courseNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            courseNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            // Course Description Constraints
            courseDescriptionLabel.leadingAnchor.constraint(equalTo: courseImageView.trailingAnchor, constant: 16),
            courseDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            courseDescriptionLabel.topAnchor.constraint(equalTo: courseNameLabel.bottomAnchor, constant: 4),
            courseDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with course: Course) {
        courseNameLabel.text = course.name
        courseDescriptionLabel.text = course.description
        if let imageURL = URL(string: course.imageURL) {
            // Load the image asynchronously (use a library like SDWebImage for better performance)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.courseImageView.image = UIImage(data: data)
                    }
                }
            }
        } else {
            courseImageView.image = UIImage(systemName: "photo")
        }
    }
}
