//
//  GoodsPostDetailDescriptionView.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 02/08/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class GoodsPostDetailDescriptionView: NibLoadingView {
  @IBOutlet fileprivate var contentView: UIView!
  @IBOutlet weak var textBackgroundView: UIView!
  @IBOutlet weak var textView: UITextView!
  
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  
  override func setupView() {
    super.setupView()
    textBackgroundView.layer.cornerRadius = UIConstants.cornerRadius
    textBackgroundView.clipsToBounds = true
    textView.layer.borderColor =  UIConstants.Colors.textViewBackgroundBorder.cgColor
    textView.layer.borderWidth = 1.0
  }
  
  func setViewModel(_ vm: GoodsPostDetailDescriptionViewModelProtocol) {
    textView.text = vm.descriptionText
    updateTextViewForTextContent()
  }
  
  fileprivate func updateTextViewForTextContent() {
    let fittingSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: 9999))
    
    let textViewMinHeight = UIConstants.Constraints.inputTextViewMinHeight
    let viewMaxHeight = UIConstants.Constraints.inputTextViewMaxHeight
    let trueViewHeight = max(textViewMinHeight, CGFloat(fittingSize.height))
    textView.isScrollEnabled = viewMaxHeight.isLessThanOrEqualTo(fittingSize.height)
    
    let viewContentHeight = min(viewMaxHeight, trueViewHeight)
    
    textViewHeightConstraint.constant = ceil(viewContentHeight)
    setNeedsLayout()
    layoutIfNeeded()
  }
}


//MARK:- UIConstants

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 4.0
  
  
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 190.0
    static let inputTextViewMinHeight: CGFloat = 20.0
  }
  
  enum Colors {
    static let textViewBackgroundBorder =  UIColor.gray222
  }
  
}
