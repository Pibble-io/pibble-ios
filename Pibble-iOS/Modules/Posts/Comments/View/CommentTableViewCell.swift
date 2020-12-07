//
//  CommentCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 10.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import SwipeCellKit

typealias CommentTableViewCellActionHandler = (CommentTableViewCell, Comments.Actions) -> Void

class CommentTableViewCell: SwipeTableViewCell, DequeueableCell {
  @IBOutlet weak var contentContainerView: UIView!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  
  @IBOutlet weak var brushedTitle: UILabel!
  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var upVoteButton: UIButton!
  @IBOutlet weak var commentDate: UILabel!
  @IBOutlet weak var userpicLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var userpicTopConstraint: NSLayoutConstraint!
  
  @IBAction func replyAction(_ sender: Any) {
    handler?(self, .reply)
  }
  
  @IBAction func showUserAction(_ sender: Any) {
    handler?(self, .showUser)
  }
  
  @IBAction func upvoteAction(_ sender: Any) {
    handler?(self, .upvote)
  }
  
  fileprivate var handler: CommentTableViewCellActionHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    userImageView.setCornersToCircle()
    
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: CommentViewModelProtocol, handler: @escaping CommentTableViewCellActionHandler) {
    usernameLabel.attributedText = vm.attrubutedBody
    commentDate.text = vm.createdAt
    
    userImageView.image = vm.userpicPlaceholder
    userImageView.setCachedImageOrDownload(vm.userPic)
    
    userpicLeftConstraint.constant = vm.isReplyComment ? UIConstants.replyUserpicLeftConstraint : UIConstants.userpicLeftConstraint
    
    userpicTopConstraint.constant = vm.isReplyComment ? UIConstants.replyUserpicTopConstraint : UIConstants.userpicTopConstraint
    let replyButtonColor = vm.isSelectedToReply ? UIConstants.Colors.replySelected : UIConstants.Colors.replyUnselected
    replyButton.setTitleColor(replyButtonColor, for: .normal)
    
    let upVoteButtonImage = vm.isUpVoted ?
          UIImage(imageLiteralResourceName: "Comments-Upvote-selected"):
          UIImage(imageLiteralResourceName: "Comments-Upvote")
    
    upVoteButton.setImage(upVoteButtonImage, for: .normal)
    
    upVoteButton.isHidden = !vm.isUpVoteEnabled
    brushedTitle.text = vm.brushedCountTitle
    
    upVoteButton.isHidden = !vm.isInteractionEnabled
    replyButton.isHidden = !vm.isInteractionEnabled
    
    self.handler = handler
  }
}

fileprivate enum UIConstants {
  static let userpicLeftConstraint: CGFloat = 10.0
  static let replyUserpicLeftConstraint: CGFloat = 44.0
  
  static let userpicTopConstraint: CGFloat = 10.0
  static let replyUserpicTopConstraint: CGFloat = 0.0
  
  enum Colors {
    static let replySelected = UIColor.greenPibble
    static let replyUnselected = UIColor.gray191
  }
}
