//
//  EditProfileViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Linjing Li on 12/2/24.
//

import UIKit
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class EditProfileViewController: UIViewController {
    
    var editProfileView = EditProfileView()
    var currentUser: FirebaseAuth.User?
    var onProfileUpdated: ((FirebaseAuth.User) -> Void)?
    var selectedImage: UIImage?
    
    override func loadView() {
        view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        
        setupSaveButton()
        preloadUserData()
        
        editProfileView.buttonTakePhoto.addTarget(self, action: #selector(onChangePhotoTapped), for: .touchUpInside)
    }
    
    func setupSaveButton() {
        // Add a Save button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(onSaveTapped)
        )
    }
    
    func preloadUserData() {
        if let user = currentUser {
            editProfileView.textFieldName.text = user.displayName
            if let photoURL = user.photoURL {
                editProfileView.buttonTakePhoto.loadRemoteImage(from: photoURL)
            }
        }
    }
    
    @objc func onChangePhotoTapped() {
        let alert = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            self.pickUsingCamera()
        })
        alert.addAction(UIAlertAction(title: "Gallery", style: .default) { _ in
            self.pickPhotoFromGallery()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc func onSaveTapped() {
        guard let name = editProfileView.textFieldName.text else { return }
        
        // Update Firebase Authentication user
        let changeRequest = currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        if let image = selectedImage {
            uploadProfileImage(image) { [weak self] url in
                changeRequest?.photoURL = url
                self?.commitProfileChanges(changeRequest: changeRequest)
            }
        } else {
            commitProfileChanges(changeRequest: changeRequest)
        }
    }
    
    func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_photos/\(currentUser?.uid ?? UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if error != nil {
                print("Failed to upload image")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    func commitProfileChanges(changeRequest: UserProfileChangeRequest?) {
        changeRequest?.commitChanges { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to update profile: \(error.localizedDescription)")
                return
            }
            guard let currentUser = self.currentUser else {
                print("Current user is nil")
                return
            }
            // Call the callback to update the profile on the previous screen
            self.onProfileUpdated?(currentUser)
            self.navigationController?.popViewController(animated: true)
        }
    }

}

// MARK: - Image Picker Extensions
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    func pickUsingCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func pickPhotoFromGallery() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    // PHPickerViewControllerDelegate Implementation
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else {
            print("No image selected or cannot load image.")
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                return
            }
            
            if let selectedImage = image as? UIImage {
                DispatchQueue.main.async {
                    self.selectedImage = selectedImage
                    self.editProfileView.buttonTakePhoto.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
        }
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            editProfileView.buttonTakePhoto.setImage(image, for: .normal)
        }
    }
}
