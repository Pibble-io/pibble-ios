//
//  NotificationsFeedUserRelatedItemTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 27/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class NotificationsFeedUserRelatedItemTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var relatedUserAvatarImageView: UIImageView!
  
  @IBAction func showUserAction(_ sender: Any) {
    handler?(self, .showRelatedUser)
  }
  
  fileprivate var handler: NotificationsFeed.ItemActionsHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: NotificationsFeedUserRelatedItemViewModelProtocol, handler: @escaping NotificationsFeed.ItemActionsHandler) {
    self.handler = handler
    
    relatedUserAvatarImageView.setCornersToCircle()
    userImageView.setCornersToCircle()
    userImageView.image = vm.avatarPlaceholder
    userImageView.setCachedImageOrDownload(vm.avatarURLString)
    messageLabel.attributedText = vm.attributedMessage
    
    relatedUserAvatarImageView.image = vm.relatedUserAvatarPlaceholder
    relatedUserAvatarImageView.setCachedImageOrDownload(vm.relatedUserAvatarUrlString)
  }
}

fileprivate enum UIConstants {
  static let buttonsCornerRadius: CGFloat = 4.0
  
  enum Colors {
    static let highlightedButtonTitle = UIColor.bluePibble
    static let unHighlightedButtonTitle = UIColor.black
    
    static let highlightedButtonBorder = UIColor.bluePibble
    static let unHighlightedButtonBorder = UIColor.gray213
  }
}
