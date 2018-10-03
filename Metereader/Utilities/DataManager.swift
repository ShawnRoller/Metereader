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
    func getAddresses(postData: [AnyHashable: Any], completion: @escaping (_ response: [AnyHashable: Any]) -> Void)
}

protocol DataManagerProtocol {
    func getHistory(forCustomer customer: String, fromDate: Date, toDate: Date, completion: @escaping (_ response: [BillingHistory]) -> Void)
    func getAddresses(forCustomer customer: String, completion: @escaping (_ response: [Address]) -> Void)
}

struct DataManager: DataManagerProtocol {
    
    var apiManager: APIManagerProtocol!
    
    public func getHistory(forCustomer customer: String, fromDate: Date, toDate: Date, completion: @escaping (_ response: [BillingHistory]) -> Void) {
        self.apiManager.getHistory(postData: [:]) { (response) in
            
        }
    }
    
    func getAddresses(forCustomer customer: String, completion: @escaping (_ response: [Address]) -> Void) {
        self.apiManager.getAddresses(postData: [:]) { (response) in
            
        }
    }
    
}
