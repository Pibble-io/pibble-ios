//
//  GiftsFeedModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

enum GiftsFeed {
  enum ContentType {
    case giftHome
    case giftSearch
  }
}

extension GiftsFeed {
  enum Strings {
    enum NavigationBarTitles: String, LocalizedStringKeyProtocol {
      case giftHome = "Gift"
      case search = "Search"
    }
    
    enum Alerts: String, LocalizedStringKeyProtocol  {
      case exitMessage = "Do you want to exit \"Pibble's Gift\" ?"
      case okAction = "Ok"
      case cancelAction = "Cancel"
    }
  }
}
