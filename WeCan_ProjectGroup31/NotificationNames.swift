//
//  NotificationNames.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 11/3/24.
//

import Foundation

extension Notification.Name{
    static let userLogout = Notification.Name("userLogout")
    
    static let userSignIn = Notification.Name("userSignIn")
    
    static let userSignUp = Notification.Name("userSignUp")
    
    static let userJumpToSignIn = Notification.Name("userJumpToSignIn")
    
    static let userJumpToSignUp = Notification.Name("userJumpToSignUp")
    
    static let userForgotPassword = Notification.Name("userForgotPassword")
    
    static let userPasswordReset = Notification.Name("userPasswordReset")
    
    static let userJumpToNotification = Notification.Name("userJumpToNotification")
    
}
