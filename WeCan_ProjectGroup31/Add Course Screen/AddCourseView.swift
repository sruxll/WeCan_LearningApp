//
//  ViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit

class AddCourseView: UIView {
    let nameTextField = UITextField()
    let descriptionTextField = UITextField()
    let photoButton = UIButton()
    let addSectionButton = UIButton()
    let sectionsTableView = UITableView()
    let saveButton = UIButton()
    let selectedImageView = UIImageView() // Displays the selected image

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white

        // Text fields
        [nameTextField, descriptionTextField].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.borderStyle = .roundedRect
        }
        nameTextField.placeholder = "Course Name"
        descriptionTextField.placeholder = "Description"

        // Photo button
        addSubview(photoButton)
        photoButton.setTitle("Select Photo", for: .normal)
        photoButton.setTitleColor(.systemBlue, for: .normal)
        photoButton.translatesAutoresizingMaskIntoConstraints = false

        // Image preview
        addSubview(selectedImageView)
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.contentMode = .scaleAspectFit
        selectedImageView.layer.borderWidth = 1
        selectedImageView.layer.borderColor = UIColor.gray.cgColor
        selectedImageView.layer.cornerRadius = 8
        selectedImageView.clipsToBounds = true

        // Add section button
        addSubview(addSectionButton)
        addSectionButton.setTitle("Add Section", for: .normal)
        addSectionButton.setTitleColor(.systemBlue, for: .normal)
        addSectionButton.translatesAutoresizingMaskIntoConstraints = false

        // Sections table view
        addSubview(sectionsTableView)
        sectionsTableView.translatesAutoresizingMaskIntoConstraints = false
        sectionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SectionCell")

        // Save button
        addSubview(saveButton)
        saveButton.setTitle("Save Course", for: .normal)
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            descriptionTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),

            photoButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 16),
            photoButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),

            selectedImageView.topAnchor.constraint(equalTo: photoButton.bottomAnchor, constant: 16),
            selectedImageView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            selectedImageView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            selectedImageView.heightAnchor.constraint(equalToConstant: 150),

            addSectionButton.topAnchor.constraint(equalTo: selectedImageView.bottomAnchor, constant: 16),
            addSectionButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            addSectionButton.heightAnchor.constraint(equalToConstant: 40),

            sectionsTableView.topAnchor.constraint(equalTo: addSectionButton.bottomAnchor, constant: 16),
            sectionsTableView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            sectionsTableView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            sectionsTableView.heightAnchor.constraint(equalToConstant: 200),

            saveButton.topAnchor.constraint(equalTo: sectionsTableView.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
