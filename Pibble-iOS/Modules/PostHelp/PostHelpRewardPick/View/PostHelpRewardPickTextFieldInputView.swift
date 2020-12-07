//
//  PostHelpRewardPickTextFieldInputView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 10.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class PostHelpRewardPickTextFieldInputView: NibLoadingView {
  //MARK:- IBOutlets
  
  @IBOutlet fileprivate weak var inputsContainerView: UIView!
  
  @IBOutlet weak var limitationsLabel: UILabel!
  
  @IBOutlet fileprivate weak var currencyLabel: UILabel!
  @IBOutlet weak var currentBalanceLabel: UILabel!
  
  @IBOutlet weak var budgetInputBackgroundView: UIView!
  
  @IBOutlet fileprivate weak var minButton: UIButton!
  @IBOutlet fileprivate weak var maxButton: UIButton!
  
  @IBOutlet weak var inputTextField: UITextField!
  
  //MARK:- IBActions
  @IBAction func inputTextChangeAction(_ sender: Any) {
    delegate?.handleChangeValue(inputTextField.text ?? "")
  }
 
  @IBAction fileprivate func minAction(_ sender: Any) {
    delegate?.handleChangeValueToMin()
    inputTextField.endEditing(true)
    delegate?.handleDidEndEditing()
  }
  
  @IBAction fileprivate func maxAction(_ sender: Any) {
    delegate?.handleChangeValueToMax()
    inputTextField.endEditing(true)
    delegate?.handleDidEndEditing()
  }
  
  //MARK:- Delegate
  
  weak var delegate: PostHelpRewardPickTextFieldInputViewDelegateProtocol?
  
  //MARK:- Overrides
  
  override func setupView() {
    inputTextField.delegate = self
    
    
    let keyboardDoneButtonView = UIToolbar()
    keyboardDoneButtonView.sizeToFit()
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: self,
                                     action: #selector(self.doneEditing))
    
    let attributes = [NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 17),
                      NSAttributedString.Key.foregroundColor: UIConstants.Colors.doneButton]
    
    doneButton.setTitleTextAttributes(attributes, for: .normal)
    doneButton.setTitleTextAttributes(attributes, for: .selected)
    doneButton.setTitleTextAttributes(attributes, for: .disabled)
    doneButton.setTitleTextAttributes(attributes, for: .highlighted)
    
    keyboardDoneButtonView.items = [space, doneButton]
    
    inputTextField.inputAccessoryView = keyboardDoneButtonView
    [minButton, maxButton].forEach {
      $0?.layer.cornerRadius =  ($0?.bounds.height ?? 0.0) * 0.5
      $0?.clipsToBounds = true
      $0?.layer.borderWidth = 1.0
      $0?.layer.borderColor = UIConstants.Colors.minmaxButtonsBorder.cgColor
    }
    
    budgetInputBackgroundView.layer.cornerRadius = UIConstants.CornerRadius.inputsBackgroundView
    budgetInputBackgroundView.layer.borderWidth = 1.0
    budgetInputBackgroundView.layer.borderColor = UIConstants.Colors.inputsBackgroundViewBorder.cgColor
  }
  
  //MARK:- Public methods
  
  func beginEditing() {
    inputTextField.becomeFirstResponder()
  }
  
  func setViewModel(_ vm: PostHelpRewardPick.PostHelpRewardPickViewModel, animated: Bool) {
    currencyLabel.text = vm.currentPostHelpRewardPickCurrency
    inputTextField.text = vm.currentPostHelpRewardPickAmount
    
    limitationsLabel.text = vm.rewardLimits
    currentBalanceLabel.text = vm.currentBalance
  }
}

//MARK:- Helpers

extension PostHelpRewardPickTextFieldInputView {
  @objc func doneEditing() {
    inputTextField.endEditing(true)
    delegate?.handleDidEndEditing()
  }
}

extension PostHelpRewardPickTextFieldInputView: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    delegate?.handleDidEndEditing()
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  enum CornerRadius {
    static let inputsBackgroundView: CGFloat = 6.0
  }
  
  enum Colors {
    static let minmaxButtonsBorder = UIColor.gray112
    static let doneButton = UIColor.bluePibble
    
    static let inputsBackgroundViewBorder = UIColor.gray168
  }
}
