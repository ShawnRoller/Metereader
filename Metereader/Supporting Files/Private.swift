//
//  Private.swift
//  Metereader
//
//  Created by Shawn Roller on 11/23/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import Foundation

struct APIKey {
    static let googleAPIKey = ""
    static var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
}
