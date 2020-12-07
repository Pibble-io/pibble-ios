//
//  SettingsHomeModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum SettingsHome {
  enum SettingsItems: Int {
    case inviteFriends
    case closeFriends
    case notifications
    case commerce
    case promotions
    case funding
    case wallet
    case account
    case help
    case about
    
    case logout
  }
  
  struct SettingsHomeItemViewModel: SettingsHomeItemViewModelProtocol {
    let title: String
    let icon: UIImage
    let isUpperSeparatorVisible: Bool
    let isRightArrowVisible: Bool
    let titleColor: UIColor
    
    init(settingsItem: SettingsItems, shouldHaveUpperSeparator: Bool) {
      title = settingsItem.title
      icon = settingsItem.iconImage
      isUpperSeparatorVisible = shouldHaveUpperSeparator
      titleColor = settingsItem == .logout ? UIConstants.Colors.highlightedMenuItemColor : UIConstants.Colors.menuItemColor
      isRightArrowVisible = settingsItem != .logout
    }
  }
}

extension SettingsHome {
  enum Strings {
    enum MenuItems: String, LocalizedStringKeyProtocol {
      case inviteFriends = "Invite Friends"
      case closeFriends = "Close Friends"
      case notifications = "Notifications"
      case commerce = "Commerce"
      case promotions = "Promotions"
      case funding = "Funding"
      case wallet = "Wallet"
      case account = "Account"
      case help = "Help"
      case about = "About"
      
      case logout = "Log Out"
    }
  }
}

extension SettingsHome.SettingsItems {
  var title: String {
    switch self {
    case .inviteFriends:
      return SettingsHome.Strings.MenuItems.inviteFriends.localize()
    case .closeFriends:
      return SettingsHome.Strings.MenuItems.closeFriends.localize()
    case .notifications:
      return SettingsHome.Strings.MenuItems.notifications.localize()
    case .commerce:
      return SettingsHome.Strings.MenuItems.commerce.localize()
    case .promotions:
      return SettingsHome.Strings.MenuItems.promotions.localize()
    case .funding:
      return SettingsHome.Strings.MenuItems.funding.localize()
    case .wallet:
      return SettingsHome.Strings.MenuItems.wallet.localize()
    case .account:
      return SettingsHome.Strings.MenuItems.account.localize()
    case .help:
      return SettingsHome.Strings.MenuItems.help.localize()
    case .about:
      return SettingsHome.Strings.MenuItems.about.localize()
    case .logout:
      return SettingsHome.Strings.MenuItems.logout.localize()
    }
  }
  
  var iconImage: UIImage {
    switch self {
    case .inviteFriends:
      return UIImage(imageLiteralResourceName: "SettingsHome-InviteFriends")
    case .closeFriends:
      return UIImage(imageLiteralResourceName: "SettingsHome-CloseFriends")
    case .notifications:
      return UIImage(imageLiteralResourceName: "SettingsHome-Notifications")
    case .commerce:
      return UIImage(imageLiteralResourceName: "SettingsHome-Commerce")
    case .promotions:
      return UIImage(imageLiteralResourceName: "SettingsHome-Promotions")
    case .funding:
      return UIImage(imageLiteralResourceName: "SettingsHome-Funding")
    case .wallet:
      return UIImage(imageLiteralResourceName: "SettingsHome-Wallet")
    case .account:
      return UIImage(imageLiteralResourceName: "SettingsHome-Profile")
    case .help:
      return UIImage(imageLiteralResourceName: "SettingsHome-Help")
    case .about:
      return UIImage(imageLiteralResourceName: "SettingsHome-About")
    case .logout:
      return UIImage(imageLiteralResourceName: "SettingsHome-Logout")
    }
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let highlightedMenuItemColor = UIColor.bluePibble
    static let menuItemColor = UIColor.gray70
  }
}
