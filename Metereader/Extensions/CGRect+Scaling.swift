//
//  CGRect+Scaling.swift
//  Metereader
//
//  Created by Shawn Roller on 11/7/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

extension CGRect {
    func scaleUp(scaleUp: CGFloat) -> CGRect {
        let biggerRect = self.insetBy(
            dx: -self.size.width * scaleUp,
            dy: -self.size.height * scaleUp
        )
        
        return biggerRect
    }
}
