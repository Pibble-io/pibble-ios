//
//  SettingsHomeModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum SettingsHomeModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: SettingsHomeViewController.self,
              I: SettingsHomeInteractor(accountProfileService: diContainer.accountProfileService, authService: diContainer.loginService),
              P: SettingsHomePresenter(),
              R: SettingsHomeRouter())
    }
  }
}
