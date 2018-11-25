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
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var cameraContainer: UIView!
    @IBOutlet weak var cameraIcon: UIImageView!
    
    var dataManager: DataManagerProtocol!
    let cellID = "HistoryTableViewCell"
    var history = [BillingHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataManager = Constants.UI_TESTING ? MockDataManager() : DataManager()
        getHistory(forCustomer: "test", fromDate: Date(), toDate: Date())
        setupViews()
        setupTableView()
    }
    
    private func setupViews() {
        self.footerView.backgroundColor = UIColor.footerColor()
        self.cameraContainer.backgroundColor = UIColor.themeColor()
        
        let views = [self.cameraContainer, self.cameraIcon]
        
        // Add tappers
        for view in views {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.cameraButtonTapped(sender:)))
            view?.addGestureRecognizer(gesture)
            view?.isUserInteractionEnabled = true
        }
        
        // Round the camera container
        self.cameraContainer.layer.cornerRadius = self.cameraContainer.frame.width / 2
        
        // Nav bar
        self.navigationController?.navigationBar.barTintColor = UIColor.themeColor()
        self.navigationItem.title = "Statements"
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutButtonTapped(sender:)))
        logoutButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = logoutButton
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.register(UINib(nibName: self.cellID, bundle: nil), forCellReuseIdentifier: self.cellID)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 87, right: 0)
        self.tableView.contentInset = insets
    }

}

// MARK: - Tappers
extension HistoryViewController {
    
    @objc private func cameraButtonTapped(sender: Any) {
        self.performSegue(withIdentifier: Constants.historyCameraSegue, sender: nil)
    }
    
    @objc private func logoutButtonTapped(sender: Any) {
        print("logged out")
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
        cell.clipsToBounds = true
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.history.count
    }
    
}
