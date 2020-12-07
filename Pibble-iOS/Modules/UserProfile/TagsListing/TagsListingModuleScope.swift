//
//  TagsListingModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 14/03/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum TagsListing {
  enum FilterType {
    case followedBy(UserProtocol)
  }
  
  enum ItemActions {
    case following
  }
  
  struct ItemViewModel: TagListingItemViewModelProtocol {
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    let username: String
    let userLevel: String
    let actionTitle: String
    let isActionHighlighted: Bool
    let isActionAvailable: Bool
    
    init(tag: TagProtocol, filterType: FilterType) {
      avatarPlaceholder = UIImage.avatarImageForTitleString(tag.cleanTagString)
      avatarURLString = ""
      username = "#\(tag.cleanTagString)"
      userLevel = "\(tag.postedCount) \(TagsListing.Strings.postsCount.localize())"
      isActionHighlighted = !(tag.isFollowedByCurrentUser ?? false)
      isActionAvailable = true
      
      actionTitle = (tag.isFollowedByCurrentUser ?? false) ?
        TagsListing.Strings.unfollowAction.localize() :
        TagsListing.Strings.followAction.localize()
    }
  }
}


extension TagsListing {
  enum Strings: String, LocalizedStringKeyProtocol {
    case followAction = "Follow"
    case unfollowAction = "Unfollow"
    case friendAction = "Add friends"
    case unfriendAction = "Remove friends"
    
    case postsCount = "posts"
    
    static func userScores(redBrush: Double, greenBrush: Double, level: Int) -> String {
      let rb = String(format:"%.0f", redBrush)
      let gb = String(format:"%.0f", greenBrush)
      
      return "Lv.\(level) R.B \(rb) G.B \(gb)"
    }
  }
}
