//
//  AccountCurrencyPickerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum AccountCurrencyPickerModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, AccountCurrencyPickerDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let delegate):
      return (V: AccountCurrencyPickerViewController.self,
              I: AccountCurrencyPickerInteractor(accountProfileService: diContainer.accountProfileService),
              P: AccountCurrencyPickerPresenter(delegate: delegate),
              R: AccountCurrencyPickerRouter())
    }
  }
}
