//
//  UIImage+Crop.swift
//  Metereader
//
//  Created by Shawn Roller on 10/28/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        guard let imageRef = self.cgImage?.cropping(to: rect) else { return UIImage() }
        let image = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}
