//
//  WalletSettingsRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletSettingsRouter class
final class WalletSettingsRouter: Router {
}

// MARK: - WalletSettingsRouter API
extension WalletSettingsRouter: WalletSettingsRouterApi {
  func routeToNativeCurrencyPicker(_ delegate: AccountCurrencyPickerDelegateProtocol) {
    AppModules
      .Settings
      .accountCurrencyPicker(delegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - WalletSettings Viper Components
fileprivate extension WalletSettingsRouter {
  var presenter: WalletSettingsPresenterApi {
    return _presenter as! WalletSettingsPresenterApi
  }
}
