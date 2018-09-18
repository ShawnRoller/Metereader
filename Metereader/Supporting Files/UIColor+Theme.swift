//
//  UIColor+Theme.swift
//  Metereader
//
//  Created by Shawn Roller on 8/31/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Theme
    static func themeColor() -> UIColor {
        return UIColor(red: 0.467, green: 0.722, blue: 0.918, alpha: 1.00)
    }
    
    // MARK: - HistoryTableViewCell
    static func unpaidCellColor() -> UIColor {
        return UIColor(red: 0.953, green: 0.953, blue: 0.953, alpha: 1.00)
    }
    
    static func paidCellColor() -> UIColor {
        return UIColor(red: 0.922, green: 0.922, blue: 0.922, alpha: 1.00)
    }
    
    static func payButtonColor() -> UIColor {
        return UIColor(red: 0.290, green: 0.565, blue: 0.886, alpha: 1.00)
    }
    
    static func paidButtonColor() -> UIColor {
        return UIColor(red: 0.525, green: 0.745, blue: 0.286, alpha: 1.00)
    }
    
    static func dueTagColor() -> UIColor {
        return UIColor(red: 0.588, green: 0.855, blue: 1.000, alpha: 1.00)
    }
    
    static func overdueTagColor() -> UIColor {
        return UIColor(red: 1.000, green: 0.435, blue: 0.435, alpha: 1.00)
    }
    
}
