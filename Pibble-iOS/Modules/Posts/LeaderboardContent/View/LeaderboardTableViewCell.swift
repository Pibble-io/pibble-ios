//
//  LeaderboardTableViewCell.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell, DequeueableCell {
  @IBOutlet weak var valueBackgroundView: UIView!
  @IBOutlet weak var placeLabel: UILabel!
  
  @IBOutlet weak var userpicImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  
  @IBAction func showPostsAction(_ sender: Any) {
    handler?(self, .showUserPosts)
  }
  
  @IBAction func showUserAction(_ sender: Any) {
     handler?(self, .showUser)
  }
  
  fileprivate var handler: LeaderboardContent.LeaderboardItemsActionsHandler?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setViewModel(_ vm: LeaderboardEntryViewModelProtocol, handler: @escaping LeaderboardContent.LeaderboardItemsActionsHandler) {
    self.handler = handler
    valueBackgroundView.setCornersToCircleByHeight()
    userpicImageView.setCornersToCircleByHeight()
    
    userpicImageView.image = vm.avatarPlaceholder
    userpicImageView.setCachedImageOrDownload(vm.avatarURLString)
    usernameLabel.text = vm.username
    valueLabel.text = vm.leaderboardValue
    placeLabel.text = vm.leaderboardPlace
  }
}
