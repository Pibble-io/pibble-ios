//
//  RestorePasswordMethodModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum RestorePasswordMethodModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, RestorePasswordMethod.Purpose)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let purpose):
      return (V: RestorePasswordMethodViewController.self,
              I: RestorePasswordMethodInteractor(accountProfileService: diContainer.accountProfileService,
                                                 authService: diContainer.loginService,
                                                 purpose: purpose),
              P: RestorePasswordMethodPresenter(),
              R: RestorePasswordMethodRouter())
    }
  }
}
