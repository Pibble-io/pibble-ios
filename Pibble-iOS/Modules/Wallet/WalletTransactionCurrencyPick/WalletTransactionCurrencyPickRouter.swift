//
//  WalletTransactionCurrencyPickRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 08/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletTransactionCurrencyPickRouter class
final class WalletTransactionCurrencyPickRouter: Router {
  
}

// MARK: - WalletTransactionCurrencyPickRouter API
extension WalletTransactionCurrencyPickRouter: WalletTransactionCurrencyPickRouterApi {
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.unlock, delegate)
      .build()?
      .router.present(from: _presenter._viewController)
  }
  
  func routeToHome() {
    let animated = true
    
    guard let navigationController = _viewController.navigationController else {
      _viewController.dismiss(animated: animated)
      return
    }
    var homeVC: WalletHomeViewController? = nil
    for vc in navigationController.viewControllers {
      homeVC = vc as? WalletHomeViewController
      if homeVC != nil {
        break
      }
    }
    guard let home = homeVC else {
      routeToRoot(animated: animated)
      return
    }
    
    _viewController.navigationController?.popToViewController(home, animated: animated)
  }
  
}

// MARK: - WalletTransactionCurrencyPick Viper Components
fileprivate extension WalletTransactionCurrencyPickRouter {
  var presenter: WalletTransactionCurrencyPickPresenterApi {
    return _presenter as! WalletTransactionCurrencyPickPresenterApi
  }
}
