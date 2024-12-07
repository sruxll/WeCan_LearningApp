//
//  RegisterFirebaseManager.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 11/11/24.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

extension RegisterPageViewController{
    func uploadProfilePhotoToStorage(){
        var profilePhotoURL: URL?
         
        //upload the profile photo
        if let image = pickedImage{
            if let jpegData = image.jpegData(compressionQuality: 80){
                let storageRef = storage.reference()
                let imageRepo = storageRef.child("imagesUserProfile")
                let imageRef = imageRepo.child("\(NSUUID().uuidString).jpg")
                
                imageRef.putData(jpegData, completion: {(metadata, error) in
                    if error == nil{
                        imageRef.downloadURL(completion: {(url, error) in
                            if error == nil{
                                profilePhotoURL = url
                                self.registerUser(photoURL: profilePhotoURL)
                            }
                        })
                    }
                })
            }
        }else{
            registerUser(photoURL: profilePhotoURL)
        }
    }
    
    func registerUser(photoURL: URL?){
        guard let name = registerPage.textFieldName.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            self.showAlert("Username cannot be empty!")
            self.hideActivityIndicator()
            return
        }
        
        guard let inputEmail = registerPage.textFieldEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines), !inputEmail.isEmpty else {
            self.showAlert("Email cannot be empty!")
            self.hideActivityIndicator()
            return
        }
        let email = inputEmail.lowercased()
        
        guard let password = registerPage.textFieldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            self.showAlert("Password cannot be empty!")
            self.hideActivityIndicator()
            return
        }
        
        if password.count < 6 {
            self.showAlert("Password must be at least 6 characters long!")
            self.hideActivityIndicator()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(result, error) in
            if error == nil{
                let newUserRef = self.database.collection("users").document(email)
                newUserRef.setData(["username": name, "email": email, "photoURL": photoURL?.absoluteString ?? ""], completion: { error in
                    if error == nil {
                        print("Document successfully added!")
                        // save user creditential to defaults
                        UserAccessCredential.setUserCreditential(userName: email, userPassword: password)
                    }else{
                        self.showAlert("Error adding document!")
                    }
                })
                self.setNameAndPhotoOfTheUserInFirebaseAuth(name: name, email: email, photoURL: photoURL)
            }else{
                self.showAlert("The email address is already in use by another account!")
                self.hideActivityIndicator()
            }
        })

    }
    
    func setNameAndPhotoOfTheUserInFirebaseAuth(name: String, email: String, photoURL: URL?){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        changeRequest?.commitChanges(completion: {(error) in
            self.hideActivityIndicator()
            if error != nil {
                self.showAlert("Error on changing request!")
            }else{
                self.clearTextFields()
                self.navigationController?.popViewController(animated: false)
                NotificationCenter.default.post(name: .userSignUp, object: Auth.auth().currentUser)
            }
        })
    }
    
    func clearTextFields(){
        registerPage.textFieldEmail.text = ""
        registerPage.textFieldPassword.text = ""
        registerPage.textFieldName.text = ""
        registerPage.buttonTakePhoto.setImage(UIImage(systemName: "camera.fill"), for: .normal)
    }
}
