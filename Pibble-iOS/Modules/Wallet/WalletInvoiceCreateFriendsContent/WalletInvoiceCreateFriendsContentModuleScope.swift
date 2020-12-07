//
//  WalletInvoiceCreateFriendsContentModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 01.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletInvoiceCreateFriendsContent {
  enum ContentType {
    case friends
    case recentFriends
  }
  
  struct WalletInvoiceCreateFriendViewModel: WalletInvoiceCreateFriendViewModelProtocol {
    let userpicPlaceholder: UIImage?
    let isSelected: Bool
    let userpic: String
    let username: String
    
    init(user: UserProtocol, isSelected: Bool) {
      self.isSelected = isSelected
      userpic = user.userpicUrlString
      username = user.userName.capitalized
      userpicPlaceholder = UIImage.avatarImageForNameString(user.userName)
    }
  }
}
