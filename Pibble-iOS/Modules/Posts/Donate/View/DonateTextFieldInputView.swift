//
//  DonateTextFieldInputView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 10.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//


import UIKit

class DonateTextFieldInputView: NibLoadingView {
  //MARK:- IBOutlets
  
  @IBOutlet fileprivate weak var inputsContainerView: UIView!
  
  @IBOutlet fileprivate weak var upVoteIconImageView: UIImageView!
  @IBOutlet fileprivate weak var upVoteTitleLabel: UILabel!
  @IBOutlet fileprivate weak var currencyLabel: UILabel!
  
  @IBOutlet fileprivate weak var minButton: UIButton!
  @IBOutlet fileprivate weak var maxButton: UIButton!
  
  @IBOutlet weak var inputTextField: UITextField!
  
  //MARK:- IBActions
  
  @IBAction func switchCurrencyAction(_ sender: Any) {
    delegate?.handleCurrencySwitch()
  }
  
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
  
  weak var delegate: DonateTextFieldInputViewDelegateProtocol?
  
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
    
    inputTextField.layer.cornerRadius = UIConstants.CornerRadius.inputTextField
    inputTextField.clipsToBounds = true
    inputTextField.layer.borderColor = UIConstants.Colors.inputTextFieldBorder.cgColor
    inputTextField.layer.borderWidth = 1.0
  }
  
  //MARK:- Public methods
  
  func beginEditing() {
    inputTextField.becomeFirstResponder()
  }
  
  func setViewModel(_ vm: Donate.UpVoteViewModel, animated: Bool) {
    let zeroValue = Donate.Strings.zeroValue.localize()
    
    if zeroValue == vm.currentUpVoteAmount {
      inputTextField.placeholder = zeroValue
      inputTextField.text = ""
    } else {
      inputTextField.text = vm.currentUpVoteAmount
    }
    
    currencyLabel.text = vm.currentUpVoteCurrency
    currencyLabel.textColor = vm.currentUpVoteCurrencyColor
  }
  
  func setCurrencyForViewModel(_ vm: Donate.UpVoteViewModel, animated: Bool) {
    currencyLabel.text = vm.currentUpVoteCurrency
  }
}

//MARK:- Helpers

extension DonateTextFieldInputView {
  @objc func doneEditing() {
    inputTextField.endEditing(true)
    delegate?.handleDidEndEditing()
  }
}

extension DonateTextFieldInputView: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    delegate?.handleDidEndEditing()
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  enum CornerRadius {
    static let inputTextField: CGFloat = 11
  }
  
  enum Colors {
    static let minmaxButtonsBorder = UIColor.gray112
    static let doneButton = UIColor.bluePibble
    
    static let inputTextFieldBorder = UIColor.gray112
  }
}
