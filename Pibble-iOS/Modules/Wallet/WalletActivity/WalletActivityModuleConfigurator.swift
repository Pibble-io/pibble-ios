//
//  WalletActivityModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletActivityModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, [WalletActivity.SelectedSegment: ConfigurableModule])
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let segments):
      return (V: WalletActivityViewController.self,
              I: WalletActivityInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                          walletService: diContainer.walletService,
                                          accountProfileService: diContainer.accountProfileService),
              P: WalletActivityPresenter(),
              R: WalletActivityRouter(contentModules: segments))
    }
  }
}
