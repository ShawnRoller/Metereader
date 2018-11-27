//
//  HistoryTableViewCell.swift
//  Metereader
//
//  Created by Shawn Roller on 9/3/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var tagDueLabel: UILabel!
    @IBOutlet weak var tagDaysLabel: UILabel!
    
    @IBOutlet weak var statementDateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalDollarsLabel: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureCell(_ bill: BillingHistory) {
        self.totalDollarsLabel.text = bill.billString
        self.statementDateLabel.text = bill.statementDate.toDateString()
        if bill.paymentDate != nil {
            configurePaid(bill)
        }
        else {
            configureUnpaid(bill)
        }
    }
    
    private func configurePaid(_ bill: BillingHistory) {
        self.tagView.isHidden = true
        self.payButton.setTitleColor(UIColor.paidButtonColor(), for: .normal)
        self.payButton.setTitle("Paid", for: .normal)
        self.containerView.backgroundColor = UIColor.paidCellColor()
    }
    
    private func configureUnpaid(_ bill: BillingHistory) {
        self.tagView.isHidden = false
        self.tagView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -0.25)
        
        let daysTilDue = Date().difference(to: bill.dueDate)
        if daysTilDue < 0 {
            self.tagDueLabel.text = ""
            self.tagDaysLabel.text = "Over Due"
            self.tagView.backgroundColor = UIColor.overdueTagColor()
        }
        else {
            let days = daysTilDue == 1 ? "day" : "days"
            self.tagDueLabel.text = "due"
            self.tagDaysLabel.text = "\(daysTilDue) \(days)"
            self.tagView.backgroundColor = UIColor.dueTagColor()
        }
        
        self.payButton.setTitleColor(UIColor.payButtonColor(), for: .normal)
        self.payButton.setTitle("Pay", for: .normal)
        self.containerView.backgroundColor = UIColor.unpaidCellColor()
    }
    
}
