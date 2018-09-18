//
//  HistoryViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 9/3/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataManager: DataManagerProtocol!
    let cellID = "HistoryTableViewCell"
    var history = [BillingHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataManager = Constants.UI_TESTING ? MockDataManager() : DataManager()
        getHistory(forCustomer: "test", fromDate: Date(), toDate: Date())
        setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.register(UINib(nibName: self.cellID, bundle: nil), forCellReuseIdentifier: self.cellID)
    }

}

// MARK: - API
extension HistoryViewController {
    
    private func getHistory(forCustomer customer: String, fromDate: Date, toDate: Date) {
        self.dataManager.getHistory(forCustomer: customer, fromDate: fromDate, toDate: toDate) { [unowned self] (history) in
            guard history.count > 0 else {
                self.showAlert(message: "No data found for the range selected.  Please select a new date range.", buttonTitle: "OK")
                return
            }
            self.history = history
            self.tableView.reloadData()
        }
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HistoryTableViewCell
        let bill = self.history[indexPath.row]
        cell.configureCell(bill)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.history.count
    }
    
}
