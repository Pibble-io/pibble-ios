//
//  UpvotedUsersModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UpvotedUsers {
  enum UpvotedContentType  {
    case posting(PostingProtocol)
  }
  
  typealias UpvotedUserItemsActionHandler = (UITableViewCell, ItemsAction) -> Void

  
  enum ItemsAction {
    case upvote
    case showUser
    case upvoteInPlace
    case follow
  }
  
  struct UpvotedUserViewModel: UpvotedUserViewModelProtocol {
    let username: String
    
    let userpicUrlString: String
    let usrepicPlaceholder: UIImage?
    let upvotedAmount: String
    
    let followingTitle: String
    let isFollowButtonHighlighted: Bool
    let upvoteBackAmount: String
    let isUpvoteBackVisible: Bool
    
    let isFollowButtonVisible: Bool
    
    
    init(upvote: UpvoteProtocol) {
      upvotedAmount = String(upvote.upvoteAmount)
      
      isUpvoteBackVisible = (upvote.profileUpvoteBackAmount ?? 0) > 0
      upvoteBackAmount = "\(upvote.profileUpvoteBackAmount ?? 0)"
      
      guard let user = upvote.upvotedUser else {
        username = ""
        userpicUrlString = ""
        usrepicPlaceholder = nil
        isFollowButtonHighlighted = true
        followingTitle = Strings.followAction.localize()
        isFollowButtonVisible = false
        return
      }
      
      username = user.userName
      userpicUrlString = user.userpicUrlString
      usrepicPlaceholder = UIImage.avatarImageForNameString(user.userName)
      
      isFollowButtonVisible = !(user.isCurrent ?? false)
      
      isFollowButtonHighlighted = user.isFollowedByCurrentUser
      followingTitle = user.isFollowedByCurrentUser ?
                        Strings.unfollowAction.localize() :
                        Strings.followAction.localize()
    }
  }
}


extension UpvotedUsers {
  enum Strings: String, LocalizedStringKeyProtocol {
      case followAction = "Follow"
      case unfollowAction = "Following"
  }
}
