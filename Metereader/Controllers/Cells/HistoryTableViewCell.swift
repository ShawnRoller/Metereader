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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureCell(_ bill: BillingHistory) {
        self.tagView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -0.25)
        self.totalDollarsLabel.text = "$\(bill.totalBill)"
    }
    
}
