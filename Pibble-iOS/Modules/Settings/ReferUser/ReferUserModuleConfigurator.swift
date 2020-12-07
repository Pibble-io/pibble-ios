//
//  ReferUserModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 17/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum ReferUserModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, AccountProfileProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let targetUser):
      return (V: ReferUserViewController.self,
              I: ReferUserInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                     referralUserService: diContainer.referralUserService, targetUser: targetUser),
              P: ReferUserPresenter(),
              R: ReferUserRouter())
    }
  }
}
