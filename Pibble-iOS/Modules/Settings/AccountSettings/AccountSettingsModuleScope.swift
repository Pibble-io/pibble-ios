//
//  AccountSettingsModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum AccountSettings {
  enum SettingsItems: Int {
    case language
    case username
    case mutedUsers
  }
  
  struct AccountSettingsItemViewModel: AccountSettingsItemViewModelProtocol {
    let title: String
    let isUpperSeparatorVisible: Bool
    let isRightArrowVisible: Bool
    let titleColor: UIColor
    
    init(settingsItem: SettingsItems, shouldHaveUpperSeparator: Bool) {
      title = settingsItem.title
      isUpperSeparatorVisible = shouldHaveUpperSeparator
      titleColor = UIConstants.Colors.menuItemColor
      isRightArrowVisible = true
    }
  }
}

extension AccountSettings {
  enum Strings {
    enum MenuItems: String, LocalizedStringKeyProtocol {
      case language = "Language"
      case username = "Username"
      case mutedUsers = "Muted Accounts"
    }
  }
}

extension AccountSettings.SettingsItems {
  var title: String {
    switch self {
    case .language:
      return AccountSettings.Strings.MenuItems.language.localize()
    case .username:
      return AccountSettings.Strings.MenuItems.username.localize()
    case .mutedUsers:
      return AccountSettings.Strings.MenuItems.mutedUsers.localize()
    }
  }
 
}

fileprivate enum UIConstants {
  enum Colors {
    static let highlightedMenuItemColor = UIColor.bluePibble
    static let menuItemColor = UIColor.gray70
  }
}
