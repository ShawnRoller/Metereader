//
//  AddressPopoverViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 10/3/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class AddressPopoverViewController: UIViewController {

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
    }
}

// MARK: - UITableViewDelegate
extension AddressPopoverViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.addresses.count > indexPath.row else { return }
        self.delegate?.selectAddress(self.addresses[indexPath.row])
        self.delegate?.dismissAddressVC()
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
        let cell = UITableViewCell()
        cell.textLabel?.text = addresses[indexPath.row].nickname
        return cell
    }
    
}
