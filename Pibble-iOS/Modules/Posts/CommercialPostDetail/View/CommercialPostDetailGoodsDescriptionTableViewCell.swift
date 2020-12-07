//
//  CommercialPostDetailGoodsDescriptionTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 04/08/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class CommercialPostDetailGoodsDescriptionTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var textBackgroundView: UIView!
  @IBOutlet weak var textView: UITextView!
  
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    textBackgroundView.layer.cornerRadius = UIConstants.cornerRadius
    textBackgroundView.clipsToBounds = true
    textBackgroundView.layer.borderColor =  UIConstants.Colors.textViewBackgroundBorder.cgColor
    textBackgroundView.layer.borderWidth = 1.0
  }
  
  func setViewModel(_ vm: CommercialPostDetailGoodsDescriptionViewModelProtocol) {
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
