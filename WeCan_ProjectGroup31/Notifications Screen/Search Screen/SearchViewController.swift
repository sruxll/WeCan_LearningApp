//
//  SearchViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/5/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SearchViewController: UIViewController {
    let searchView = SearchView()
    var currentUser: FirebaseAuth.User?
    var notifList = [Notif]()
    let database = Firestore.firestore()
    
    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.tableViewNotif.delegate = self
        searchView.tableViewNotif.dataSource = self
        searchView.tableViewNotif.separatorStyle = .none

        searchView.buttonSearch.addTarget(self, action: #selector(onButtonSearchTapped), for: .touchUpInside)
    }

    @objc func onButtonSearchTapped(){
        guard let currentUserEmail = self.currentUser?.email
        else{
            return
        }

        if let searchField = searchView.textFieldSearch.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            if searchField.isEmpty{
                self.showAlert("Search field cannot be empty!")
            } else {
                // display the searched list
                self.database.collection("users")
                    .document(currentUserEmail)
                    .collection("notifications")
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                        } else {
                            for document in querySnapshot!.documents {
                                if let message = document.data()["message"] as? String {
                                    if message.lowercased().contains(searchField.lowercased()) {
                                        print("Message contains: \(searchField)")
                                        do{
                                            let notif = try document.data(as: Notif.self)
                                            if !notif.isDeleted {
                                                self.notifList.append(notif)
                                            }
                                        }catch{
                                            print(error)
                                        }
                                    }
                                }
                                self.notifList.sort(by: {$0.dateTime.dateValue() > $1.dateTime.dateValue()})
                                self.searchView.tableViewNotif.reloadData()
                            }
                            self.searchView.labelSearchResult.text = "Found \(self.notifList.count) results."
                            self.clearTextField()
                        }
                    }
            }
        }
    }
    
    func clearTextField(){
        searchView.textFieldSearch.text = ""
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
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
