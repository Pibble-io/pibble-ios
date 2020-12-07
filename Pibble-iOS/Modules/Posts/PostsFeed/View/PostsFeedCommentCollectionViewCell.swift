//
//  PostsFeedCommentCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias PostsFeedCommentTableViewCellActionHandler = (PostsFeedCommentTableViewCell) -> Void

class PostsFeedCommentTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var commentTextLabel: UILabel!
  
  @IBOutlet weak var verticalSeparatorBottomView: UIView!
  @IBOutlet weak var verticalSeparatorTopView: UIView!
  @IBOutlet weak var verticalSeparatorView: UIView!
  @IBOutlet weak var commentTextLabelLeadingConstraint: NSLayoutConstraint!
  
  @IBAction func showUserAction(_ sender: Any) {
    handler?(self)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: PostsFeedCommentTableViewCellActionHandler?
  
  func setViewModel(_ vm: PostsFeedCommentViewModelProtocol, handler: @escaping PostsFeedCommentTableViewCellActionHandler) {
    self.handler = handler
    
    commentTextLabel.attributedText = vm.atrributedCommentWithUsername
    verticalSeparatorView.alpha = vm.isReply ? 1.0 : 0.0
    
    commentTextLabel.alpha = vm.isPending ? 0.5 : 1.0
    
    verticalSeparatorTopView.alpha =  !vm.isReply || vm.isFirst ? 0.0 : 1.0
    verticalSeparatorBottomView.alpha =  !vm.isReply || vm.isLast ? 0.0 : 1.0
    
    commentTextLabelLeadingConstraint.constant = vm.isReply ?
      UIConstants.Constraints.commentTextLeadingReply :
      UIConstants.Constraints.commentTextLeading
  }
}

fileprivate enum UIConstants {
  enum Constraints {
    static let commentTextLeading: CGFloat = 10.0
    static let commentTextLeadingReply: CGFloat = 40.0
  }
}
