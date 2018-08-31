//
//  MRButton.swift
//  Metereader
//
//  Created by Shawn Roller on 8/30/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class MRButton: UIButton {

    public var cornerRadius: CGFloat = 8 {
        didSet { self.setNeedsLayout() }
    }
    
    public var color: UIColor = UIColor.themeColor() {
        didSet { self.setNeedsLayout() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLayer()
    }
    
    private var customLayer: CAShapeLayer?
    private func layoutLayer() {
        if let existingLayer = customLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
        shapeLayer.fillColor = self.color.cgColor
        self.layer.insertSublayer(shapeLayer, at: 0)
        self.customLayer = shapeLayer
    }

}
