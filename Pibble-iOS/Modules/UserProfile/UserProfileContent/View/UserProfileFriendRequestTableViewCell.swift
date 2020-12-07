//
//  UserProfileFriendRequestTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 09.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias UserProfileFriendRequestActionsHandler = (UserProfileFriendRequestTableViewCell, UserProfileContent.UserProfileFriendRequestActions) -> Void

class UserProfileFriendRequestTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userLevelLabel: UILabel!
  
  @IBOutlet weak var actionsBackgroundView: UIView!
  
  @IBOutlet weak var denyButton: UIButton!
  
  @IBOutlet weak var acceptButton: UIButton!
  
  @IBOutlet weak var statusLabel: UILabel!
  
  @IBAction func userProfileAction(_ sender: Any) {
    handler?(self, .showUserProfile)
  }
  
  @IBAction func denyAction(_ sender: Any) {
    handler?(self, .deny)
  }
  
  @IBAction func acceptAction(_ sender: Any) {
    handler?(self, .accept)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: UserProfileFriendRequestActionsHandler?
  
  func setViewModel(_ vm: UserProfileFriendRequestViewModelProtocol, handler: @escaping UserProfileFriendRequestActionsHandler) {
    self.handler = handler
    
    avatarImageView.setCornersToCircle()
    avatarImageView.image = vm.avatarPlaceholder
    avatarImageView.setCachedImageOrDownload(vm.avatarURLString)
    usernameLabel.text = vm.username
    userLevelLabel.text = vm.userLevel
    statusLabel.text = vm.statusTitle
    
    statusLabel.layer.cornerRadius = UIConstants.CornerRadius.status
    statusLabel.clipsToBounds = true
    
    acceptButton.layer.borderWidth = 1.0
    acceptButton.layer.borderColor = UIConstants.Colors.actionsBorder.cgColor
    acceptButton.layer.cornerRadius = UIConstants.CornerRadius.actionButton
    acceptButton.clipsToBounds = true
    
    denyButton.layer.borderWidth = 1.0
    denyButton.layer.borderColor = UIConstants.Colors.actionsBorder.cgColor
    denyButton.layer.cornerRadius = UIConstants.CornerRadius.actionButton
    denyButton.clipsToBounds = true
    
    switch vm.requestStatus {
    case .accpeted:
      statusLabel.backgroundColor = UIConstants.Colors.accepted
      statusLabel.isHidden = false
      actionsBackgroundView.isHidden = true
    case .denied:
       statusLabel.backgroundColor = UIConstants.Colors.denied
       statusLabel.isHidden = false
       actionsBackgroundView.isHidden = true
    case .none:
       statusLabel.isHidden = true
       actionsBackgroundView.isHidden = false
    }
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let denied = UIColor.pinkPibble
    static let accepted = UIColor.greenPibble
    
    static let actionsBorder = UIColor.gray213
  }
  
  enum CornerRadius {
    static let status: CGFloat = 10
    static let actionButton: CGFloat = 4
    
  }
}
