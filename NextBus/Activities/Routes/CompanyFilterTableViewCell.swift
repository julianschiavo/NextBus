//
//  DirectionTableViewCell.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import UIKit

class CompanyFilterTableViewCell: UITableViewCell, ReusableTableViewCell {
    
    static let reuseIdentifier = "CompanyFilterTableViewCell"
    
    var company: Company?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.textColor = .secondaryLabel
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .companyIsShownChanged, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(company: Company) {
        self.company = company
        update()
    }
    
    @objc func update() {
        guard let company = company else { return }
        textLabel?.text = company.name
        accessoryType = company.isShown ? .checkmark : .none
    }
}
