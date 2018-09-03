//
//  HistoryViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 9/3/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let cellID = "HistoryTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.register(UINib(nibName: self.cellID, bundle: nil), forCellReuseIdentifier: self.cellID)
    }

}

extension HistoryViewController: UITableViewDelegate {
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
