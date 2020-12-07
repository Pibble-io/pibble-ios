//
//  VerifyCodeModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: VerifyCodeModuleView Class
final class VerifyCodeViewController: ViewController {
  
  //MARK:- IBOutlets
  @IBOutlet weak var navigationBarTitleLabel: UILabel!
  
  @IBOutlet weak var backgroundScrollView: UIScrollView!
  
  @IBOutlet var codeTextFields: [UITextFieldWithoutCursor]!
  
  @IBOutlet weak var resendButton: UIButton!
  
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var backButton: UIButton!
  
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
}

extension VerifyCodeViewController: KeyboardNotificationsDelegateProtocol {
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

extension VerifyCodeViewController {
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

//MARK: - VerifyCodeModuleView API

extension VerifyCodeViewController: VerifyCodeViewControllerApi {
  func setInformationTitles(_ attributedTitle: NSAttributedString, attributedSubtitle: NSAttributedString) {
    titleLabel.attributedText = attributedTitle
    subtitleLabel.attributedText = attributedSubtitle
  }
  
  func setNavigationBarTitle(_ text: String) {
    navigationBarTitleLabel.text = text
  }
  
  func setPhoneNumber(_ value: String) {
    subtitleLabel.text = value
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
      resendButton.setTitleForAllStates(VerifyCode.Strings.resendButtonTitleWith(value))
      resendButton.layoutIfNeeded()
    }
  }
  
  func setBackButtonHidden(_ hidden: Bool) {
    backButton.isHidden = hidden
  }
  
  func setResendButtonEnabled(_ enabled: Bool) {
    resendButton.isEnabled = enabled
    if enabled {
      UIView.performWithoutAnimation {
        resendButton.setTitleForAllStates(VerifyCode.Strings.resendButtonTitleWith(nil))
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
  
  func showVerificationFailedAlert() {
    let alertController = UIAlertController(title: VerifyCode.Strings.VerificationFailAlert.title.localize(),
                                            message: VerifyCode.Strings.VerificationFailAlert.message.localize(),
                                            safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let okAction = UIAlertAction(title: VerifyCode.Strings.VerificationFailAlert.okAction.localize(),
                                 style: .default) { [weak self] (action) in
                                  self?.presenter.handleVerificationErrorAction()
    }
    
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
}

// MARK: - VerifyCodeModuleView Viper Components API
fileprivate extension VerifyCodeViewController {
    var presenter: VerifyCodePresenterApi {
        return _presenter as! VerifyCodePresenterApi
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

