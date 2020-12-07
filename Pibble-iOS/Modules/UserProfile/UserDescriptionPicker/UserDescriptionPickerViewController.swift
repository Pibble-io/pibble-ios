//
//  UserDescriptionPickerViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: UserDescriptionPickerView Class
final class UserDescriptionPickerViewController: ViewController {
  @IBOutlet weak var inputTextView: UITextView!
  @IBOutlet weak var inputTextBackgroundView: UIView!
  
  @IBOutlet weak var hideButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  @IBOutlet weak var descriptionCountLabel: UILabel!
  
  @IBOutlet weak var websiteTextField: UITextField!
  
  @IBOutlet weak var firstNameTextField: UITextField!
  
  @IBOutlet weak var lastNameTextField: UITextField!
  //MARK:- IBOutlets LayoutConstraints
  
  @IBOutlet weak var textBackgroundViewBottomConstraint: NSLayoutConstraint!
  
  //MARK:- IBActions
  
  @IBAction func firstNameEditingChangedAction(_ sender: UITextField) {
    presenter.handleFirstNameTextChange(sender.text ?? "")
  }
  
  @IBAction func lastNameEditingChangedAction(_ sender: UITextField) {
    presenter.handleLastNameTextChange(sender.text ?? "")
  }
  
  @IBAction func websiteEditingChangedAction(_ sender: UITextField) {
    presenter.handleWebsiteTextChange(sender.text ?? "")
  }
  
  
  @IBAction func doneAction(_ sender: Any) {
    presenter.handleDoneAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeKeyboardNotications()
    inputTextView.becomeFirstResponder()
    
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeKeyboardNotications()
  }
}

//MARK: - UserDescriptionPickerView API
extension UserDescriptionPickerViewController: UserDescriptionPickerViewControllerApi {
  func setFirstNameText(_ text: String) {
    firstNameTextField.text = text
  }
  
  func setLastNameText(_ text: String) {
    lastNameTextField.text = text
  }
  
  func setWebsiteText(_ text: String) {
    websiteTextField.text = text
  }
  
  func setDesciptionLimitText(_ text: String) {
    descriptionCountLabel.text = text
  }
  
  func setDescriptionText(_ text: String) {
    inputTextView.text = text
  }
}

// MARK: - UserDescriptionPickerView Viper Components API
fileprivate extension UserDescriptionPickerViewController {
    var presenter: UserDescriptionPickerPresenterApi {
        return _presenter as! UserDescriptionPickerPresenterApi
    }
}

//MARK:- Helpers

extension UserDescriptionPickerViewController {
  func setupView() {
    inputTextView.delegate = self
  }
  
  func setupAppearance() {
    
  }
}

//MARK:- UITextViewDelegate

extension UserDescriptionPickerViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    presenter.handleDescriptionTextChange(textView.text)
  }
}

//MARK:- KeyboardNotificationsDelegateProtocol

extension UserDescriptionPickerViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    textBackgroundViewBottomConstraint.constant = bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    textBackgroundViewBottomConstraint.constant = 0.0
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}

fileprivate enum UIConstants {
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 150.0
    static let inputTextViewMinHeight: CGFloat = 70.0
  }
}
