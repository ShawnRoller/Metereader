//
//  ViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 8/30/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    enum ViewState {
        case login
        case account
        case selecting
    }
    
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var selectAccountLabel: UILabel!
    @IBOutlet weak var loginButton: MRButton!
    @IBOutlet weak var passwordField: MRTextField!
    @IBOutlet weak var emailField: MRTextField!
    @IBOutlet weak var accountField: MRTextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleImageView: UIView!
    private var viewState: ViewState = .login {
        didSet { updateView(for: viewState) }
    }

}

// MARK: - Manage Views
extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func updateView(for state: ViewState) {
        switch state {
        case login:
            prepareForLogin()
        case account:
            prepareForAccount()
        case selecting:
            prepareForSelecting()
        default:
            break
        }
    }
    
    private func prepareForLogin() {
        
    }
    
    private func prepareForAccount() {
        
    }
    
    private func prepareForSelecting() {
        
    }

}

