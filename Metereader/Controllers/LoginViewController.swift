//
//  ViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 8/30/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    enum ViewState {
        case login
        case account
        case selecting
        case loading
    }
    
    let LOADING_OVERLAY_OPACITY: CGFloat = 0.6
    
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var selectAccountLabel: UILabel!
    @IBOutlet weak var accountField: MRTextField!
    
    @IBOutlet weak var loginButton: MRButton!
    @IBOutlet weak var passwordField: MRTextField!
    @IBOutlet weak var emailField: MRTextField!
    
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
        
        self.viewState = .login
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
    }
    
    private func setupViews() {
        // Round corners
        self.loginButton.cornerRadius = self.loginButton.frame.height / 2
        self.accountField.cornerRadius = self.accountField.frame.height / 2
        self.emailField.cornerRadius = self.emailField.frame.height / 2
        self.passwordField.cornerRadius = self.passwordField.frame.height / 2
        
        // Shadows
        self.addShadow(to: self.passwordField)
        self.addShadow(to: self.accountField)
        self.addShadow(to: self.loginButton)
        self.addShadow(to: self.emailField)
    }
    
    private func updateView(for state: ViewState) {
        switch state {
        case .login:
            prepareForLogin()
        case .account:
            prepareForAccount()
        case .selecting:
            prepareForSelecting()
        case .loading:
            prepareForLoading()
        }
    }
    
    // TODO: animate all this crap
    private func prepareForLogin() {
        // Ensure the unused elements are hidden
        removeSpinner()
        self.overlay.alpha = 0
        self.selectAccountLabel.alpha = 0
        self.accountField.alpha = 0
        
        // Ensure the necessary elements are visible
        self.passwordField.alpha = 1
        self.emailField.alpha = 1
        self.loginButton.setTitle("Login", for: .normal)
    }
    
    private func prepareForAccount() {
        // Ensure the unused elements are hidden
        self.removeSpinner()
        self.passwordField.alpha = 0
        self.emailField.alpha = 0
        self.overlay.alpha = 0
        
        // Ensure the necessary elements are visible
        self.selectAccountLabel.alpha = 1
        self.accountField.alpha = 1
        self.loginButton.setTitle("Submit", for: .normal)
    }
    
    private func prepareForSelecting() {
        self.overlay.backgroundColor = UIColor.black
        self.overlay.alpha = LOADING_OVERLAY_OPACITY
    }
    
    private func prepareForLoading() {
        self.overlay.backgroundColor = UIColor.white
        self.overlay.alpha = LOADING_OVERLAY_OPACITY
        createSpinner()
    }
    
    private func createSpinner() {
        let spinnerSize = self.loginButton.frame.width / 2
        let xPosition = (self.view.frame.width / 2) - (spinnerSize / 2)
        let yPosition = (self.view.frame.height / 2) - (spinnerSize / 2)
        let spinner = createSpinner(withFrame: CGRect(x: xPosition, y: yPosition, width: spinnerSize, height: spinnerSize))
        self.view.addSubview(spinner)
        spinner.startAnimating()
    }

}

// MARK: - Tappers
extension LoginViewController {
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        switch self.viewState {
        case .login:
            self.viewState = .account
        case .account:
            self.viewState = .loading
            performLogin()
        default:
            break
        }
    }
    
    private func performLogin() {
        self.performSegue(withIdentifier: Constants.loginHistorySegue, sender: nil)
    }
    
}

