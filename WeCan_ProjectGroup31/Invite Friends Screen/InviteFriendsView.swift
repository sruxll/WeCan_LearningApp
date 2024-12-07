//
//  InviteFriendsView.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit

class InviteFriendsView: UIView {
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white

        // Configure Table View
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 70 // Fixed row height
        tableView.separatorStyle = .none // Remove separators
        addSubview(tableView)

        // Layout Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
