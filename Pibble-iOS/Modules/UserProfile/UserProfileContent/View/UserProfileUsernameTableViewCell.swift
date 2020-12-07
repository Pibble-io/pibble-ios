//
//  UserProfileUsernameTableViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 06.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class UserProfileUsernameTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userLevelLabel: UILabel!
  
  @IBOutlet weak var prizeIconImageView: UIImageView!
  @IBOutlet weak var prizeAmountLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  func setViewModel(_ vm: UserProfileUsernameViewModelProtocol) {
    usernameLabel.text = vm.username
    userLevelLabel.text = vm.userLevel
    prizeIconImageView.image = vm.prizeIconImage
    prizeAmountLabel.text = vm.prizeAmount
  }
}
