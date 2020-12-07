//
//  SignInModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: SignInModuleView Class
final class SignInViewController: ViewController {
 
  //MARK:- IBOutlets
 
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signInButton: UIButton!
  
  @IBOutlet weak var emailPlaceholderLabel: UILabel!
  
  @IBOutlet weak var passwordPlaceholderLabel: UILabel!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var inputsBackgroundView: UIView!
  
  @IBOutlet weak var navigationBarView: UIView!
  @IBOutlet weak var emailTitleLabel: UILabel!
  @IBOutlet weak var passwordTitleLabel: UILabel!
  
  @IBOutlet weak var showPasswordButton: UIButton!
  
  @IBOutlet weak var forgotPasswordRoundView: UIView!
  
  //MARK:- Constraints
  
  @IBOutlet weak var signUpButtonBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var emailProgressWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var passwordProgressWidthConstraint: NSLayoutConstraint!
  
  //MARK:- IB Actions
  
  @IBAction func showPasswordAction(_ sender: Any) {
    changePasswordTextFieldSecureInput()
  }
  
  
  @IBAction func signUpAction(_ sender: Any) {
     presenter.handleSignUpAction()
  }
  
  @IBAction func signInAction(_ sender: Any) {
    presenter.handleSignInAction()
  }
  
  @IBAction func textFieldEditingChangedAction(_ sender: UITextField) {
    let textValue = sender.text ?? ""
    
    if sender == emailTextField {
      presenter.handleValueChangedForField(.login, value: textValue)
      emailProgressWidthConstraint.constant = emailTextField.widthForText()
    }
    
    if sender == passwordTextField {
      presenter.handleValueChangedForField(.password, value: textValue)
      passwordProgressWidthConstraint.constant = passwordTextField.widthForText()
    }
  }
  
  @IBAction func restorePasswordAction(_ sender: Any) {
    presenter.handleRestorePasswordAction()
  }
  
  //MARK:- Lyfecycle
  
  override func viewDidLoad() {
    emailTextField.delegate = self
    passwordTextField.delegate = self
    setupView()
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    subscribeKeyboardNotications()
    super.viewDidAppear(animated)
    emailTextField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    unsubscribeKeyboardNotications()
    super.viewWillDisappear(animated)
  }
  
  //MARK:- Properties
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
}

//MARK: - SignInModuleView API

extension SignInViewController: SignInViewControllerApi {
  func presentDimOverlayViewHidden(_ hidden: Bool) {
    signInButton.isEnabled = hidden
  }
  
  func showPlaceholder(for field: SignIn.InputFields, hidden: Bool) {
    switch field {
    case .login:
      emailPlaceholderLabel.isHidden = hidden
      emailTitleLabel.isHidden = !hidden
    case .password:
      passwordPlaceholderLabel.isHidden = hidden
      passwordTitleLabel.isHidden = !hidden
    }
  }
}

// MARK: - SignInModuleView Viper Components API

fileprivate extension SignInViewController {
    var presenter: SignInPresenterApi {
        return _presenter as! SignInPresenterApi
    }
}

extension SignInViewController: KeyboardNotificationsDelegateProtocol {
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

extension SignInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    }
    
    if textField == passwordTextField {
      presenter.handleSignInAction()
    }
    
    return true
  }
}


//MARK:- Helpers

extension SignInViewController {
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
      UIImage(imageLiteralResourceName: "SignIn-ShowPassword-unselected"):
      UIImage(imageLiteralResourceName: "SignIn-ShowPassword-selected")
    showPasswordButton.setImage(image, for: .normal)
  }
  
  fileprivate func setupView() {
    backgroundImageView.image = AssetsManager.Background.auth.asset
    signInButton.clipsToBounds = true
    signInButton.layer.cornerRadius = signInButton.frame.size.height * 0.5
    
    emailProgressWidthConstraint.constant = emailTextField.widthForText()
    passwordProgressWidthConstraint.constant = passwordTextField.widthForText()
    view.addEndEditingTapGesture()
    
    forgotPasswordRoundView.setCornersToCircle()
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let button = [
      UIColor(red: 232.0 / 255.0, green: 128.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0),
      UIColor(red: 174.0 / 255.0, green: 138.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)]
    
    static let background = [
      UIColor(red: 242.0 / 255.0, green: 198.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0),
      UIColor(red: 249.0 / 255.0, green: 162.0 / 255.0, blue: 194.0 / 255.0, alpha: 1.0)]
  }
}





