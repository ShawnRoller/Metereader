//
//  MRTextField.swift
//  Metereader
//
//  Created by Shawn Roller on 8/30/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class MRTextField: UITextField {

    public var cornerRadius: CGFloat = 8 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.setNeedsLayout()
        }
    }
    
    public var color: UIColor = UIColor.white {
        didSet { self.setNeedsLayout() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutLayer()
        
        // Theme fonts
        self.font = UIFont(name: Constants.themeFont(), size: 20) ?? UIFont.systemFont(ofSize: 20)
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
