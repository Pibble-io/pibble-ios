//
//  SignInModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 21.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum SignInModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: SignInViewController.self,
              I: SignInInteractor(loginService: diContainer.loginService, accountProfileService: diContainer.accountProfileService),
              P: SignInPresenter(),
              R: SignInRouter())
      
    }
  }
}
