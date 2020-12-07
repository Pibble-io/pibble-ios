//
//  PostsFeedUserCollectionViewCell.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias PostsFeedUserTableViewCellActionHandler = (PostsFeedUserTableViewCell, PostsFeed.UserSectionActions) -> Void

class PostsFeedUserTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var userpicImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  
  @IBOutlet weak var userScoreLabel: UILabel!
  
  @IBOutlet weak var followingButton: UIButton!
  
  @IBOutlet weak var additionalActionButton: UIButton!
  
  @IBOutlet weak var userStatusImageView: UIImageView!
  
  @IBOutlet weak var prizeWonAmountLabel: UILabel!
  
  
  @IBAction func followingAction(_ sender: Any) {
    handler?(self, .following)
  }
  
  @IBAction func additionalAction(_ sender: Any) {
    handler?(self, .additional)
  }
  
  @IBAction func userProfileAction(_ sender: Any) {
    handler?(self, .userProfile)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  fileprivate var handler: PostsFeedUserTableViewCellActionHandler?
  
  func setViewModel(_ vm: PostsFeedUserViewModelProtocol, handler: @escaping PostsFeedUserTableViewCellActionHandler) {
    self.handler = handler
    
    userpicImageView.setCornersToCircle()
    usernameLabel.text = vm.username
    userpicImageView.image = vm.userpicPlaceholder
    userpicImageView.setCachedImageOrDownload(vm.userPic)
    userScoreLabel.text = vm.userScores
    followingButton.setTitleForAllStates(vm.followingTitle)
    followingButton.setTitleColor(vm.followingTitleColor, for: .normal)
    
    prizeWonAmountLabel.text = vm.prizeAmount
    userStatusImageView.image = vm.prizeImage
  }
}
