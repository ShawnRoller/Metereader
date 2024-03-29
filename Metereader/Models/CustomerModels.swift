//
//  CustomerModels.swift
//  Metereader
//
//  Created by Shawn Roller on 9/16/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import Foundation

struct BillingHistory {
    var statementDate: Date
    var paymentDate: Date?
    var dueDate: Date
    var totalBill: Double
    var meterReading: Int
    var billString: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTotal = formatter.string(from: totalBill as NSNumber) {
            return formattedTotal
        }
        return "$0.00"
    }
    var isPaid: Bool {
        return paymentDate != nil
    }
}

struct Address {
    var nickname: String
    var address1: String
    var address2: String
    var city: String
    var state: String
    var zip: String
    var country: String
}
