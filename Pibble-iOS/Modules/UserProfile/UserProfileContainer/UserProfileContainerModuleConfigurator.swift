//
//  UserProfileContainerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UserProfileContainerModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, UserProfileContent.TargetUser)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer,let targetUser):
      return (V: UserProfileContainerViewController.self,
              I: UserProfileContainerInteractor(userInteractionService: diContainer.userInteractionService,
                                                coreDataStorageService: diContainer.coreDataStorageService,
                                                authService: diContainer.loginService,
                                                targetUser: targetUser),
              P: UserProfileContainerPresenter(),
              R: UserProfileContainerRouter())
    }
  }
}
