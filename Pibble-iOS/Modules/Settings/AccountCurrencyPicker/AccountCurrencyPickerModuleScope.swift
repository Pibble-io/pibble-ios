//
//  AccountCurrencyPickerModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum AccountCurrencyPicker {
  struct AccountCurrencyPickerItemViewModel: AccountCurrencyPickerItemViewModelProtocol {
    var pickedValue: String = ""
    
    var subtitleColor: UIColor
    
    let title: String
    let subtitle: String
    let isUpperSeparatorVisible: Bool
    let isRightArrowVisible: Bool
    let titleColor: UIColor
   
    
    init(currency: BalanceCurrency, isSelected: Bool, shouldHaveUpperSeparator: Bool) {
      title = currency.localizedName
      subtitle = currency.symbol
      
      pickedValue = ""
      
      
      isUpperSeparatorVisible = shouldHaveUpperSeparator
      titleColor = isSelected ? UIConstants.Colors.highlightedMenuItemColor : UIConstants.Colors.menuItemColor
      subtitleColor = isSelected ? UIConstants.Colors.highlightedMenuItemColor : UIConstants.Colors.menuItemSubtitleColor
      
      isRightArrowVisible = false
    }
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let highlightedMenuItemColor = UIColor.bluePibble
    static let menuItemColor = UIColor.gray70
    static let menuItemSubtitleColor = UIColor.gray168
  }
}
