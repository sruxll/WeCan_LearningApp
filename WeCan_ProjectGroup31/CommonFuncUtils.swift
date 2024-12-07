//
//  CommonFuncUtils.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 11/17/24.
//

import Foundation
import UIKit

extension UIViewController{
    func showAlert(_ message: String){
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert .addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: size))
            }
    }
}

class UserAccessCredential {
    static func setUserCreditential(userName: String, userPassword: String) {
        UserDefaults.standard.set(userName, forKey: "weCanUserName")
        UserDefaults.standard.set(userPassword, forKey: "weCanUserPassword")
    }
    
    static func getUserCreditential() -> (String?, String?) {
        return (
            UserDefaults.standard.object(forKey: "weCanUserName") as? String,
            UserDefaults.standard.object(forKey: "weCanUserPassword") as? String
        )
    }

    static func clearUserCreditential(){
        UserDefaults.standard.removeObject(forKey: "weCanUserName")
        UserDefaults.standard.removeObject(forKey: "weCanUserPassword")
    }
}
