//
//  WalletHomeRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - WalletHomeRouter class
final class WalletHomeRouter: Router {
  fileprivate let coinMarketCapUrl = URL(string: "https://coinmarketcap.com/currencies/pibble/")
}

// MARK: - WalletHomeRouter API
extension WalletHomeRouter: WalletHomeRouterApi {
  func routeToPinCodeRegistration(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.registerNewPinCode, delegate)
      .build()?
      .router.present(withDissolveFrom: _presenter._viewController)
  }
  
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol) {
    AppModules
      .Wallet
      .walletPinCode(.unlock, delegate)
      .build()?
      .router.present(withDissolveFrom: _presenter._viewController)
  }
  
  func routeToWebsiteAt(_ url: URL) {
    let configurator = ExternalLinkModuleConfigurator.modalConfig(url, url.absoluteString)
    let module = AppModules
      .Settings
      .externalLink(url, url.absoluteString)
      .build(configurator: configurator)
    
    module?.router.present(withDissolveFrom: presenter._viewController)
  }
  
  func routeTo(_ route: WalletHome.RouteActions, accountProfile: AccountProfileProtocol) {
    switch route {
    case .payBill:
      AppModules
        .Wallet
        .walletPayBill
        .build()?
        .router.present(withPushfrom: _presenter._viewController)
    case .send:
      AppModules
        .Wallet
        .walletTransactionAmountPick(.outcoming(main: [.pibble, .etherium, .bitcoin, .klaytn], secondary: accountProfile.accountNativeCurrency))
        .build()?
        .router.present(withPushfrom: _presenter._viewController)
    case .recieve:
      AppModules
        .Wallet
        .walletReceive([.pibble, .etherium, .bitcoin, .klaytn])
        .build()?
        .router.present(withPushfrom: _presenter._viewController)
    case .exchange:
      AppModules
        .Wallet
        .walletTransactionAmountPick(.exchange(currencyPairs: [(main: .pibble,
                                                                secondary: .redBrush,
                                                                oneWay: false),
                                                               (main: .pibble,
                                                                secondary: .greenBrush,
                                                                oneWay: true)]))
        .build()?
        .router.present(withPushfrom: _presenter._viewController)
    case .activity:
      AppModules
        .Wallet
        .walletActivity
        .build()?
        .router.present(withPushfrom: _presenter._viewController)
    case .market:
      guard let url = coinMarketCapUrl else {
        return
      }
      
      routeToWebsiteAt(url)
      
    }
  }
  
}

// MARK: - WalletHome Viper Components
fileprivate extension WalletHomeRouter {
    var presenter: WalletHomePresenterApi {
        return _presenter as! WalletHomePresenterApi
    }
}
