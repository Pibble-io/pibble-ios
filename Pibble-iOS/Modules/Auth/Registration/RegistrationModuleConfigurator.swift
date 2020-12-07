//
//  RegistrationModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 16.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum RegistrationModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: RegistrationViewController.self,
              I: RegistrationInteractor(loginService: diContainer.loginService),
              P: RegistrationPresenter(),
              R: RegistrationRouter())
    }
  }
  
}
