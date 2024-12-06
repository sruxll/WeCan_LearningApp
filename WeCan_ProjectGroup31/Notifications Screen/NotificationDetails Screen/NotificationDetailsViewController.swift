//
//  NotificationDetailsViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NotificationDetailsViewController: UIViewController {

    let notificationDetails = NotificationDetailsView()
    var currentUser: FirebaseAuth.User?
    var currentNotif: Notif?
    let database = Firestore.firestore()
    
    override func loadView() {
        view = notificationDetails
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationDetails.buttonMoveToTrash.addTarget(self, action: #selector(onButtonMoveToTrashTapped), for: .touchUpInside)
    }
    
    func displayNotification(){
        guard let currentNotifFrom = currentNotif?.messageFrom,
              let currentNotifMessage = currentNotif?.message,
              let currentNotifTime = currentNotif?.dateTime
        else {
            return
        }
        notificationDetails.labelMessageFrom.text = "From: \(currentNotifFrom)"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        notificationDetails.labelDatetime.text = outputFormatter.string(from: currentNotifTime.dateValue())
        notificationDetails.textViewDisplayNotif.text = currentNotifMessage
    }
    
    @objc func onButtonMoveToTrashTapped(){
        guard let currentNotifID = currentNotif?.notifId,
              let currentUserEmail = currentUser?.email
        else {
            return
        }
        
        // update the notification is moving to trash
        self.database.collection("users")
            .document(currentUserEmail)
            .collection("notifications")
            .document(currentNotifID)
            .updateData(["isDeleted": true]) {[self] error in
                if let error = error {
                    self.showAlert("Error updating isDeleted: \(error.localizedDescription)")
                } else {
                    print("isDeleted successfully updated!")
                    navigationController?.popViewController(animated: true)
                }
            }
    }

}
