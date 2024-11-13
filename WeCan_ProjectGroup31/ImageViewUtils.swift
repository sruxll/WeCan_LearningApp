//
//  ImageViewUtils.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 11/12/24.
//

import Foundation
import UIKit

extension UIImageView {
    func loadRemoteImage(from url: URL) {
        DispatchQueue.global().async {[weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }            
        }
    }
}

extension UIButton {
    func loadRemoteImage(from url: URL) {
        DispatchQueue.global().async {[weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                    }
                }
            }
        }
    }
}
