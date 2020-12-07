//
//  AccountSettingsModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum AccountSettingsModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: AccountSettingsViewController.self,
              I: AccountSettingsInteractor(accountProfileService: diContainer.accountProfileService,
                                           appSettingsService: diContainer.appSettingsService),
              P: AccountSettingsPresenter(),
              R: AccountSettingsRouter())
    }
  }
}
