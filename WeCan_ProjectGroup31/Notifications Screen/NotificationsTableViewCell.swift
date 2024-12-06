//
//  NotificationsTableViewCell.swift
//  WeCan_ProjectGroup31
//
//  Created by Lili XIANG on 12/4/24.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    var wrapperCellView: UIView!
    var labelMessageFrom: UILabel!
    var labelDatetime: UILabel!
    var labelMessage: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        setupWrapperCellView()
        setuplabelMessageFrom()
        setupLabelDatetime()
        setuplabelMessage()
        
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 4.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 2.0
        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setuplabelMessageFrom(){
        labelMessageFrom = UILabel()
        labelMessageFrom.textColor = .black
        labelMessageFrom.font = UIFont.boldSystemFont(ofSize: 18)
        labelMessageFrom.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelMessageFrom)
    }
    
    func setupLabelDatetime(){
        labelDatetime = UILabel()
        labelDatetime.font = UIFont.systemFont(ofSize: 12)
        labelDatetime.textColor = .gray
        labelDatetime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelDatetime)
    }
    
    func setuplabelMessage(){
        labelMessage = UILabel()
        labelMessage.font = UIFont.systemFont(ofSize: 14)
        labelMessage.textColor = .black
//        labelMessage.lineBreakMode = .byWordWrapping
//        labelMessage.numberOfLines = 0
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelMessage)
    }
    
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 8),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            labelMessageFrom.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelMessageFrom.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            
            labelDatetime.topAnchor.constraint(equalTo: labelMessageFrom.topAnchor),
            labelDatetime.centerYAnchor.constraint(equalTo: labelMessageFrom.centerYAnchor),
            labelDatetime.leadingAnchor.constraint(equalTo: labelMessageFrom.trailingAnchor, constant: 25),
            labelDatetime.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            labelDatetime.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelMessage.topAnchor.constraint(equalTo: labelMessageFrom.bottomAnchor, constant: 10),
            labelMessage.leadingAnchor.constraint(equalTo: labelMessageFrom.leadingAnchor),
            labelMessage.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -10),
            labelMessage.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
