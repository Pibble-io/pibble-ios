//
//  CommerceTypePickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum CommerceTypePickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: CommerceTypePickViewController.self,
              I: CommerceTypePickInteractor(accountProfileService: diContainer.accountProfileService),
              P: CommerceTypePickPresenter(),
              R: CommerceTypePickRouter())
    }
  }
}
