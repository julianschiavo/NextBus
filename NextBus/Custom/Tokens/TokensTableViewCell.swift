//
//  TokensTableViewCell.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import UIKit

class TokensTableViewCell: UITableViewCell, ReusableTableViewCell {
    
    static let reuseIdentifier = "TokensTableViewCell"
    
    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(tokens: [Token]) {
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
        stackView.subviews.forEach { $0.removeFromSuperview() }
        
        stackView.addArrangedSubview(SpacerView())
        for token in tokens {
            let tokenView = TokenView(token: token)
            stackView.addArrangedSubview(tokenView)
        }
    }
}
