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
    var isPaid: Bool {
        return paymentDate != nil
    }
}

