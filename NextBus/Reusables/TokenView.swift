//
//  TokenView.swift
//  NextBus
//
//  Created by Julian Schiavo on 30/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import UIKit

struct Token {
    var color: UIColor
    var imageName: String
    var text: String
    
    var image: UIImage {
        UIImage(systemName: imageName) ?? UIImage(named: imageName) ?? UIImage()
    }
    
    // MARK: - Presets
    
    static func tokens(route: Route, stop: Stop? = nil) -> [Token] {
        var tokens = [Token]()
        if let fare = route.fare ?? stop?.normalFare {
            tokens.append(.price(fare))
        }
        if route.isSpecial || stop?.specialDeparturesOnly == true {
            tokens.append(.special)
        }
        if route.isOvernight || route.name.first == "N" {
            tokens.append(.overnight)
        }
        return tokens
    }
    
    static func price(_ price: String) -> Token {
        Token(color: .systemGreen, imageName: "dollarsign.circle", text: "$" + price)
    }
    
    static let special = Token(color: .systemRed, imageName: "star", text: "SPECIAL")
    static let overnight = Token(color: .systemPurple, imageName: "moon.stars", text: "OVERNIGHT")
}

class TokenView: UIView {
    
    let stackView = UIStackView()
    let imageView = UIImageView()
    let textLabel = UILabel()
    
    init(token: Token) {
        super.init(frame: .zero)
        let font = UIFont.preferredFont(for: .callout, weight: .medium).rounded.smallCaps
        
        backgroundColor = token.color
        layer.cornerRadius = 5
        layer.masksToBounds = true
        setContentHuggingPriority(.required, for: .horizontal)
        
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        
        imageView.image = token.image
        imageView.preferredSymbolConfiguration = .init(font: font)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        textLabel.text = token.text
        textLabel.font = font
        textLabel.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
