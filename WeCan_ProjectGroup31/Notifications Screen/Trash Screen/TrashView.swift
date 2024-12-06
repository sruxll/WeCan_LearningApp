//
//  TrashView.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/4/24.
//

import UIKit

class TrashView: UIView {

    var tableViewNotif: UITableView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setuptableViewNotif()
        
        initConstraints()
    }
    
    func setuptableViewNotif(){
        tableViewNotif = UITableView()
        tableViewNotif.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "notifs")
        tableViewNotif.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewNotif)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            tableViewNotif.topAnchor.constraint(equalTo: self.topAnchor),
            tableViewNotif.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableViewNotif.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableViewNotif.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
