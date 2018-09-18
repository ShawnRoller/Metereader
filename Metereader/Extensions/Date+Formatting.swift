//
//  Date+Formatting.swift
//  Metereader
//
//  Created by Shawn Roller on 9/17/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import Foundation

extension Date {
    
    func toDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: self)
    }
    
    func difference(to date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0
    }
    
}
