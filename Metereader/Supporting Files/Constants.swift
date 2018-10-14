//
//  Constants.swift
//  Metereader
//
//  Created by Shawn Roller on 8/31/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

struct Constants {
    
    static let UI_TESTING = true
    
    //MARK: - Segues
    static let loginHistorySegue = "LoginHistorySegue"
    static let historyCameraSegue = "HistoryCameraSegue"
    static let CameraImageAnalyzerSegue = "CameraImageAnalyzerSegue"
    static let ImageAnalyzerMeterCaptureSegue = "ImageAnalyzerMeterCaptureSegue"
    
    static func themeFont() -> String {
        return "Gotham-Book"
    }
    
    static func secondaryFont() -> String {
        return "Gotham-Light"
    }
    
}
