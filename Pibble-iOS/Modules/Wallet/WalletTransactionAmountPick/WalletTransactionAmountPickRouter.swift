//
//  WalletRequestAmountPickRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletRequestAmountPickRouter class
final class WalletTransactionAmountPickRouter: Router {
  
}

// MARK: - WalletRequestAmountPickRouter API
extension WalletTransactionAmountPickRouter: WalletTransactionAmountPickRouterApi {
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.unlock, delegate)
      .build()?
      .router.present(from: _presenter._viewController)
  }
  
  func routeToTransactionCreate(_ mainBalance: Balance, secondaryBalance: Balance) {
    AppModules
      .Wallet
      .walletTransactionCreate(mainBalance, secondaryBalance)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToInvoiceCreate(_ mainBalance: Balance, secondaryBalance: Balance) {
    AppModules
      .Wallet
      .walletInvoiceCreate(mainBalance, secondaryBalance)
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
}

// MARK: - WalletRequestAmountPick Viper Components
fileprivate extension WalletTransactionAmountPickRouter {
    var presenter: WalletTransactionAmountPickPresenterApi {
        return _presenter as! WalletTransactionAmountPickPresenterApi
    }
}
