//
//  UsersListingModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UsersListing {
  enum ContentType {
    case followers(UserProtocol)
    case following(UserProtocol)
    case friends(UserProtocol)
    case editFriends(UserProtocol)
    case mutedUsers(UserProtocol)
  }
  
  enum ItemActions {
    case following
    case followedHashTagsSeletion
  }
  
  struct FollowedTagsModel {
    let tags: [TagProtocol]
    let totalCount: Int
  }
  
  struct HashTagsHeaderViewModel: UserListingHeaderViewModelProtocol {
    let username: String
    let userLevel: String
    
    let isActionAvailable: Bool
    
    init(tags: FollowedTagsModel) {
      username = "\(tags.totalCount) \(UsersListing.Strings.hashTagsTitle.localize())"
      userLevel = tags.tags.map { "#\($0.cleanTagString)"}.joined(separator: " ")
      
      isActionAvailable = tags.totalCount > 0
    }
    
  }
  
  struct UserListingItemViewModel: UserListingItemViewModelProtocol {
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    let username: String
    let userLevel: String
    let actionTitle: String
    let isActionHighlighted: Bool
    let isActionAvailable: Bool
    
    init(user: UserProtocol, filterType: ContentType) {
      avatarPlaceholder = UIImage.avatarImageForNameString(user.userName)
      avatarURLString = user.userpicUrlString
      username = user.userName.capitalized
      userLevel = UsersListing.Strings.userScores(redBrush: user.redBrushWalletBalance, greenBrush: user.greenBrushWalletBalance, level: user.userLevel)
      
      guard !(user.isCurrent ?? false) else {
        actionTitle = ""
        isActionHighlighted = false
        isActionAvailable = false
        return
      }
      
      switch filterType {
      case .followers(_):
        isActionHighlighted = !user.isFollowedByCurrentUser
        isActionAvailable = true
        
        actionTitle = user.isFollowedByCurrentUser ?
          UsersListing.Strings.unfollowAction.localize() :
          UsersListing.Strings.followAction.localize()
      case .following(_):
        isActionHighlighted = !user.isFollowedByCurrentUser
        isActionAvailable = true
        
        actionTitle = user.isFollowedByCurrentUser ?
          UsersListing.Strings.unfollowAction.localize() :
          UsersListing.Strings.followAction.localize()
      case .friends(_), .editFriends(_), .mutedUsers(_):
        actionTitle = ""
        isActionHighlighted = false
        isActionAvailable = false
      }
    }

  }
}

fileprivate enum UIConstants {
  
}

extension UsersListing {
  enum Strings: String, LocalizedStringKeyProtocol {
    case followAction = "Follow"
    case unfollowAction = "Unfollow"
    case friendAction = "Add friends"
    case unfriendAction = "Remove"
    
    case unmuteAction = "Unmute"

    case hashTagsTitle = "Hashtags"
    
    enum NavigationBar: String, LocalizedStringKeyProtocol {
      case followers = "Followers"
      case following = "Following"
      case friends = "Friends"
      case editFriends = "Close Friends"
      case mutedUsers = "Muted Accounts"
    }
    
    static func userScores(redBrush: Double, greenBrush: Double, level: Int) -> String {
      let rb = String(format:"%.0f", redBrush)
      let gb = String(format:"%.0f", greenBrush)
      
      return "Lv.\(level) R.B \(rb) G.B \(gb)"
    }
    
    
  }
}
