//
//  UsersListingItemTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 10.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias TagsListingItemActionsHandler = (TagsListingItemTableViewCell, TagsListing.ItemActions) -> Void

class TagsListingItemTableViewCell: UITableViewCell, DequeueableCell {
 
  @IBOutlet weak var userImageView: UIImageView!
  
  @IBOutlet weak var usernameLabel: UILabel!
  
  @IBOutlet weak var userLevelLabel: UILabel!
  @IBOutlet weak var userActionButton: UIButton!
  
  @IBAction func userAction(_ sender: Any) {
    handler?(self, .following)
  }
  
  fileprivate var handler: TagsListingItemActionsHandler?
  
  func setViewModel(_ vm: TagListingItemViewModelProtocol, handler: @escaping TagsListingItemActionsHandler) {
    self.handler = handler
    
    userImageView.setCornersToCircle()
    userImageView.image = vm.avatarPlaceholder
    userImageView.setCachedImageOrDownload(vm.avatarURLString)
    usernameLabel.text = vm.username
    userLevelLabel.text = vm.userLevel
    userActionButton.setTitleForAllStates(vm.actionTitle)
    
    userActionButton.isHidden = !vm.isActionAvailable
    
    let actionTitleColor = vm.isActionHighlighted ?
      UIConstants.Colors.highlightedButtonTitle :
      UIConstants.Colors.unHighlightedButtonTitle
   
    userActionButton.setTitleColor(actionTitleColor, for: .normal)
    
    let actionButtonBorderColor = vm.isActionHighlighted ?
      UIConstants.Colors.highlightedButtonBorder :
      UIConstants.Colors.unHighlightedButtonBorder
    
    userActionButton.layer.cornerRadius = UIConstants.buttonsCornerRadius
    userActionButton.clipsToBounds = true
    userActionButton.layer.borderWidth = 1.0
    userActionButton.layer.borderColor = actionButtonBorderColor.cgColor
  }
}

fileprivate enum UIConstants {
  static let buttonsCornerRadius: CGFloat = 7.0
  
  enum Colors {
    static let highlightedButtonTitle = UIColor.bluePibble
    static let unHighlightedButtonTitle = UIColor.black
    
    static let highlightedButtonBorder = UIColor.bluePibble
    static let unHighlightedButtonBorder = UIColor.gray213
  }
}
