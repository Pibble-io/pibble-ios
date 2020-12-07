//
//  ResetPasswordWithEmailModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: ResetPasswordWithEmailModuleView Class
final class ResetPasswordWithEmailViewController: ViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var emailPlaceholderLabel: UILabel!
  @IBOutlet weak var emailTitleLabel: UILabel!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var resetPasswordButton: UIButton!
  
  //MARK:- IBOutlet Constraints
  
  @IBOutlet weak var backgroundViewBottomContraint: NSLayoutConstraint!
  @IBOutlet weak var emailProgressWidthConstraint: NSLayoutConstraint!
  
  //MARK:-  IBActions
  
  
  @IBAction func emailTextFieldEditingChangedAction(_ sender: UITextField) {
    emailProgressWidthConstraint.constant = sender.widthForText()
    presenter.handleEmailValueChanged(sender.text ?? "")
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func resetPasswordAction(_ sender: Any) {
    presenter.handleResetPasswordAction()
  }
  
  override func viewDidLoad() {
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

//MARK: - ResetPasswordWithEmailModuleView API
extension ResetPasswordWithEmailViewController: ResetPasswordWithEmailViewControllerApi {
  func setInteractionEnabled(_ enabled: Bool) {
    resetPasswordButton.isEnabled = enabled
  }
  
  
  func showPlaceholderForEmail(hidden: Bool) {
    emailPlaceholderLabel.isHidden = hidden
    emailTitleLabel.isHidden = !hidden
  }
}

// MARK: - ResetPasswordWithEmailModuleView Viper Components API
fileprivate extension ResetPasswordWithEmailViewController {
    var presenter: ResetPasswordWithEmailPresenterApi {
        return _presenter as! ResetPasswordWithEmailPresenterApi
    }
}


extension ResetPasswordWithEmailViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    backgroundViewBottomContraint.constant = 0.0
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    backgroundViewBottomContraint.constant = bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}


//MARK:- Helpers

fileprivate extension ResetPasswordWithEmailViewController {
  func setupView() {
    backgroundImageView.image = AssetsManager.Background.auth.asset
    
    resetPasswordButton.clipsToBounds = true
    resetPasswordButton.layer.cornerRadius = resetPasswordButton.frame.size.height * 0.5
    emailProgressWidthConstraint.constant = emailTextField.widthForText()
    view.addEndEditingTapGesture()
  }
}


fileprivate enum UIConstants {
  enum Colors {
    static let button = UIColor.purpleButtonGradient
    static let background = UIColor.pinkBackgroundGradient
  }
}

