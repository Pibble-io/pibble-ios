//
//  AboutHomeModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum AboutHomeModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: AboutHomeViewController.self,
              I: AboutHomeInteractor(authService: diContainer.loginService),
              P: AboutHomePresenter(),
              R: AboutHomeRouter())
    }
  }
}
