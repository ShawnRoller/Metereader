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
    
    @IBOutlet private weak var previousReadingLabel: UILabel!
    @IBOutlet private weak var currentReadingLabel: UILabel!
    @IBOutlet private weak var kwhUsedLabel: UILabel!
    
    @IBOutlet private weak var totalDueLabel: UILabel!
    @IBOutlet private weak var payNowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: - Tappers
extension MeterCaptureViewController {
    
    @IBAction private func payNowTapped(_ sender: Any) {
        
    }
    
}
