//
//  ViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 8/30/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit
import MMMaterialDesignSpinner

class LoginViewController: UIViewController {

    enum ViewState {
        case login
        case account
        case selecting
        case loading
    }
    
    let LOADING_OVERLAY_OPACITY: CGFloat = 0.3
    
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var selectAccountLabel: UILabel!
    @IBOutlet weak var accountField: MRTextField!
    
    @IBOutlet weak var loginButton: MRButton!
    @IBOutlet weak var passwordField: MRTextField!
    @IBOutlet weak var emailField: MRTextField!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleImageView: UIView!
    
    private var spinner: MMMaterialDesignSpinner?
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
        self.removeSpinner()
        self.overlay.alpha = 0
        self.selectAccountLabel.alpha = 0
        
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
        self.loginButton.setTitle("Submit", for: .normal)
    }
    
    private func prepareForSelecting() {
        self.overlay.alpha = LOADING_OVERLAY_OPACITY
    }
    
    private func prepareForLoading() {
        self.overlay.alpha = LOADING_OVERLAY_OPACITY * 2
        createSpinner()
    }
    
    private func createSpinner() {
        guard self.spinner == nil else { return }
        let spinnerSize = self.loginButton.frame.width / 2
        let xPosition = (self.view.frame.width / 2) - (spinnerSize / 2)
        let yPosition = (self.view.frame.height / 2) - (spinnerSize / 2)
        self.spinner = MMMaterialDesignSpinner(frame: CGRect(x: xPosition, y: yPosition, width: spinnerSize, height: spinnerSize))
        self.spinner?.tintColor = UIColor.themeColor()
        self.spinner?.lineWidth = 3
        guard self.spinner != nil else { return }
        self.view.addSubview(self.spinner!)
        self.spinner?.startAnimating()
    }
    
    private func removeSpinner() {
        guard self.spinner != nil else { return }
        self.spinner?.stopAnimating()
        self.spinner?.removeFromSuperview()
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
        default:
            break
        }
    }
    
}

