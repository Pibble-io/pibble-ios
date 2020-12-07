//
//  SearchResultTagDetailContentModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum SearchResultTagDetailContent {
  struct TagDetailViewModel: SearchResultTagDetailViewModelProtocol {
    let imageURLString: String
    let imagePlaceholder: UIImage?
    let title: String
    let countString: String
    let countTitleString: String
    let isFollowed: Bool
    let followStatus: String
    
    init(tag: TagProtocol) {
      imageURLString = ""
      imagePlaceholder = UIImage.avatarImageForTitleString(tag.cleanTagString)
      title = "#\(tag.cleanTagString)"
      countString = "\(tag.postedCount)"
      countTitleString =  SearchResultTagDetailContent.Strings.posted.localize()
      isFollowed = tag.isFollowedByCurrentUser ?? false
      followStatus = isFollowed ? SearchResultTagDetailContent.Strings.following.localize() : SearchResultTagDetailContent.Strings.follow.localize()
    }
  }
  
  struct TagViewModel: PostsFeedTagViewModelProtocol {
    var isPromoted: Bool
    
    let identifier: String
    let tagTitle: String
    let attributedTagTitle: NSAttributedString
    
    init(tag: TagProtocol, isPromoted: Bool) {
      self.isPromoted = isPromoted
      self.tagTitle = "#\(tag.cleanTagString)"
      identifier = "\(tagTitle)\(isPromoted)"
      
      guard tagTitle.count > 0 else {
        attributedTagTitle = NSAttributedString(string: "")
        return
      }
      
      attributedTagTitle = NSAttributedString()
    }
  }
}

extension SearchResultTagDetailContent {
  enum Strings: String, LocalizedStringKeyProtocol {
    case posted = "posts"
    case follow = "Follow"
    case following = "Following"
  }
}

