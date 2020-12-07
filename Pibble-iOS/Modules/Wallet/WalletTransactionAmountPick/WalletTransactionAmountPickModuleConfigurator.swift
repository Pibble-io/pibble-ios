//
//  WalletTransactionAmountPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletTransactionAmountPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, WalletTransactionAmountPick.TransactionType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let transactionType):
      return (V: WalletTransactionAmountPickViewController.self,
              I: WalletTransactionAmountPickInteractor(walletService: diContainer.walletService,
                                                       accountProfileService: diContainer.accountProfileService,
                                                       transactionType: transactionType),
              P: WalletTransactionAmountPickPresenter(),
              R: WalletTransactionAmountPickRouter())
    }
  }
}
