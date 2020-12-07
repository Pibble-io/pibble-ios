//
//  NotificationsFeedFollowingTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 27/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class NotificationsFeedFollowingTableViewCell: UITableViewCell, DequeueableCell {
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var followActionButton: UIButton!
  
  @IBAction func followAction(_ sender: Any) {
    handler?(self, .follow)
  }
  
  fileprivate var handler: NotificationsFeed.ItemActionsHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: NotificationsFeedFollowItemViewModelProtocol, handler: @escaping NotificationsFeed.ItemActionsHandler) {
    self.handler = handler
    userImageView.setCornersToCircle()
    userImageView.image = vm.avatarPlaceholder
    userImageView.setCachedImageOrDownload(vm.avatarURLString)
    messageLabel.attributedText = vm.attributedMessage
    followActionButton.setTitleForAllStates(vm.actionTitle)
    
    followActionButton.isHidden = !vm.isActionAvailable
    
    let actionTitleColor = vm.isActionHighlighted ?
      UIConstants.Colors.highlightedButtonTitle :
      UIConstants.Colors.unHighlightedButtonTitle
    
    let buttonBackgroundColor = vm.isActionHighlighted ?
      UIConstants.Colors.highlightedButtonColor :
      UIConstants.Colors.unHighlightedButtonColor
    
    followActionButton.setTitleColor(actionTitleColor, for: .normal)
    followActionButton.backgroundColor = buttonBackgroundColor
    
    let actionButtonBorderColor = vm.isActionHighlighted ?
      UIConstants.Colors.highlightedButtonBorder :
      UIConstants.Colors.unHighlightedButtonBorder
    
    followActionButton.layer.cornerRadius = UIConstants.buttonsCornerRadius
    followActionButton.clipsToBounds = true
    followActionButton.layer.borderWidth = 1.0
    followActionButton.layer.borderColor = actionButtonBorderColor.cgColor
  }
}

fileprivate enum UIConstants {
  static let buttonsCornerRadius: CGFloat = 4.0
  
  enum Colors {
    static let highlightedButtonTitle = UIColor.white
    static let unHighlightedButtonTitle = UIColor.black
    
    static let highlightedButtonColor = UIColor.bluePibble
    static let unHighlightedButtonColor = UIColor.white
    
    static let highlightedButtonBorder = UIColor.bluePibble
    static let unHighlightedButtonBorder = UIColor.gray213
  }
}
