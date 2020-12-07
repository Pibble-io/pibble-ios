//
//  WalletInvoiceCreateModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 31.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletInvoiceCreateModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, Balance, Balance)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let mainBalance, let secondaryBalance):
      return (V: WalletInvoiceCreateViewController.self,
              I: WalletInvoiceCreateInteractor(walletService: diContainer.walletService,
                                               coreDataStorageService: diContainer.coreDataStorageService,
                                               mainAmountBalance: mainBalance,
                                               secondaryAmountBalance: secondaryBalance),
              P: WalletInvoiceCreatePresenter(),
              R: WalletInvoiceCreateRouter())
    }
  }
}
