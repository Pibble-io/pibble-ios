//
//  PostsFeedAddCommentTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 22.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias PostsFeedAddCommentTableViewCellHandler = (PostsFeedAddCommentTableViewCell, PostsFeed.AddCommentActions) -> Void

class PostsFeedAddCommentTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var commentsBackgroundView: UIView!
  
  @IBOutlet weak var commentsPlaceHolder: UILabel!
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  
  @IBAction func sendAction(_ sender: Any) {
    sendButton.isEnabled = false
    commentTextView.endEditing(true)
    handler?(self, .postComment(commentTextView.text))
    commentTextView.text = ""
    updatePlaceholder()
  }
  
  fileprivate var handler: PostsFeedAddCommentTableViewCellHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    commentTextView.delegate = self
    setupAppearance()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: PostsFeedAddCommentViewModelProtocol, handler: @escaping PostsFeedAddCommentTableViewCellHandler) {
    self.handler = handler
    commentTextView.text = vm.commentText
    updatePlaceholder()
    
    vm.currentUserAvatarRequestClojure() { [weak self] userpicString, userpicPlaceholder in
      self?.userImageView.image = userpicPlaceholder
      self?.userImageView.setCachedImageOrDownload(userpicString)
    }
  }
  
  fileprivate func setupAppearance() {
    userImageView.setCornersToCircle()
    commentsBackgroundView.layer.cornerRadius =  commentsBackgroundView.bounds.height * 0.5
    commentsBackgroundView.layer.borderColor =  UIConstants.Colors.commentsInputBorder.cgColor
    commentsBackgroundView.layer.borderWidth = 0.5
    
    updatePlaceholder()
  }
  
  fileprivate func updatePlaceholder() {
    commentsPlaceHolder.alpha = commentTextView.text.count > 0 ? 0.0 : 1.0
    sendButton.isEnabled = commentTextView.text.count > 0
    updateEditViewForTextContent()
  }
  
  fileprivate func updateEditViewForTextContent() {
    let fittingSize = commentTextView.sizeThatFits(CGSize(width: commentTextView.frame.size.width, height: 9999))
    
    let textViewMinHeight = UIConstants.Constraints.inputTextViewMinHeight
    let viewMaxHeight = UIConstants.Constraints.inputTextViewMaxHeight
    let trueViewHeight = max(textViewMinHeight, CGFloat(fittingSize.height)) //+ viewContentHeightWithoutTextView
    let viewContentHeight = min(viewMaxHeight, trueViewHeight)
    
    textViewHeightConstraint.constant = ceil(viewContentHeight)
    setNeedsLayout()
    layoutIfNeeded()
  }
}

extension PostsFeedAddCommentTableViewCell: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    handler?(self, .beginEditing)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    updatePlaceholder()
    updateEditViewForTextContent()
    handler?(self, .changeText(textView.text))
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  enum itemCellsEstimatedHeights {
    static let comment: CGFloat = 100.0
  }
  
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 150.0
    static let inputTextViewMinHeight: CGFloat = 30.0
    static let commentBackgroundBottomConstraintMin: CGFloat = 0.0
  }
  
  enum Colors {
    static let commentsInputBorder =  UIColor.gray191
  }
  
}

