//
//  RegistrationModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 16.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: RegistrationModuleView Class

final class RegistrationViewController: ViewController {
  
  //MARK:- IBOutlets
  @IBOutlet weak var dimView: UIView!
  
  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var usernameTextField: UITextField!

  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var registerButton: UIButton!
  
  @IBOutlet weak var usernamePlaceholderLabel: UILabel!
  @IBOutlet weak var emailPlaceholderLabel: UILabel!
  
  @IBOutlet weak var passwordPlaceholderLabel: UILabel!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var inputsBackgroundView: UIView!
  
  @IBOutlet weak var navigationBarView: UIView!
  @IBOutlet weak var usernameTitleLabel: UILabel!
  @IBOutlet weak var emailTitleLabel: UILabel!
  @IBOutlet weak var passwordTitleLabel: UILabel!
  
  @IBOutlet weak var showPasswordButton: UIButton!
  
  @IBOutlet var passwordRequirementsIndicatorViews: [UIView]!
  
  @IBOutlet var passwordRequirementsTitleLabels: [UILabel]!
  
  @IBOutlet var usernameRequirementsIndicatorViews: [UIView]!
  
  @IBOutlet var usernameRequirementsTitleLabels: [UILabel]!
  
  
  //MARK:- Constraints
  @IBOutlet weak var signUpButtonBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var usernameProgressWidthConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var emailProgressWidthConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var passwordProgressWidthConstraint: NSLayoutConstraint!
  
  
  //MARK:- IB Actions
  @IBAction func showPasswordAction(_ sender: Any) {
    changePasswordTextFieldSecureInput()
  }
  
  @IBAction func termsAction(_ sender: Any) {
    presenter.handleTermsAction()
  }
  
  @IBAction func privacyPolicyAction(_ sender: Any) {
    presenter.handlePrivacyPolicyAction()
  }
  
  @IBAction func loginAction(_ sender: Any) {
    presenter.handleLoginAction()
  }
  
  @IBAction func signUpAction(_ sender: Any) {
    presenter.handleSignUpAction()
  }
  
  @IBAction func textFieldEditingChangedAction(_ sender: UITextField) {
    let textValue = sender.text ?? ""
    
    if sender == emailTextField {
      presenter.handleValueChangedForField(.email, value: textValue)
      emailProgressWidthConstraint.constant = emailTextField.widthForText()
    }
    
    if sender == usernameTextField {
      presenter.handleValueChangedForField(.username, value: textValue)
      usernameProgressWidthConstraint.constant = usernameTextField.widthForText()
    }
    if sender == passwordTextField {
      presenter.handleValueChangedForField(.password, value: textValue)
      passwordProgressWidthConstraint.constant = passwordTextField.widthForText()
    }
  }
  
  //MARK:- Properties
  
  fileprivate let passwordRequirements: [Registration.PasswordRequirements] = [
      .oneSpecialChar,
      .oneUppercaseChar,
      .oneNumber,
      .minLength
  ]
  
  fileprivate let usernameRequirements: [Registration.UsernameRequirements] = [
    .allowedChars,
    .minLength
  ]
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
  //MARK:- Lyfecycle
  
  override func viewDidLoad() {
    emailTextField.delegate = self
    usernameTextField.delegate = self
    passwordTextField.delegate = self
    setupView()
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    subscribeKeyboardNotications()
    super.viewDidAppear(animated)
    usernameTextField.becomeFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setShowPasswordButtonState()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    view.endEditing(true)
    unsubscribeKeyboardNotications()
    super.viewWillDisappear(animated)
  }
}


extension RegistrationViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    signUpButtonBottomConstraint.constant = 0.0

    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }

  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    signUpButtonBottomConstraint.constant = bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}

//MARK:- UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTextField {
      emailTextField.becomeFirstResponder()
    }
    
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    }
    
    if textField == passwordTextField {
      presenter.handleSignUpAction()
    }
    
    return true
  }
}

//MARK: - RegistrationModuleView API

extension RegistrationViewController: RegistrationViewControllerApi {
  func showUsernameValidation(_ validationResult: [Registration.UsernameRequirements : Bool]) {
    usernameRequirements.enumerated().forEach {
      let validated = validationResult[$0.element] ?? false
      
      usernameRequirementsIndicatorViews[$0.offset].backgroundColor = validated ? UIConstants.Colors.activeRequirementIndicator :
        UIConstants.Colors.inactiveRequirementIndicator
      
      usernameRequirementsTitleLabels[$0.offset].textColor = validated ? UIConstants.Colors.activeRequirementIndicator :
        UIConstants.Colors.inactiveRequirementIndicator
    }
  }
  
  func showPasswordValidation(_ validationResult: [Registration.PasswordRequirements : Bool]) {
    
    passwordRequirements.enumerated().forEach {
      let validated = validationResult[$0.element] ?? false
      
      passwordRequirementsIndicatorViews[$0.offset].backgroundColor = validated ? UIConstants.Colors.activeRequirementIndicator :
        UIConstants.Colors.inactiveRequirementIndicator
      
      passwordRequirementsTitleLabels[$0.offset].textColor = validated ? UIConstants.Colors.activeRequirementIndicator :
        UIConstants.Colors.inactiveRequirementIndicator
    }
  }
  
  func presentDimOverlayViewHidden(_ hidden: Bool) {
    dimView.isHidden = hidden
  }
  
  func showPlaceholder(for field: Registration.InputFields, hidden: Bool) {
    switch field {
    case .email:
      emailPlaceholderLabel.isHidden = hidden
      emailTitleLabel.isHidden = !hidden
    case .username:
      usernamePlaceholderLabel.isHidden = hidden
      usernameTitleLabel.isHidden = !hidden
    case .password:
      passwordPlaceholderLabel.isHidden = hidden
      passwordTitleLabel.isHidden = !hidden
    }
  }
}

// MARK: - RegistrationModuleView Viper Components API
fileprivate extension RegistrationViewController {
  var presenter: RegistrationPresenterApi {
      return _presenter as! RegistrationPresenterApi
  }
}

//MARK:- Helpers

extension RegistrationViewController {
  fileprivate func changePasswordTextFieldSecureInput() {
    passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    
    //calculate after new secure state is rendered
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      strongSelf.passwordProgressWidthConstraint.constant = strongSelf.passwordTextField.widthForText()
    }
    
    setShowPasswordButtonState()
  }
  
  fileprivate func setShowPasswordButtonState() {
    let isSecured = passwordTextField.isSecureTextEntry
    let image: UIImage = isSecured ?
          UIImage(imageLiteralResourceName: "Registration-ShowPassword-unselected"):
          UIImage(imageLiteralResourceName: "Registration-ShowPassword-selected")
    showPasswordButton.setImage(image, for: .normal)
  }
  
  fileprivate func setupView() {
    backgroundImageView.image = AssetsManager.Background.auth.asset
    registerButton.clipsToBounds = true
    registerButton.layer.cornerRadius = registerButton.frame.size.height * 0.5
    
    emailProgressWidthConstraint.constant = emailTextField.widthForText()
    passwordProgressWidthConstraint.constant = passwordTextField.widthForText()
    usernameProgressWidthConstraint.constant = usernameTextField.widthForText()
    
    passwordRequirementsIndicatorViews.forEach {
      $0.setCornersToCircle()
    }
    
    usernameRequirementsIndicatorViews.forEach {
      $0.setCornersToCircle()
    }
    
    view.addEndEditingTapGesture()
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let activeRequirementIndicator = UIColor.signUpGreen
    static let inactiveRequirementIndicator = UIColor.signUpBlueTitle
    
    static let button = [
      UIColor(red: 232.0 / 255.0, green: 128.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0),
      UIColor(red: 174.0 / 255.0, green: 138.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)]
    
    static let background = [
      UIColor(red: 242.0 / 255.0, green: 198.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0),
      UIColor(red: 249.0 / 255.0, green: 162.0 / 255.0, blue: 194.0 / 255.0, alpha: 1.0)]
  }
}
