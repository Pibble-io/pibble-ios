//
//  WalletPayBillModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletPayBillModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: WalletPayBillViewController.self,
              I: WalletPayBillInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                         walletService: diContainer.walletService,
                                         accountProfileService: diContainer.accountProfileService),
              P: WalletPayBillPresenter(),
              R: WalletPayBillRouter())
    }
  }
}
