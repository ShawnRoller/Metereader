//
//  ViewController.swift
//  Metereader
//
//  Created by Shawn Roller on 8/30/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func selectAddress(_ address: Address)
    func dismissAddressVC()
}

class LoginViewController: BaseViewController, ContainerViewControllerProtocol {

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
    @IBOutlet weak var popoverView: UIView!
    
    private var addresses: [Address]?
    private var selectedAddress: Address? {
        didSet {
            self.accountField.text = selectedAddress?.nickname ?? ""
        }
    }
    private var dataManager: DataManagerProtocol!
    private var addressVC: AddressPopoverViewController?
    
    private var viewState: ViewState = .login {
        didSet { updateView(for: viewState) }
    }

}

// MARK: - Manage Views
extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewState = .login
        self.dataManager = Constants.UI_TESTING ? MockDataManager() : DataManager()
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
        
        // Colors
        self.accountField.textColor = UIColor.accountFieldTextColor()
        
        // Delegates
        self.accountField.delegate = self
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
        showAddressVC()
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
    
    private func showAddressVC() {
        self.addressVC = AddressPopoverViewController()
        self.addressVC?.delegate = self
        self.addressVC?.addresses = self.addresses
        self.addressVC?.view.layer.cornerRadius = 8
        self.addressVC?.view.layer.masksToBounds = true
        let frame = self.popoverView.frame
        guard let addressVC = self.addressVC else { return }
        addViewController(addressVC, with: frame, from: .bottom) { (done) in
            
        }
    }
    
    private func removeAddressVC() {
        guard let addressVC = self.addressVC else { return }
        removeViewController(addressVC, to: .bottom) { (_) in
            self.addressVC = nil
        }
    }

}

// MARK: - Tappers
extension LoginViewController {
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        switch self.viewState {
        case .login:
            self.viewState = .loading
            getAddresses(forCustomer: self.emailField.text ?? "")
        case .account:
            performLogin()
        default:
            break
        }
    }
    
    private func performLogin() {
        self.performSegue(withIdentifier: Constants.loginHistorySegue, sender: nil)
    }
    
}

// MARK: - LoginDelegate
extension LoginViewController: LoginDelegate {
    
    func selectAddress(_ address: Address) {
        self.selectedAddress = address
    }
    
    func dismissAddressVC() {
        removeAddressVC()
        self.viewState = .account
    }
}

// MARK: - API
extension LoginViewController {
    
    private func getAddresses(forCustomer customer: String) {
        self.dataManager.getAddresses(forCustomer: customer) { [unowned self] (addresses) in
            guard addresses.count > 0 else {
                // TODO: handle error
                return
            }
            self.addresses = addresses
            self.selectedAddress = addresses[0]
            self.viewState = .account
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let addresses = self.addresses, addresses.count > 0 {
            self.viewState = .selecting
        }
        return false
    }
    
    
}
