//
//  AddressPopoverViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 10/3/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class AddressPopoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var addresses: [Address]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    

}

// MARK: - UITableViewDelegate
extension AddressPopoverViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension AddressPopoverViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
