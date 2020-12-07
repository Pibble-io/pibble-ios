//
//  AboutModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum AboutModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: AboutViewController.self,
              I: AboutInteractor(accountProfileService: diContainer.accountProfileService),
              P: AboutPresenter(),
              R: AboutRouter())
    }
  }
}
