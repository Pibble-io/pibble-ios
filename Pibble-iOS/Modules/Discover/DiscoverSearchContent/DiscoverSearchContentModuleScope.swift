//
//  DiscoverSearchContentModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import CoreData

enum DiscoverSearchContent {
  enum ContentType: Int {
    case users
    case places
    case tags
    case top
  }
 
  enum SearchResult {
    case user(UserProtocol)
    case place(LocationProtocol)
    case tag(TagProtocol)
    
    init(user: UserProtocol) {
      self = .user(user)
    }
    
    init(place: LocationProtocol) {
      self = .place(place)
    }
    
    init(tag: TagProtocol) {
      self = .tag(tag)
    }
  }
  
  struct ResultViewModel: DiscoverSearchContentResultViewModelProtocol {
    let resultImage: String
    let resultImagePlaceholder: UIImage?
    let resultTypeImage: UIImage?
    let resultTitle: String
    let resultSubtitle: String
    let isCopySearchStringAvailable: Bool
    
    init() {
      resultImage = ""
      resultImagePlaceholder = nil
      resultTypeImage = nil
      resultTitle = ""
      resultSubtitle = ""
      isCopySearchStringAvailable = false
    }
    
    init(user: UserProtocol?, isCopySearchStringAvailable: Bool) {
      guard let user = user else {
        self.init()
        return
      }
      self.init(user: user, isCopySearchStringAvailable: isCopySearchStringAvailable)
    }
    
    init(user: UserProtocol, isCopySearchStringAvailable: Bool) {
      self.isCopySearchStringAvailable = isCopySearchStringAvailable
      resultImage = user.userpicUrlString
      resultImagePlaceholder = UIImage.avatarImageForNameString(user.userName)
      resultTitle = user.userName.capitalized
      resultSubtitle = DiscoverSearchContent.Strings.userScores(redBrush: user.redBrushWalletBalance, greenBrush: user.greenBrushWalletBalance, level: user.userLevel)
      resultTypeImage = nil
    }
    
    init(place: LocationProtocol?, isCopySearchStringAvailable: Bool) {
      guard let place = place else {
        self.init()
        return
      }
      self.init(place: place, isCopySearchStringAvailable: isCopySearchStringAvailable)
    }
    
    init(place: LocationProtocol, isCopySearchStringAvailable: Bool) {
      self.isCopySearchStringAvailable = isCopySearchStringAvailable
      resultImage = ""
      resultImagePlaceholder = UIImage.avatarImageForTitleString(place.locationDescription)
      resultTitle = place.locationDescription
      resultSubtitle = "\(place.postedCount) \(DiscoverSearchContent.Strings.posted.localize())"
      resultTypeImage = UIImage(imageLiteralResourceName: "DiscoverSearchContent-PlaceResultType")
    }
    
    init(tag: TagProtocol?, isCopySearchStringAvailable: Bool) {
      guard let tag = tag else {
        self.init()
        return
      }
      self.init(tag: tag, isCopySearchStringAvailable: isCopySearchStringAvailable)
    }
    
    init(tag: TagProtocol, isCopySearchStringAvailable: Bool) {
      self.isCopySearchStringAvailable = isCopySearchStringAvailable
      resultImage = ""
      resultImagePlaceholder = UIImage.avatarImageForTitleString(tag.cleanTagString)
      resultTitle = "#\(tag.cleanTagString)"
      resultSubtitle = "\(tag.postedCount) \(DiscoverSearchContent.Strings.posted.localize())"
      resultTypeImage = UIImage(imageLiteralResourceName: "DiscoverSearchContent-TagResultType")
    }
  }
}

extension DiscoverSearchContent {
  enum Strings: String, LocalizedStringKeyProtocol {
    case posted = "Posted"
    
    
    static func userScores(redBrush: Double, greenBrush: Double, level: Int) -> String {
      let rb = String(format:"%.0f", redBrush)
      let gb = String(format:"%.0f", greenBrush)
      
      return "Lv.\(level) R.B \(rb) G.B \(gb)"
    }
  }
}
