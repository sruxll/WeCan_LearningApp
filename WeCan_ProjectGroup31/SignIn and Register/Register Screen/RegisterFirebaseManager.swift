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
        if let name = registerPage.textFieldName.text,
           let email = registerPage.textFieldEmail.text,
           let password = registerPage.textFieldPassword.text{
            Auth.auth().createUser(withEmail: email, password: password, completion: {(result, error) in
                if error == nil{
                    let newUserRef = self.database.collection("users").document(email)
                    newUserRef.setData(["username": name, "email": email, "photoURL": photoURL?.absoluteString ?? ""], completion: { error in
                        if error == nil {
                            print("Document successfully added!")
                        }else{
                            self.showAlert("Error adding document!")
                        }
                    })
                    self.setNameAndPhotoOfTheUserInFirebaseAuth(name: name, email: email, photoURL: photoURL)
                }else{
                    self.showAlert("The email address is already in use by another account!")
                }
            })
        }
    }
    
    func setNameAndPhotoOfTheUserInFirebaseAuth(name: String, email: String, photoURL: URL?){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = photoURL
        changeRequest?.commitChanges(completion: {(error) in
            if error != nil {
                self.showAlert("Error on changing request!")
            }else{
                self.hideActivityIndicator()
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
