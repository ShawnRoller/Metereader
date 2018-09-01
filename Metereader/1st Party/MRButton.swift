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
        didSet { self.layer.cornerRadius = cornerRadius; self.setNeedsLayout() }
    }
    
    public var color: UIColor = UIColor.themeColor() {
        didSet { self.setNeedsLayout() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLayer()
        
        // Theme fonts
        self.titleLabel?.font = UIFont(name: Constants.secondaryFont(), size: 30) ?? UIFont.systemFont(ofSize: 30)
        self.titleLabel?.textColor = UIColor.white
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
