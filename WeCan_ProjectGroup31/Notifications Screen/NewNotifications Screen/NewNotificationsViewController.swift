//
//  NewNotificationsViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NewNotificationsViewController: UIViewController {

    let newNotificationsView = NewNotificationsView()
    var currentUser: FirebaseAuth.User?
    var notifList = [Notif]()
    let database = Firestore.firestore()
    
    override func loadView() {
        view = newNotificationsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let currentUserEmail = self.currentUser?.email
        else{
            return
        }
        // idsplay the notification list
        self.database.collection("users").document(currentUserEmail).collection("notifications")
            .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                if let documents = querySnapshot?.documents{
                    self.notifList.removeAll()
                    for doc in documents{
                        do{
                            let notif = try doc.data(as: Notif.self)
                            if !notif.isDeleted && !notif.isNotificationRead {
                                self.notifList.append(notif)
                            }
                        }catch{
                            print(error)
                        }
                    }
                    self.notifList.sort(by: {$0.dateTime.dateValue() > $1.dateTime.dateValue()})
                    self.newNotificationsView.tableViewNotif.reloadData()
                }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Unread"
        let titleAttributes: [NSAttributedString.Key: Any] = [.font:UIFont.boldSystemFont(ofSize: 22)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        newNotificationsView.tableViewNotif.delegate = self
        newNotificationsView.tableViewNotif.dataSource = self
        newNotificationsView.tableViewNotif.separatorStyle = .none
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

extension NewNotificationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifs", for: indexPath) as! NotificationsTableViewCell
        cell.labelMessageFrom.text = notifList[indexPath.row].messageFrom
        //convert timestamp to date
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.labelDatetime.text = outputFormatter.string(from: notifList[indexPath.row].dateTime.dateValue())
        cell.labelMessage.text = notifList[indexPath.row].message
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationDetailsController = NotificationDetailsViewController()
        if let currentUserEmail = currentUser?.email,
           let currentUser = currentUser {
            notificationDetailsController.currentUser = currentUser
            notificationDetailsController.currentNotif = notifList[indexPath.row]
            notificationDetailsController.displayNotification()
            // update the notification is readed
            self.database.collection("users")
                .document(currentUserEmail)
                .collection("notifications")
                .document(notifList[indexPath.row].notifId!)
                .updateData([
                    "isNotificationRead": true
                ]) { error in
                    if let error = error {
                        self.showAlert("Error updating isNotificationRead: \(error.localizedDescription)")
                    } else {
                        print("isNotificationRead successfully updated!")
                    }
                }
            navigationController?.pushViewController(notificationDetailsController, animated: true)
        }
    }
}
