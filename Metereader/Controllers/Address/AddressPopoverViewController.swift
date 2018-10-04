//
//  AddressPopoverViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 10/3/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class AddressPopoverViewController: UIViewController {

    private let cellID = "AddressTableViewCell"
    
    // TODO: custom initializer for setting these properties
    public var delegate: LoginDelegate?
    public var addresses: [Address]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: self.cellID, bundle: nil), forCellReuseIdentifier: self.cellID)
    }
}

// MARK: - UITableViewDelegate
extension AddressPopoverViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.addresses.count > indexPath.row else { return }
        self.delegate?.selectAddress(self.addresses[indexPath.row])
        self.delegate?.dismissAddressVC()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
}

// MARK: - UITableViewDataSource
extension AddressPopoverViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! AddressTableViewCell
        cell.titleLabel?.text = addresses[indexPath.row].nickname
        return cell
    }
    
}
