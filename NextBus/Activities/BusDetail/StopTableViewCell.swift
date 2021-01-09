//
//  StopTableViewCell.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import UIKit

class StopTableViewCell: UITableViewCell, ReusableTableViewCell {
    
    static let reuseIdentifier = "StopTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.textColor = .secondaryLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(stop: Stop) {
        let monospacedFont = UIFont.monospacedDigitFont(for: .body, weight: .semibold)
        let attributedText = NSMutableAttributedString(string: "\(stop.index): ", attributes: [.font: monospacedFont])
        let stopNameAttributedText = NSAttributedString(string: stop.localizedName)
        attributedText.append(stopNameAttributedText)
        
        textLabel?.attributedText = attributedText
    }
}

