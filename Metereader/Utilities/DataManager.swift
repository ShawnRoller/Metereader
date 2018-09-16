//
//  DataManager.swift
//  Metereader
//
//  Created by Shawn Roller on 9/16/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//
import Foundation

protocol APIManagerProtocol {
    func getHistory(postData: [AnyHashable: Any], completion: @escaping (_ response: [AnyHashable: Any]) -> Void)
}

protocol DataManagerProtocol {
    func getHistory(forCustomer customer: String, fromDate: Date, toDate: Date, completion: @escaping (_ response: [BillingHistory]) -> Void)
}

struct DataManager: DataManagerProtocol {
    
    var apiManager: APIManagerProtocol!
    
    public func getHistory(forCustomer customer: String, fromDate: Date, toDate: Date, completion: @escaping (_ response: [BillingHistory]) -> Void) {
        self.apiManager.getHistory(postData: [:]) { (response) in
            
        }
    }
    
}
