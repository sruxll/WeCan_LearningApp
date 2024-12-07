//
//  CourseDetailView.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit

class CourseDetailView: UIView {
    private let descriptionContainer = UIView() // Container for the description
    let descriptionLabel = UILabel()
    let sectionsLabel = UILabel() // New label for "Learning Sections"
    let tableView = UITableView()
    let actionButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white

        // Description Container
        addSubview(descriptionContainer)
        descriptionContainer.translatesAutoresizingMaskIntoConstraints = false
        descriptionContainer.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 229/255, alpha: 1.0) // Warm beige color
        descriptionContainer.layer.cornerRadius = 8
        descriptionContainer.layer.masksToBounds = true

        // Description Label
        descriptionContainer.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.numberOfLines = 0

        // Sections Label
        addSubview(sectionsLabel)
        sectionsLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionsLabel.text = "Learning Sections"
        sectionsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        sectionsLabel.textColor = UIColor.systemBrown
        sectionsLabel.textAlignment = .center

        // Table View
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SectionTableViewCell.self, forCellReuseIdentifier: "SectionCell")

        // Action Button
        addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = .systemBlue
        actionButton.layer.cornerRadius = 8

        // Layout
        NSLayoutConstraint.activate([
            // Description Container
            descriptionContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            descriptionContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: descriptionContainer.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionContainer.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionContainer.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionContainer.bottomAnchor, constant: -16),

            // Sections Label
            sectionsLabel.topAnchor.constraint(equalTo: descriptionContainer.bottomAnchor, constant: 16),
            sectionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Table View
            tableView.topAnchor.constraint(equalTo: sectionsLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -16),

            // Action Button
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            actionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
