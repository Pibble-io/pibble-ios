//
//  AboutModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum About {
  enum SettingsItems {
    case appVersion(String)
    case terms(URL)
    case privacyPolicy(URL)
    case communityGuide(URL)
  }
  
  struct AboutItemViewModel: AboutItemViewModelProtocol {
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
      isRightArrowVisible = settingsItem.shouldShowRightArrow
    }
  }
}

extension About {
  enum Strings {
    enum MenuItems: String, LocalizedStringKeyProtocol {
      case appVersion = "Version"
      case terms = "Terms of Use"
      case privacyPolicy = "Private Policy"
      case communityGuide = "Community Guide"
    }
  }
}

extension About.SettingsItems {
  var title: String {
    switch self {
    case .appVersion(_):
      return About.Strings.MenuItems.appVersion.localize()
    case .terms(_):
      return About.Strings.MenuItems.terms.localize()
    case .privacyPolicy(_):
      return About.Strings.MenuItems.privacyPolicy.localize()
    case .communityGuide(_):
      return About.Strings.MenuItems.communityGuide.localize()
    }
  }
  
  var shouldShowRightArrow: Bool {
    switch self {
    case .appVersion(_):
      return false
    case .terms(_):
      return true
    case .privacyPolicy(_):
      return true
    case .communityGuide(_):
      return true
    }
  }
 
}

fileprivate enum UIConstants {
  enum Colors {
    static let highlightedMenuItemColor = UIColor.bluePibble
    static let menuItemColor = UIColor.gray70
  }
}
