//
//  WalletTransactionCreateModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletTransactionCreateModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, Balance, Balance)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let mainBalance, let secondaryBalance):
      return (V: WalletTransactionCreateViewController.self,
              I: WalletTransactionCreateInteractor(walletService: diContainer.walletService,
                                                   coreDataStorageService: diContainer.coreDataStorageService,
                                                   mainAmountBalance: mainBalance,
                                                   secondaryAmountBalance: secondaryBalance),
              P: WalletTransactionCreatePresenter(),
              R: WalletTransactionCreateRouter(servicesContainer: diContainer))
    }
  }
}
