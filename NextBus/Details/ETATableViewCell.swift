//
//  ETATableViewCell.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import UIKit

class ETATableViewCell: UITableViewCell, ReusableTableViewCell {
    
    static let reuseIdentifier = "ETATableViewCell"
    
    var eta: ETA?
    
    var timer: Timer?
    let relativeFormatter = RelativeDateTimeFormatter()
    let dateFormatter = DateFormatter()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(reload), userInfo: nil, repeats: true)
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.textColor = .secondaryLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    func setup(eta: ETA) {
        self.eta = eta
        reload()
    }
    
    @objc func reload() {
        guard let eta = eta else { return }
        guard let date = eta.date, let formattedDate = dateFormatter.string(for: date), let relativeDate = relativeFormatter.string(for: date) else {
            textLabel?.text = Localizations.errorArrivalInformationNotAvailable
            detailTextLabel?.text = eta.remark
            return
        }
        
        textLabel?.text = "\(formattedDate) (\(relativeDate))"
        detailTextLabel?.text = eta.remark
    }
}
