//
//  MeterCaptureViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 10/14/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class MeterCaptureViewController: BaseViewController {

    public var previousReading: Int = 0
    public var currentReading: Int = 0
    public var meterImage: UIImage!
    
    @IBOutlet private weak var previousReadingLabel: UILabel!
    @IBOutlet private weak var currentReadingLabel: UILabel!
    @IBOutlet private weak var kwhUsedLabel: UILabel!
    
    @IBOutlet private weak var totalDueLabel: UILabel!
    @IBOutlet private weak var payNowButton: UIButton!
    @IBOutlet private weak var totalContainerView: UIView!
    @IBOutlet private weak var meterImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        self.meterImageView.image = meterImage
        self.totalContainerView.backgroundColor = UIColor.themeColor()
        
        self.previousReadingLabel.text = "\(self.previousReading)"
        self.currentReadingLabel.text = "\(self.currentReading)"
        let kwhUsed = currentReading - previousReading
        self.kwhUsedLabel.text = "\(kwhUsed)"
    }

}

// MARK: - Tappers
extension MeterCaptureViewController {
    
    @IBAction private func payNowTapped(_ sender: Any) {
        
    }
    
}
