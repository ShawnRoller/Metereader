//
//  BaseViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 9/1/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit
import MMMaterialDesignSpinner

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension BaseViewController {
    
    internal func addShadow(to view: UIView) {
        view.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(2))
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.5
        view.layer.shadowPath = UIBezierPath(roundedRect: view.layer.bounds, cornerRadius: view.layer.cornerRadius).cgPath
    }
    
}

extension BaseViewController {

    func createSpinner(withFrame frame: CGRect) -> MMMaterialDesignSpinner {
        let spinner = MMMaterialDesignSpinner(frame: frame)
        spinner.tintColor = UIColor.themeColor()
        spinner.lineWidth = 3
        return spinner
    }
    
    func removeSpinner() {
        for subview in self.view.subviews {
            if subview is MMMaterialDesignSpinner {
                subview.removeFromSuperview()
            }
        }
    }
    
}
