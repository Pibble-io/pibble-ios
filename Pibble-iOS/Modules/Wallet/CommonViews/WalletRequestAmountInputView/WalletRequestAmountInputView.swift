//
//  WalletRequestAmountInputView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 30.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletRequestAmountInputView: NibLoadingView {
  //MARK:- IBOutlets
  
  @IBOutlet fileprivate weak var titleLabel: UILabel!
  @IBOutlet fileprivate weak var mainCurrencyAmountTextField: UITextFieldWithoutCursor!
  @IBOutlet fileprivate weak var mainCurrencyLabel: UILabel!
  
  @IBOutlet fileprivate weak var secondaryCurrencyLabel: UILabel!
  @IBOutlet fileprivate weak var secondaryCurrenctAmountLabel: UILabel!
  @IBOutlet fileprivate weak var nextButton: UIButton!
  
  @IBOutlet fileprivate weak var swapButton: UIButton!
  @IBOutlet fileprivate var contentView: UIView!
  
  @IBOutlet weak var gradientView: GradientView!
  
  @IBOutlet weak var nextCurrencyButton: UIButton!
  
  @IBOutlet weak var availableAmountContainerView: UIView!
  @IBOutlet weak var availableAmountLabel: UILabel!
  
  //MARK:- IBActions
  
  @IBAction fileprivate func mainCurrencyValueChanged(_ sender: UITextField) {
    guard let text = sender.text else {
      return
    }
    
    guard text.count < UIConstants.inputMaxCharLength else {
      let indexEndOfText = text.index(text.startIndex, offsetBy: UIConstants.inputMaxCharLength)
      let cutText = String(text[..<indexEndOfText])
      sender.text = cutText
      inputValueChangedActionHandler?(self, cutText)
      return
    }
    
    inputValueChangedActionHandler?(self, text)
  }
  
  @IBAction func nextCurrencyAction(_ sender: Any) {
    let empty = ""
    mainCurrencyAmountTextField.text = empty
    inputValueChangedActionHandler?(self, empty)
    nextCurrencyActionHandler?(self)
  }
  
  @IBAction fileprivate func swapCurrencyAction(_ sender: Any) {
    let empty = ""
    mainCurrencyAmountTextField.text = empty
    inputValueChangedActionHandler?(self, empty)
    swapCurrencyActionHandler?(self)
  }
  
  @IBAction fileprivate func nextAction(_ sender: Any) {
    nextActionHandler?(self)
  }
  
  //MARK:- Setup overrides
  
  override func setupView() {
    mainCurrencyAmountTextField.text = ""
    mainCurrencyLabel.text = ""
    secondaryCurrenctAmountLabel.text = ""
    secondaryCurrencyLabel.text = ""
    let placeholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    mainCurrencyAmountTextField.attributedPlaceholder = placeholder
    
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = UIConstants.contentViewCornerRadius
  
    gradientView.addBackgroundGradientWith(UIConstants.Colors.backgroundGradient, direction: .diagonalLeft)
    
    nextButton.clipsToBounds = true
    nextButton.layer.cornerRadius = nextButton.bounds.height * 0.5
    nextButton.layer.borderWidth = UIConstants.nextButtonBorderWidth
    nextButton.layer.borderColor = UIConstants.Colors.nextButtonBorder.cgColor
  }
  
  //MARK:- Action Handlers
  
  var nextActionHandler: ((WalletRequestAmountInputView)-> Void)?
  var swapCurrencyActionHandler: ((WalletRequestAmountInputView)-> Void)?
  var inputValueChangedActionHandler: ((WalletRequestAmountInputView, String)-> Void)?
  var nextCurrencyActionHandler: ((WalletRequestAmountInputView)-> Void)?
  
  func setInputAsFirstResponder() {
    mainCurrencyAmountTextField.becomeFirstResponder()
  }
  
  func setNextButtonEnabled(_ enabled: Bool) {
    nextButton.isEnabled = enabled
    nextButton.alpha = enabled ? 1.0 : 0.35
  }
  
  func setViewModel(_ vm: WalletRequestAmountInputViewModelProtocol) {
    titleLabel.text = vm.title
    mainCurrencyLabel.text = vm.mainCurrency
    nextButton.setTitleForAllStates(vm.nextButtonTitle)
    
    secondaryCurrenctAmountLabel.text = vm.secondaryCurrencyAmount
    secondaryCurrencyLabel.text = vm.secondaryCurrency
    nextCurrencyButton.isHidden = !vm.nextCurrencySwitchIsActive
    swapButton.isEnabled = vm.swapCurrenciesIsActive
    swapButton.setImage(vm.swapCurrenciesButtonStyle.buttonImage, for: .normal)
    
    let inputKeyBoardType: UIKeyboardType = vm.needsDecimalInput ? .decimalPad : .numberPad
    
    if mainCurrencyAmountTextField.keyboardType != inputKeyBoardType {
      mainCurrencyAmountTextField.keyboardType = inputKeyBoardType
      mainCurrencyAmountTextField.reloadInputViews()
    }
    
    availableAmountContainerView.isHidden = vm.availableAmount == nil
    availableAmountLabel.text = vm.availableAmount ?? ""
  }
}

fileprivate enum UIConstants {
  static let inputMaxCharLength: Int = 10
  static let nextButtonBorderWidth: CGFloat = 1.0
 
  static let contentViewCornerRadius: CGFloat = 5.0
  
  enum Colors {
    static let nextButtonBorder = UIColor.white
    static let backgroundGradient = UIColor.blueGradient
  }
}

extension SwapCurrenciesButtonStyle {
  fileprivate var buttonImage: UIImage {
    switch self {
    case .prb:
      return UIImage(imageLiteralResourceName: "WalletRequestAmountPick-Exchange-PRB")
    case .pgb:
      return UIImage(imageLiteralResourceName: "WalletRequestAmountPick-Exchange-PGB")
    case .white:
      return UIImage(imageLiteralResourceName: "WalletRequestAmountPick-Exchange")
    }
  }
}
