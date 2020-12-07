//
//  WalletTransactionCurrencyPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 08/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum WalletTransactionCurrencyPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, CreateExternalTransactionProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let transaction):
      return (V: WalletTransactionCurrencyPickViewController.self,
              I: WalletTransactionCurrencyPickInteractor(walletService: diContainer.walletService, transaction: transaction),
              P: WalletTransactionCurrencyPickPresenter(),
              R: WalletTransactionCurrencyPickRouter())
    }
  }
}
