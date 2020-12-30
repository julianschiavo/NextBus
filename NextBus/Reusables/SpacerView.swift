//
//  SpacerView.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import UIKit

class SpacerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
