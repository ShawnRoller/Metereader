//
//  MRView.swift
//  Metereader
//
//  Created by Shawn Roller on 11/25/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

@IBDesignable

class MRView: UIView {
    
    override var bounds: CGRect {
        didSet {
            chooseShadowFunction()
        }
    }
    
    @IBInspectable var shadowPosition: Int = 1 {
        didSet {
            chooseShadowFunction()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 8 {
        didSet {
            chooseShadowFunction()
        }
    }
    
    private func chooseShadowFunction() {
        switch shadowPosition {
        case 0:
            setupInnerShadow()
        case 1:
            setupOutsideShadow()
        case 2:
            setupOutsideRoundShadow()
        default:
            break
        }
    }
    
    private func setupOutsideRoundShadow() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: self.bounds.width / 2, height: self.bounds.width / 2)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setupOutsideShadow() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setupInnerShadow() {
        // from https://github.com/okakaino/InnerShadowTest/blob/master/InnerShadowTest/UIViewExtension.swift
        // define and set a shadow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 3
        shadowLayer.fillRule = CAShapeLayerFillRule.evenOdd
        shadowLayer.cornerRadius = self.cornerRadius
        let shadowSize: CGFloat = 3
        
        // define shadow path
        let shadowPath = CGMutablePath()
        
        // define outer rectangle to restrict drawing area
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        
        // define inner rectangle for mask
        let innerFrame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
        
        // add outer and inner rectangle to shadow path
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        
        // set shadow path as show layer's
        shadowLayer.path = shadowPath
        
        // add shadow layer as a sublayer
        layer.addSublayer(shadowLayer)
        
        // hide outside drawing area
        clipsToBounds = true
    }
    
}

