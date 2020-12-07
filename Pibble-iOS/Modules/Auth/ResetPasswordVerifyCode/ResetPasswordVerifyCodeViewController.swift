//
//  ResetPasswordVerifyCodeModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: ResetPasswordVerifyCodeModuleView Class
final class ResetPasswordVerifyCodeViewController: ViewController {
  
  //MARK:- IBOutlets
  @IBOutlet weak var backgroundScrollView: UIScrollView!
  
  @IBOutlet var codeTextFields: [UITextFieldWithoutCursor]!
  
  @IBOutlet weak var resendButton: UIButton!
  
  @IBOutlet weak var phoneNumberLabel: UILabel!
  @IBOutlet weak var messageLabelLabel: UILabel!
  
  @IBOutlet weak var navBarTitleLabel: UILabel!
  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  //MARK:- IBOutlet constraints
  
  @IBOutlet weak var resendButtonBottomConstraint: NSLayoutConstraint!
  
  
  //MARK:- IBOutlet actions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  @IBAction func resendCodeAction(_ sender: Any) {
    presenter.handeResentCodeAction()
  }
  
  @IBAction func codeTextFieldEditingChanged(_ sender: UITextFieldWithoutCursor) {
    let text = codeTextFields
      .map { return $0.text ?? "" }.joined()
    
    presenter.codeValueChanged(text)
    if let idx = codeTextFields.index(of: sender) {
      let nextIdx = idx +  1
      if nextIdx < codeTextFields.count {
        codeTextFields[nextIdx].becomeFirstResponder()
      }
    }
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    
    setupView()
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    subscribeKeyboardNotications()
    codeTextFields.first?.becomeFirstResponder()
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


extension ResetPasswordVerifyCodeViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    backgroundScrollView.contentInset.bottom = 0.0
    resendButtonBottomConstraint.constant = UIConstants.Constraints.bottomButton
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    backgroundScrollView.contentInset.bottom = bottomInsets
    resendButtonBottomConstraint.constant = UIConstants.Constraints.bottomButtonToKeyboard + bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}

//MARK:- Helpers

extension ResetPasswordVerifyCodeViewController {
  fileprivate func textFieldDeleteEventHandler(sender: UITextFieldWithoutCursor) {
    if let idx = codeTextFields.index(of: sender) {
      let nextIdx = idx -  1
      if nextIdx >= 0 {
        codeTextFields[nextIdx].text = ""
        let text = codeTextFields
          .map { return $0.text ?? "" }.joined()
    
        presenter.codeValueChanged(text)
        codeTextFields[nextIdx].becomeFirstResponder()
      }
    }
  }
  
  fileprivate func setupView() {
    resendButton.layer.cornerRadius = resendButton.bounds.height * 0.5
    resendButton.layer.masksToBounds = true
    
    backgroundImageView.image = AssetsManager.Background.auth.asset
    codeTextFields.forEach {
      $0.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
      $0.textAlignment = NSTextAlignment.center
      $0.setAttrubutedTextPlaceholder("•")
    }
    
    codeTextFields.forEach {
      $0.deleteEventHandler = textFieldDeleteEventHandler
    }
  }
}

//MARK: - ResetPasswordVerifyCodeModuleView API
extension ResetPasswordVerifyCodeViewController: ResetPasswordVerifyCodeViewControllerApi {
  func showVerificationFailedAlert() {
    let alertController = UIAlertController(title: ResetPasswordVerifyCode.Strings.VerificationFailAlert.title.localize(),
                                            message: ResetPasswordVerifyCode.Strings.VerificationFailAlert.message.localize(),
                                            safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let okAction = UIAlertAction(title: ResetPasswordVerifyCode.Strings.VerificationFailAlert.okAction.localize(),
                                 style: .default) { [weak self] (action) in
                                  self?.presenter.handleVerificationErrorAction()
    }
    
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func setNavBarTitle(_ value: String) {
    navBarTitleLabel.text = value
  }
  
  func setTargetAddress(_ value: String) {
    phoneNumberLabel.text = value
  }
  
  func setEditing(_ editing: Bool) {
    if editing {
      view.endEditing(true)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        self?.codeTextFields.first?.becomeFirstResponder()
      }
    } else {
      view.endEditing(true)
    }
  }
  
  func setResendCounterTitleValue(_ value: String) {
    UIView.performWithoutAnimation {
      resendButton.setTitleForAllStates(ResetPasswordVerifyCode.Strings.resendButtonTitleWith(value))
      resendButton.layoutIfNeeded()
    }
  }
  
  func setResendButtonEnabled(_ enabled: Bool) {
    resendButton.isEnabled = enabled
    if enabled {
      UIView.performWithoutAnimation {
        resendButton.setTitleForAllStates(ResetPasswordVerifyCode.Strings.resendButtonTitleWith(nil))
        resendButton.layoutIfNeeded()
      }
    }
  }
  
  func presentDimOverlayViewHidden(_ hidden: Bool) {
    dimView.isHidden = hidden
    view.isUserInteractionEnabled = hidden
  }
  
  func setCodeValueEmpty() {
    codeTextFields.forEach { $0.text = "" }
  }
  
}

// MARK: - ResetPasswordVerifyCodeModuleView Viper Components API

fileprivate extension ResetPasswordVerifyCodeViewController {
    var presenter: ResetPasswordVerifyCodePresenterApi {
        return _presenter as! ResetPasswordVerifyCodePresenterApi
    }
}



fileprivate enum UIConstants {
  enum Constraints {
    static let bottomButton: CGFloat = 30.0
    static let bottomButtonToKeyboard: CGFloat = 20.0
    
  }
  enum Colors {
    static let button = UIColor.greyButtonGradient
    static let background = UIColor.pinkBackgroundGradient
  }
}

