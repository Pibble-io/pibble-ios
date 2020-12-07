//
//  UserProfileFriendTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 08.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias UserProfileFriendActionsHandler = (UserProfileFriendTableViewCell, UserProfileContent.UserProfileFriendActions) -> Void

class UserProfileFriendTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userLevelLabel: UILabel!
  
  @IBAction func userProfileAction(_ sender: Any) {
    handler?(self, .showUserProfile)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: UserProfileFriendActionsHandler?
  
  func setViewModel(_ vm: UserProfileFriendViewModelProtocol, handler: @escaping UserProfileFriendActionsHandler) {
    self.handler = handler
    
    avatarImageView.setCornersToCircle()
    avatarImageView.image = vm.avatarPlaceholder
    avatarImageView.setCachedImageOrDownload(vm.avatarURLString)
    usernameLabel.text = vm.username
    userLevelLabel.text = vm.userLevel
  }
}
