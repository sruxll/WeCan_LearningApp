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
