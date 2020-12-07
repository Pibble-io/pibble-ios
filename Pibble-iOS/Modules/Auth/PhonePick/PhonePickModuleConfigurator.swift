//
//  PhonePickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum PhonePickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: PhonePickViewController.self,
              I: PhonePickInteractor(loginService: diContainer.loginService),
              P: PhonePickPresenter(),
              R: PhonePickRouter())
    }
  }
}
