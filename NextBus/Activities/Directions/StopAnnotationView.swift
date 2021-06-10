//
//  StopAnnotationView.swift
//  NextBus
//
//  Created by Julian Schiavo on 11/2/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import UIKit

class StopAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let color: UIColor
    
    init(coordinate: CLLocationCoordinate2D, color: UIColor) {
        self.coordinate = coordinate
        self.color = color
        super.init()
    }
}

class StopAnnotationView: MKAnnotationView {
    private let annotationFrame = CGRect(x: 0, y: 0, width: 8, height: 8)
    
    init(annotation: StopAnnotation) {
        super.init(annotation: annotation, reuseIdentifier: "StopAnnotationView")
        self.frame = annotationFrame
        self.backgroundColor = .clear
        
        let path = UIBezierPath(ovalIn: annotationFrame)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = annotation.color.cgColor
        shapeLayer.lineWidth = 3.0
        layer.addSublayer(shapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented!")
    }
    
//    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//
//        context.beginPath()
//        context.move(to: CGPoint(x: rect.midX, y: rect.maxY))
//        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
//        context.closePath()
//
//        UIColor.blue.set()
//        context.fillPath()
//    }
}
