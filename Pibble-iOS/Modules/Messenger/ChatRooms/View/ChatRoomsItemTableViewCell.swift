//
//  ChatRoomsItemTableViewCell.swift
//  Pibble
//
//  Created by Sergey Kazakov on 16/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit
import SwipeCellKit

class ChatRoomsItemTableViewCell: SwipeTableViewCell, DequeueableCell {
  @IBOutlet weak var userImageView: UIImageView!
  
  @IBOutlet weak var unreadCountLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var lastMessageLabel: UILabel!
  @IBOutlet weak var commerceIconImageView: UIImageView!
  
  @IBOutlet weak var membersCountLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    userImageView.setCornersToCircle()
    unreadCountLabel.setCornersToCircle()
  }
  
  func setViewModel(_ vm: ChatRoomItemViewModelProtocol) {
    userImageView.image = vm.avatarPlaceholder
    userImageView.setCachedImageOrDownload(vm.avatarURLString)
    usernameLabel.text = vm.title
    lastMessageLabel.text = vm.lastMessage
    dateLabel.text = vm.date
    unreadCountLabel.text = vm.unreadCount
    unreadCountLabel.isHidden = vm.unreadCount.count == 0
    
    membersCountLabel.text = vm.membersCount
    
    guard let commercialIconImage = vm.commercialIconImage else {
      commerceIconImageView.isHidden = true
      commerceIconImageView.image = nil
      return
    }
    
    commerceIconImageView.isHidden = false
    commerceIconImageView.image = commercialIconImage
  }
    
}
