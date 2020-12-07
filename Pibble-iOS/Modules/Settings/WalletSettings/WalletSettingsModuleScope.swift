//
//  WalletSettingsModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum WalletSettings {
  enum SettingsItems {
    case nativeCurrency(BalanceCurrency?)
  }
  
  struct WalletSettingsItemViewModel: WalletSettingsItemViewModelProtocol {
    let title: String
    let isUpperSeparatorVisible: Bool
    let isRightArrowVisible: Bool
    let titleColor: UIColor
    let pickedValue: String
    
    init(settingsItem: SettingsItems, value: String?, shouldHaveUpperSeparator: Bool) {
      title = settingsItem.title
      pickedValue = value ?? ""
      isUpperSeparatorVisible = shouldHaveUpperSeparator
      titleColor = UIConstants.Colors.menuItemColor
      isRightArrowVisible = true
    }
  }
}

extension WalletSettings {
  enum Strings {
    enum MenuItems: String, LocalizedStringKeyProtocol {
      case nativeCurrency = "Native Currency"
    }
  }
}

extension WalletSettings.SettingsItems {
  var title: String {
    switch self {
    case .nativeCurrency(_):
      return WalletSettings.Strings.MenuItems.nativeCurrency.localize()
    }
  }
 
}

fileprivate enum UIConstants {
  enum Colors {
    static let highlightedMenuItemColor = UIColor.bluePibble
    static let menuItemColor = UIColor.gray70
  }
}
