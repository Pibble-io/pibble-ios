//
//  WalletInvoiceDescriptionInputView.swift
//  Pibble
//
//  Created by Kazakov Sergey on 31.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class WalletInvoiceDescriptionInputView: NibLoadingView {
  @IBOutlet fileprivate var contentView: UIView!
  
  @IBOutlet weak var gradientView: GradientView!
  
  
  @IBOutlet fileprivate weak var titleLabel: UILabel!
  @IBOutlet fileprivate weak var mainCurrencyAmountLabel: UILabel!
  @IBOutlet fileprivate weak var mainCurrencyLabel: UILabel!
  
  @IBOutlet fileprivate weak var secondaryCurrencyLabel: UILabel!
  @IBOutlet fileprivate weak var secondaryCurrenctAmountLabel: UILabel!
  
  @IBOutlet weak var descriptionTextView: UITextView!
  
  @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
  
  var inputValueChangedActionHandler: ((WalletRequestAmountInputView, String)-> Void)?
  
  override func setupView() {
    mainCurrencyAmountLabel.text = ""
    mainCurrencyLabel.text = ""
    secondaryCurrenctAmountLabel.text = ""
    secondaryCurrencyLabel.text = ""
    
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = UIConstants.contentViewCornerRadius
    gradientView.addBackgroundGradientWith(UIConstants.Colors.backgroundGradient, direction: .diagonalLeft)
  }
}

fileprivate enum UIConstants {
  static let inputMaxCharLength: Int = 8
  static let nextButtonBorderWidth: CGFloat = 1.0
  
  static let contentViewCornerRadius: CGFloat = 5.0
  
  enum Colors {
    static let nextButtonBorder = UIColor.white
    static let backgroundGradient = UIColor.blueGradient
  }
}
