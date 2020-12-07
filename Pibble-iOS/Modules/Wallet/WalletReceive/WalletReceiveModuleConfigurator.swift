//
//  WalletReceiveModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletReceiveModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, [BalanceCurrency])
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let currencies):
      return (V: WalletReceiveViewController.self,
              I: WalletReceiveInteractor(accountProfileService: diContainer.accountProfileService, currencies: currencies),
              P: WalletReceivePresenter(),
              R: WalletReceiveRouter())
    }
  }
}
