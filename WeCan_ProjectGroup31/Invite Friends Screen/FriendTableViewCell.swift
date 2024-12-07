//
//  FriendTableViewCell.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit

class FriendTableViewCell: UITableViewCell {
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
        // Configure the content view with padding and light gray background
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)

        // Add padding around the contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear // Ensure the cell background matches the parent view
        layer.masksToBounds = false // Allow shadow or spacing effects
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 4

        // User Image View
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 25
        contentView.addSubview(userImageView)

        // Name Label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .black
        contentView.addSubview(nameLabel)

        // Add contentView constraints for fixed left and right margins
        NSLayoutConstraint.activate([
            // Ensure the contentView has equal left and right spacing
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16), // Left margin
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16), // Right margin
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 8), // Top spacing between cells
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8), // Bottom spacing between cells

            // Image constraints
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 50), // Fixed diameter
            userImageView.heightAnchor.constraint(equalToConstant: 50), // Fixed diameter

            // Text label constraints
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with user: User) {
        nameLabel.text = user.name
        if let photoURL = user.photoURL, let url = URL(string: photoURL) {
            loadImage(from: url)
        } else {
            userImageView.image = UIImage(systemName: "person.circle")
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.userImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}

