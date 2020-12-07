//
//  PostsFeedEditDescriptionTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 18.01.2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

typealias PostsFeedEditDescriptionTableViewCellHandler = (PostsFeedEditDescriptionTableViewCell, PostsFeed.EditDescriptionActions) -> Void


class PostsFeedEditDescriptionTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var captionTextView: UITextView!
  @IBOutlet weak var captionPlaceholderLabel: UILabel!
  
  @IBOutlet weak var captionTextFieldHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    captionTextView.delegate = self
  }
  
  fileprivate var handler: PostsFeedEditDescriptionTableViewCellHandler?
  
  func setViewModel(_ vm: PostsFeedEditDescriptionViewModelProtocol, handler: @escaping PostsFeedEditDescriptionTableViewCellHandler) {
    self.handler = handler
    captionTextView.text = vm.caption
    updatePlaceholderFor(captionTextView)
    updateTextViewForTextContent(captionTextView)
  }
  
  fileprivate func updatePlaceholderFor(_ textView: UITextView) {
    captionPlaceholderLabel.alpha = textView.text.count > 0 ? 0.0 : 1.0
  }
  
  fileprivate func updateTextViewForTextContent(_ textView: UITextView) {
    let fittingSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: 9999))
    
    let textViewMinHeight = UIConstants.Constraints.inputTextViewMinHeight
    let textViewMaxHeight = UIConstants.Constraints.inputTextViewMaxHeight
    let trueViewHeight = max(textViewMinHeight, CGFloat(fittingSize.height))
    let viewContentHeight = min(textViewMaxHeight, trueViewHeight)
    
    captionTextFieldHeightConstraint.constant = ceil(viewContentHeight)
    setNeedsLayout()
    layoutIfNeeded()
  }
}

extension PostsFeedEditDescriptionTableViewCell: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    handler?(self, .beginEditing)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    updatePlaceholderFor(textView)
    updateTextViewForTextContent(textView)
    handler?(self, .changeText(textView.text))
  }
}


fileprivate enum UIConstants {
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 200
    static let inputTextViewMinHeight: CGFloat = 43
  }
}
