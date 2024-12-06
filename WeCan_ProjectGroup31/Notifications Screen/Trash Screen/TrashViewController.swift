//
//  TrashViewController.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TrashViewController: UIViewController {

    let trashView = TrashView()
    var currentUser: FirebaseAuth.User?
    var notifList = [Notif]()
    let database = Firestore.firestore()
    
    override func loadView() {
        view = trashView
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
                            if notif.isDeleted {
                                self.notifList.append(notif)
                            }
                        }catch{
                            print(error)
                        }
                    }
                    self.notifList.sort(by: {$0.dateTime.dateValue() > $1.dateTime.dateValue()})
                    self.trashView.tableViewNotif.reloadData()
                }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Trash"
        let titleAttributes: [NSAttributedString.Key: Any] = [.font:UIFont.boldSystemFont(ofSize: 22)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        trashView.tableViewNotif.delegate = self
        trashView.tableViewNotif.dataSource = self
        trashView.tableViewNotif.separatorStyle = .none
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

extension TrashViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifs", for: indexPath) as! NotificationsTableViewCell
        cell.labelMessageFrom.text = notifList[indexPath.row].messageFrom
        cell.labelMessageFrom.lineBreakMode = .byWordWrapping
        cell.labelMessageFrom.numberOfLines = 0
        //convert timestamp to date
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.labelDatetime.text = outputFormatter.string(from: notifList[indexPath.row].dateTime.dateValue())
        cell.labelMessage.text = notifList[indexPath.row].message
        return cell
    }

}
