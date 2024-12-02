//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by AdelaFeng
//

import UIKit

class SectionTableViewCell: UITableViewCell {
    let sectionTitleLabel = UILabel()
    let completeButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        sectionTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(sectionTitleLabel)

        completeButton.setTitle("Complete", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.backgroundColor = .systemBlue
        completeButton.layer.cornerRadius = 8
        completeButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        completeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        contentView.addSubview(completeButton)
    }

    private func setupConstraints() {
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sectionTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sectionTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: completeButton.leadingAnchor, constant: -16),

            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            completeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(with title: String, isCompleted: Bool, showCompleteButton: Bool) {
        sectionTitleLabel.text = title
        completeButton.isHidden = !showCompleteButton

        if isCompleted {
            completeButton.isEnabled = false
            completeButton.backgroundColor = .gray
            completeButton.setTitle("Completed", for: .normal)
        } else {
            completeButton.isEnabled = true
            completeButton.backgroundColor = .systemBlue
            completeButton.setTitle("Complete", for: .normal)
        }
    }
}
