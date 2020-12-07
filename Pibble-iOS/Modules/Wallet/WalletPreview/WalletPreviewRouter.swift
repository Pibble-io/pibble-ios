//
//  WalletPreviewRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletPreviewRouter class
final class WalletPreviewRouter: Router {
  func routeToWallet() {
    AppModules
      .Wallet
      .walletHome
      .build()?
      .router.presentFromRootWithPush()
  }
}

// MARK: - WalletPreviewRouter API
extension WalletPreviewRouter: WalletPreviewRouterApi {
}

// MARK: - WalletPreview Viper Components
fileprivate extension WalletPreviewRouter {
    var presenter: WalletPreviewPresenterApi {
        return _presenter as! WalletPreviewPresenterApi
    }
}
