//
//  TabBarModuleScope.swift
//  Pibble
//
//  Created by Kazakov Sergey on 28.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum TabBar {
  enum MainItems: Int {
    case first
    case second
    case third
    case fourth
  }
  
  enum MenuPresentationType {
    case creationMenu
    case sideMenu
    case hidden
    
    var isHidden: Bool {
      return self == .hidden
    }
  }
  
  enum MenuItems: Int {
    case camera
    case commerce
    case charity
    case album
    case goods
    case funding
    
    case gift
    case wallet
    case notifications
    case settings
    
    static let creationMenuItemsUpperSection = Array(MenuItems.camera.rawValue...MenuItems.charity.rawValue)
      .map { return MenuItems(rawValue: $0)! }
    
    static let creationMenuItemsLowerSection = Array(MenuItems.album.rawValue...MenuItems.funding.rawValue)
      .map { return MenuItems(rawValue: $0)! }

    static let sideMenuItemsUpperSection = Array(MenuItems.gift.rawValue...MenuItems.wallet.rawValue)
      .map { return MenuItems(rawValue: $0)! }
    
    static let sideMenuItemsLowerSection = Array(MenuItems.notifications.rawValue...MenuItems.settings.rawValue)
      .map { return MenuItems(rawValue: $0)! }
  }
}
