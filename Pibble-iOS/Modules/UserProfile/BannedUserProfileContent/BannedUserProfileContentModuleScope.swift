//
//  BannedUserProfileContentModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 31/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum BannedUserProfileContent {
  
  struct AccountViewModel: BannedUserProfileContentAccountViewModelProtocol {
    let wallPlaceholder: UIImage?
    let avatarPlaceholder: UIImage?
    let wallURLString: String
    let avatarURLString: String
    let username: String
    let blockStatus: String
    let blockStatusColor: UIColor
    
    init(user: UserProtocol) {
      wallPlaceholder = nil
      avatarPlaceholder = UIImage.avatarImageForNameString(user.userName, size: CGSize(width: 200, height: 200))
      wallURLString = ""
      avatarURLString = ""
      username = user.userName
      blockStatus = BannedUserProfileContent.Strings.accountBlockStatus.localize()
      
      let isCurrent = (user.isCurrent ?? false)
      blockStatusColor = isCurrent ?
        UIConstants.Colors.currentAccountBlockStatus :
        UIConstants.Colors.accountBlockStatus
    }
  }
}

extension BannedUserProfileContent {
  enum Strings: String, LocalizedStringKeyProtocol {
    case accountBlockStatus = "Account Blocked"
  }
}



fileprivate enum UIConstants {
  enum Colors {
    static let accountBlockStatus = UIColor.gray168
    static let currentAccountBlockStatus = UIColor.red
  }
}
