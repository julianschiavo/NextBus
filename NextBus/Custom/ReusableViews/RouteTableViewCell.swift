//
//  RouteTableViewCell.swift
//  NextBus
//
//  Created by Julian Schiavo on 18/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell, ReusableTableViewCell {
    
    static let reuseIdentifier = "RouteTableViewCell"
    
    enum Style {
        case regular
        case large
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(route: Route, direction: Direction, origin: String? = nil, isFavorite: Bool = false, style: Style = .regular) {
        let actualOrigin = origin ?? route.localizedOrigin
        let destination = route.localizedDestination
        
        textLabel?.text = style == .regular ? route.localizedName : Localizations.routeTitle(routeName: route.localizedName)
        detailTextLabel?.text = Localizations.routeOriginAndDestination(origin: actualOrigin, destination: destination)
        
        if isFavorite, style != .large {
            imageView?.image = UIImage(systemName: "heart.fill")
            imageView?.tintColor = .systemRed
        } else {
            imageView?.image = UIImage(named: "bus.fill")
            imageView?.tintColor = .systemPink
        }
        
        if style == .large {
            accessoryType = .none
            selectionStyle = .none
            imageView?.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .largeTitle)
            textLabel?.font = UIFont.preferredFont(for: .title1, weight: .heavy)
            detailTextLabel?.font = UIFont.preferredFont(for: .body)
        }
    }
}
