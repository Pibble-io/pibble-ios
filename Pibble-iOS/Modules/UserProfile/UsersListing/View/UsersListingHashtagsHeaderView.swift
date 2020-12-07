//
//  UsersListingHashtagsHeaderView.swift
//  Pibble
//
//  Created by Sergey Kazakov on 15/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

typealias UsersListingHashtagsHeaderActionsHandler = (UsersListingHashtagsHeaderView, UsersListing.ItemActions) -> Void

class UsersListingHashtagsHeaderView: NibLoadingView {
  @IBOutlet var contentView: UIView!
  
  @IBOutlet weak var userImageView: UIImageView!
  
  @IBOutlet weak var usernameLabel: UILabel!
  
  @IBOutlet weak var userLevelLabel: UILabel!
  @IBOutlet weak var userActionButton: UIButton!
  
  @IBAction func userAction(_ sender: Any) {
    handler?(self, .followedHashTagsSeletion)
  }
  
  fileprivate var handler: UsersListingHashtagsHeaderActionsHandler?
  
  func setViewModel(_ vm: UserListingHeaderViewModelProtocol, handler: @escaping UsersListingHashtagsHeaderActionsHandler) {
    self.handler = handler
    
    userImageView.setCornersToCircle()
    
    usernameLabel.text = vm.username
    userLevelLabel.text = vm.userLevel
    
    userActionButton.isHidden = !vm.isActionAvailable
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
  

