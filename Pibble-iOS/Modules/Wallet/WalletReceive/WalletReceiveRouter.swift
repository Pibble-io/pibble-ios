//
//  WalletReceiveRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - WalletReceiveRouter class
final class WalletReceiveRouter: Router {
}

// MARK: - WalletReceiveRouter API
extension WalletReceiveRouter: WalletReceiveRouterApi {
  func routeToShareControlWith(_ text: String) {
    let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
    presenter._viewController.present(vc, animated: true, completion: nil)
  }
  
  func routeToRequestAmount(_ accountProfile: AccountProfileProtocol) {
    AppModules
      .Wallet
      .walletTransactionAmountPick(.invoice(main: [.pibble, .etherium, .bitcoin, .klaytn], secondary: accountProfile.accountNativeCurrency))
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
  
}

// MARK: - WalletReceive Viper Components
fileprivate extension WalletReceiveRouter {
    var presenter: WalletReceivePresenterApi {
        return _presenter as! WalletReceivePresenterApi
    }
}
