//
//  MockAPIManager.swift
//  Metereader
//
//  Created by Shawn Roller on 9/16/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import Foundation

struct MockAPIManager: APIManagerProtocol {
    
    func getHistory(postData: [AnyHashable: Any], completion: @escaping (_ response: [AnyHashable: Any]) -> Void) {
        
        
    }
    
    func getAddresses(postData: [AnyHashable: Any], completion: @escaping (_ response: [AnyHashable: Any]) -> Void) {
        
    }
    
}
