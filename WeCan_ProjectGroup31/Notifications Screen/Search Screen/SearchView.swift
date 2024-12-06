//
//  SearchView.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/5/24.
//

import UIKit

class SearchView: UIView {

    var labelDisplayText: UILabel!
    var textFieldSearch: UITextField!
    var buttonSearch: UIButton!
    var tableViewNotif: UITableView!
    var labelSearchResult: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setupLabelDisplayText()
        setuptextFieldSearch()
        setupbuttonSearch()
        setuptableViewNotif()
        setuplabelSearchResult()
        
        initConstraints()
    }

    func setupLabelDisplayText() {
        labelDisplayText = UILabel()
        labelDisplayText.text = "Field Contains"
        labelDisplayText.font = labelDisplayText.font.withSize(22)
        labelDisplayText.textColor = UIColor.black
        labelDisplayText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelDisplayText)
    }
    
    func setuptextFieldSearch() {
        textFieldSearch = UITextField()
        textFieldSearch.placeholder = "Search"
        textFieldSearch.borderStyle = .roundedRect
        textFieldSearch.autocapitalizationType = .none
        textFieldSearch.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldSearch)
    }
    
    func setupbuttonSearch() {
        buttonSearch = UIButton(type: .system)
        buttonSearch.setTitle("Search", for: .normal)
        buttonSearch.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSearch)
    }
    
    func setuptableViewNotif(){
        tableViewNotif = UITableView()
        tableViewNotif.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "notifs")
        tableViewNotif.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewNotif)
    }
    
    func setuplabelSearchResult(){
        labelSearchResult = UILabel()
        labelSearchResult.text = ""
        labelSearchResult.font = labelSearchResult.font.withSize(16)
        labelSearchResult.textColor = UIColor.gray
        labelSearchResult.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelSearchResult)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelDisplayText.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            labelDisplayText.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            labelDisplayText.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            textFieldSearch.topAnchor.constraint(equalTo: labelDisplayText.bottomAnchor, constant: 10),
            textFieldSearch.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            textFieldSearch.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            
            buttonSearch.topAnchor.constraint(equalTo: textFieldSearch.topAnchor),
            buttonSearch.centerYAnchor.constraint(equalTo: textFieldSearch.centerYAnchor),
            buttonSearch.leadingAnchor.constraint(equalTo: textFieldSearch.trailingAnchor, constant: 10),
            
            labelSearchResult.topAnchor.constraint(equalTo: buttonSearch.bottomAnchor, constant: 15),
            labelSearchResult.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            labelSearchResult.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            tableViewNotif.topAnchor.constraint(equalTo: labelSearchResult.bottomAnchor, constant: 20),
            tableViewNotif.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableViewNotif.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableViewNotif.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
