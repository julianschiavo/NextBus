//
//  LoadingTableViewCell.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell, ReusableTableViewCell {
    
    static let reuseIdentifier = "LoadingTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(activityIndicator)
        activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
