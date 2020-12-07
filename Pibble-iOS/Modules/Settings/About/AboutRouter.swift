//
//  AboutRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - AboutRouter class
final class AboutRouter: Router {
}

// MARK: - AboutRouter API
extension AboutRouter: AboutRouterApi {
  func routeToExternalLinkWithUrl(_ url: URL, title: String) {
    AppModules
      .Settings
      .externalLink(url, title)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToNativeCurrencyPicker(_ delegate: AccountCurrencyPickerDelegateProtocol) {
    AppModules
      .Settings
      .accountCurrencyPicker(delegate)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - About Viper Components
fileprivate extension AboutRouter {
  var presenter: AboutPresenterApi {
    return _presenter as! AboutPresenterApi
  }
}
