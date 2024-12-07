//
//  AddCourseViewController.swift
//  CS5520 Final Project - WeCan
//
//  Group 31
//  Created by Jiehua Feng
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class AddCourseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let addCourseView = AddCourseView()
    private var sections = [Section]()
    private var selectedImageURL: String? // Stores the Firebase Storage URL of the uploaded image

    override func loadView() {
        view = addCourseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Course"

        // Table view setup
        addCourseView.sectionsTableView.delegate = self
        addCourseView.sectionsTableView.dataSource = self

        // Add actions
        addCourseView.addSectionButton.addTarget(self, action: #selector(addSectionButtonTapped), for: .touchUpInside)
        addCourseView.saveButton.addTarget(self, action: #selector(saveCourse), for: .touchUpInside)
        addCourseView.photoButton.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
    }

    @objc private func addSectionButtonTapped() {
        let sectionNumber = sections.count + 1
        let alert = UIAlertController(title: "Add Section", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Section Title" }

        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let title = alert.textFields?.first?.text, !title.isEmpty {
                let section = Section(sectionNumber: sectionNumber, title: title)
                self.sections.append(section)
                self.addCourseView.sectionsTableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func selectPhoto() {
        let alert = UIAlertController(title: "Select Photo", message: "Choose a photo from your library or take a new one.", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.presentImagePicker(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        addCourseView.photoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        // Upload the image to Firebase Storage
        uploadImageToStorage(image: selectedImage)
    }

    private func uploadImageToStorage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let storageRef = Storage.storage().reference().child("course_images/\(UUID().uuidString).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching download URL: \(error)")
                    return
                }

                if let url = url {
                    self.selectedImageURL = url.absoluteString
                    print("Image uploaded successfully: \(self.selectedImageURL ?? "")")
                }
            }
        }
    }

    @objc private func saveCourse() {
        guard
            let name = addCourseView.nameTextField.text,
            let description = addCourseView.descriptionTextField.text,
            let imageURL = selectedImageURL,
            !name.isEmpty, !description.isEmpty
        else {
            print("All fields are required")
            return
        }

        let courseID = UUID().uuidString // Generate a unique ID for the course
        let courseData: [String: Any] = [
            "id": courseID,
            "name": name,
            "description": description,
            "imageURL": imageURL,
            "schedule": sections.map { $0.toDictionary() },
            "subscribedUsers": [] // Initialize with no subscribed users
        ]

        Firestore.firestore().collection("courses").document(courseID).setData(courseData) { error in
            if let error = error {
                print("Error adding course: \(error)")
            } else {
                print("Course added successfully!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - Table View Delegate and Data Source
extension AddCourseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath)
        let section = sections[indexPath.row]
        cell.textLabel?.text = "Section \(section.sectionNumber): \(section.title)"
        return cell
    }
}

