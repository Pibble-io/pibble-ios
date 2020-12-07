//
//  PostingMediaDescriptionPickTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 31/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

typealias PostingMediaDescriptionPickHandler = (UITableViewCell, MediaPosting.CommerceEditActions) -> Void

class PostingMediaDescriptionPickTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var commentTextView: UITextView!
  
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var commentsPlaceHolder: UILabel!
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  
  fileprivate var handler: PostingMediaDescriptionPickHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commentTextView.delegate = self
    setupAppearance()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: MediaPostingGoodDescriptionViewModelProtocol, handler: @escaping PostingMediaDescriptionPickHandler) {
    self.handler = handler
    commentTextView.text = vm.text
    updatePlaceholder()
  }
  
  fileprivate func setupAppearance() {
    updatePlaceholder()
    containerView.clipsToBounds = true
    containerView.layer.cornerRadius = UIConstants.cornerRadius
  }
  
  fileprivate func updatePlaceholder() {
    commentsPlaceHolder.alpha = commentTextView.text.cleanedFromExtraNewLines().count > 0 ? 0.0 : 1.0
    updateEditViewForTextContent()
  }
  
  fileprivate func updateEditViewForTextContent() {
    let fittingSize = commentTextView.sizeThatFits(CGSize(width: commentTextView.frame.size.width, height: 9999))
    
    let textViewMinHeight = UIConstants.Constraints.inputTextViewMinHeight
    let viewMaxHeight = UIConstants.Constraints.inputTextViewMaxHeight
    let trueViewHeight = max(textViewMinHeight, CGFloat(fittingSize.height))
    commentTextView.isScrollEnabled = viewMaxHeight.isLessThanOrEqualTo(fittingSize.height)

    let viewContentHeight = min(viewMaxHeight, trueViewHeight)
    
    textViewHeightConstraint.constant = ceil(viewContentHeight)
    setNeedsLayout()
    layoutIfNeeded()
  }
}

extension PostingMediaDescriptionPickTableViewCell: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    handler?(self, .goodDescriptionBeginEditing)
  }
 
  func textViewDidChange(_ textView: UITextView) {
    updatePlaceholder()
    updateEditViewForTextContent()
    handler?(self, .goodDescriptionChangeText(textView.text))
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    handler?(self, .goodDescriptionEndEditing)
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  static let cornerRadius: CGFloat = 5.0
  
  
  enum itemCellsEstimatedHeights {
    static let comment: CGFloat = 100.0
  }
  
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 240.0
    static let inputTextViewMinHeight: CGFloat = 120.0
    static let commentBackgroundBottomConstraintMin: CGFloat = 0.0
  }
  
  enum Colors {
    static let commentsInputBorder =  UIColor.gray191
  }
  
}
