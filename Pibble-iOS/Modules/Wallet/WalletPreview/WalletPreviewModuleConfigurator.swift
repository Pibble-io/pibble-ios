//
//  WalletPreviewModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletPreviewModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: WalletPreviewViewController.self,
              I: WalletPreviewInteractor(accountProfileService: diContainer.accountProfileService),
              P: WalletPreviewPresenter(),
              R: WalletPreviewRouter())
    }
  }
}
