//
//  CommerceTypePickModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum CommerceTypePick {
  enum SettingsItems: Int {
    case myGoods
    case purchasedGoods
  }
  
  struct CommerceTypePickItemViewModel: CommerceTypePickItemViewModelProtocol {
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

extension CommerceTypePick {
  enum Strings {
    enum MenuItems: String, LocalizedStringKeyProtocol {
      case myGoods = "My Goods"
      case purchasedGoods = "My Purchases"
    }
  }
}

extension CommerceTypePick.SettingsItems {
  var title: String {
    switch self {
    case .myGoods:
      return CommerceTypePick.Strings.MenuItems.myGoods.localize()
    case .purchasedGoods:
      return CommerceTypePick.Strings.MenuItems.purchasedGoods.localize()
    }
  }
 
}

fileprivate enum UIConstants {
  enum Colors {
    static let highlightedMenuItemColor = UIColor.bluePibble
    static let menuItemColor = UIColor.gray70
  }
}
