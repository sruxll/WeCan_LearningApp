//
//  RegisterPageViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 10/25/24.
//

import UIKit
import PhotosUI
import FirebaseStorage

class RegisterPageViewController: UIViewController {

    let registerPage = RegisterPageView()
    let childProgressView = ProgressSpinnerViewController()
    // store the picked image
    var pickedImage: UIImage?
    let storage = Storage.storage()
    
    override func loadView() {
        view = registerPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerPage.buttonTakePhoto.menu = getMenuImagePicker()
        registerPage.buttonSignUp.addTarget(self, action: #selector(onSignUpButtonTapped), for: .touchUpInside)
        registerPage.signInButton.addTarget(self, action: #selector(onSignInButtonTapped), for: .touchUpInside)
    }
    
    // menu for buttonTakePhoto
    func getMenuImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera", handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery", handler: {(_) in
                self.pickPhotoFromGallery()
            }),
        ]
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    // take photo using Camera
    func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    // pick photo from Gallery
    func pickPhotoFromGallery(){
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        
        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }
    
    @objc func onSignUpButtonTapped(){
        showActivityIndicator()
        uploadProfilePhotoToStorage()
    }
    
    @objc func onSignInButtonTapped(){
        navigationController?.popViewController(animated: false)
        NotificationCenter.default.post(name: .userJumpToSignIn, object: "")
    }
    
}

// adopting protocols for PHPicker
extension RegisterPageViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(ofClass: UIImage.self, completionHandler: {
                    (image, error) in DispatchQueue.main.async{
                        if let uwImage = image as? UIImage {
                            self.registerPage.buttonTakePhoto.setImage(uwImage.withRenderingMode(.alwaysOriginal), for: .normal)
                            self.pickedImage = uwImage
                        }
                    }
                })
            }
        }
    }
}

// adopting protocols for UIImagePicker
extension RegisterPageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            self.registerPage.buttonTakePhoto.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            self.pickedImage = image
        }else{
            // no image loaded
            return
        }
    }
}

extension RegisterPageViewController: ProgressSpinnerDelegate{
    func showActivityIndicator() {
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator() {
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
    
}
