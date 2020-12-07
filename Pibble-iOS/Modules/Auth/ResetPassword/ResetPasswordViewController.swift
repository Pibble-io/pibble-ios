//
//  ResetPasswordModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: ResetPasswordModuleView Class
final class ResetPasswordViewController: ViewController {
  
  //MARK:- IBOutlets
  
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordConfirmTextField: UITextField!
  
  @IBOutlet weak var resetPasswordButton: UIButton!
  
  @IBOutlet weak var passwordPlaceholderLabel: UILabel!
  @IBOutlet weak var passwordConfirmPlaceholderLabel: UILabel!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var inputsBackgroundView: UIView!
  
  @IBOutlet weak var navigationBarView: UIView!
  @IBOutlet weak var passwordTitleLabel: UILabel!
  @IBOutlet weak var passwordConfirmTitleLabel: UILabel!
  
  //MARK:- Constraints
  
  @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var emailProgressWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var passwordConfirmProgressWidthConstraint: NSLayoutConstraint!
  
  //MARK:- IB Actions
  
  @IBAction func resetPasswordAction(_ sender: Any) {
    presenter.handleResetPasswordAction()
  }
  
  @IBAction func textFieldEditingChangedAction(_ sender: UITextField) {
    let textValue = sender.text ?? ""
    
    if sender == passwordTextField {
      presenter.handleValueChangedForField(.password, value: textValue)
      emailProgressWidthConstraint.constant = passwordTextField.widthForText()
    }
    
    if sender == passwordConfirmTextField {
      presenter.handleValueChangedForField(.passwordConfirm, value: textValue)
      passwordConfirmProgressWidthConstraint.constant = passwordConfirmTextField.widthForText()
    }
  }
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Lyfecycle
  
  override func viewDidLoad() {
    passwordTextField.delegate = self
    passwordConfirmTextField.delegate = self
    setupView()
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    subscribeKeyboardNotications()
    super.viewDidAppear(animated)
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

//MARK: - ResetPasswordModuleView API

extension ResetPasswordViewController: ResetPasswordViewControllerApi {
  func setInteractionEnabled(_ enabled: Bool) {
    resetPasswordButton.isEnabled = enabled
  }
  
  func showPlaceholder(for field: ResetPassword.InputFields, hidden: Bool) {
    switch field {
    case .password:
      passwordPlaceholderLabel.isHidden = hidden
      passwordTitleLabel.isHidden = !hidden
    case .passwordConfirm:
      passwordConfirmPlaceholderLabel.isHidden = hidden
      passwordConfirmTitleLabel.isHidden = !hidden
    }
  }
}

// MARK: - ResetPasswordModuleView Viper Components API

fileprivate extension ResetPasswordViewController {
    var presenter: ResetPasswordPresenterApi {
        return _presenter as! ResetPasswordPresenterApi
    }
}

extension ResetPasswordViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    containerViewBottomConstraint.constant = 0.0
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    containerViewBottomConstraint.constant = bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}

//MARK:- UITextFieldDelegate

extension ResetPasswordViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == passwordTextField {
      passwordConfirmTextField.becomeFirstResponder()
    }
    
    if textField == passwordConfirmTextField {
      presenter.handleResetPasswordAction()
    }
    
    return true
  }
}

//MARK:- Helpers

extension ResetPasswordViewController {
  fileprivate func setupView() {
    backgroundImageView.image = AssetsManager.Background.auth.asset
    resetPasswordButton.clipsToBounds = true
    resetPasswordButton.layer.cornerRadius = resetPasswordButton.frame.size.height * 0.5
    
    emailProgressWidthConstraint.constant = passwordTextField.widthForText()
    passwordConfirmProgressWidthConstraint.constant = passwordConfirmTextField.widthForText()
    view.addEndEditingTapGesture()
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





