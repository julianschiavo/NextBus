//
//  UIImage-Resize.swift
//  NextBus
//
//  Created by Julian Schiavo on 29/1/2020.
//  Copyright © 2020 Julian Schiavo. All rights reserved.
//

import UIKit

extension UIImage {
    func imageWith(newWidth: CGFloat, inset: CGFloat, backgroundColor: UIColor) -> UIImage {
        let decimalInset = inset / 100
        let inverseDecimalInset = 1 - decimalInset
        
        let scaleFactor = size.height / size.width
        let newHeight = scaleFactor * newWidth
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let newImageSize = CGSize(width: newWidth * decimalInset, height: newHeight * decimalInset)
        let newImagePosition = CGPoint(x: (newWidth * inverseDecimalInset) / 2, y: 20)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { context in
            context.cgContext.setFillColor(backgroundColor.cgColor)
            
            let rectangle = CGRect(origin: .zero, size: newSize)
            context.cgContext.addRect(rectangle)
            context.cgContext.drawPath(using: .fill)
            
            self.draw(in: CGRect.init(origin: newImagePosition, size: newImageSize))
        }
        return image
    }
}
