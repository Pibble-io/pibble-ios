//
//  UserProfileAvatarTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 05.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias UserProfileAvatarActionsHandler = (UserProfileAvatarTableViewCell, UserProfileContent.UserAvavarActions) -> Void

class UserProfileAvatarTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var wallImageView: UIImageView!
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var pibbleAmountLabel: UILabel!
  @IBOutlet weak var redBrushAmountLabel: UILabel!
  @IBOutlet weak var greenBrushAmountLabel: UILabel!
  @IBOutlet weak var playgroundButton: UIButton!
  
  @IBAction func wallAction(_ sender: Any) {
    handler?(self, .wall)
  }
  
  @IBAction func avatarAction(_ sender: Any) {
    handler?(self, .userpic)
  }
  
  @IBAction func playgroundAction(_ sender: Any) {
    handler?(self, .playroom)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: UserProfileAvatarActionsHandler?
  
  func setViewModel(_ vm: UserProfileAvatarViewModelProtocol, handler: @escaping UserProfileAvatarActionsHandler) {
    self.handler = handler
    
    avatarImageView.setCornersToCircle()
    avatarImageView.layer.borderWidth = UIConstants.avatarImageViewBorderWidth
    avatarImageView.layer.borderColor = UIConstants.Colors.avatarImageViewBorder.cgColor
    
    wallImageView.image = vm.wallPlaceholder
    avatarImageView.image = vm.avatarPlaceholder
    
    wallImageView.setCachedImageOrDownload(vm.wallURLString)
    avatarImageView.setCachedImageOrDownload(vm.avatarURLString)
    
    pibbleAmountLabel.text = vm.pibbleAmount
    redBrushAmountLabel.text = vm.redBrushAmount
    greenBrushAmountLabel.text = vm.greenBrushAmount
    
    playgroundButton.isHidden = !vm.isPlaygroundVisible
  }
}

fileprivate enum UIConstants {
  static let avatarImageViewBorderWidth: CGFloat = 5.0
  
  enum Colors {
    static let avatarImageViewBorder = UIColor.white
  }
}
