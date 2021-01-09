//
//  ReusableTableViewCell.swift
//  NextBus
//
//  Created by Julian Schiavo on 18/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import UIKit

protocol ReusableTableViewCell: UITableViewCell {
    static var reuseIdentifier: String { get }
}
