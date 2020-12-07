//
//  WalletPayBillRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletPayBillRouter class
final class WalletPayBillRouter: Router {
}

// MARK: - WalletPayBillRouter API
extension WalletPayBillRouter: WalletPayBillRouterApi {
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.unlock, delegate)
      .build()?
      .router.present(from: _presenter._viewController)
  }
}

// MARK: - WalletPayBill Viper Components
fileprivate extension WalletPayBillRouter {
    var presenter: WalletPayBillPresenterApi {
        return _presenter as! WalletPayBillPresenterApi
    }
}
