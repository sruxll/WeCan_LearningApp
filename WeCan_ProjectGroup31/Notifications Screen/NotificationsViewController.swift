//
//  NotificationsViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NotificationsViewController: UIViewController {

    let notificationsView = NotificationsView()
    var currentUser: FirebaseAuth.User?
    var notifList = [Notif]()
    let database = Firestore.firestore()
    
    override func loadView() {
        view = notificationsView
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
                            if !notif.isDeleted {
                                self.notifList.append(notif)
                            }
                        }catch{
                            print(error)
                        }
                    }
                    self.notifList.sort(by: {$0.dateTime.dateValue() > $1.dateTime.dateValue()})
                    self.notificationsView.tableViewNotif.reloadData()
                }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notifications"
        let titleAttributes: [NSAttributedString.Key: Any] = [.font:UIFont.boldSystemFont(ofSize: 22)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        notificationsView.tableViewNotif.delegate = self
        notificationsView.tableViewNotif.dataSource = self
        notificationsView.tableViewNotif.separatorStyle = .none
               
        notificationsView.newNotifButton.addTarget(self, action: #selector(onNewNotifButtonTapped), for: .touchUpInside)
        notificationsView.trashButton.addTarget(self, action: #selector(onTrashButtonTapped), for: .touchUpInside)
        notificationsView.searchButton.addTarget(self, action: #selector(onSearchButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func onNewNotifButtonTapped() {
        let newNotificationsController = NewNotificationsViewController()
        if let currentUser = currentUser {
            newNotificationsController.currentUser = currentUser
            navigationController?.pushViewController(newNotificationsController, animated: true)
        }
    }
    
    @objc func onTrashButtonTapped() {
        let trashController = TrashViewController()
        if let currentUser = currentUser {
            trashController.currentUser = currentUser
            navigationController?.pushViewController(trashController, animated: true)
        }
    }
    
    @objc func onSearchButtonTapped() {
        let searchController = SearchViewController()
        if let currentUser = currentUser {
            searchController.currentUser = currentUser
            navigationController?.pushViewController(searchController, animated: true)
        }
    }
    
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource{
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

