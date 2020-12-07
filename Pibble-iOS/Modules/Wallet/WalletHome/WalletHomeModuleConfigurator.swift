//
//  WalletHomeModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletHomeModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: WalletHomeViewController.self,
              I: WalletHomeInteractor(accountProfileService: diContainer.accountProfileService, walletService: diContainer.walletService),
              P: WalletHomePresenter(),
              R: WalletHomeRouter())
    }
  }
}
