//
//  UsernamePickerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 21/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum UsernamePickerModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: UsernamePickerViewController.self,
              I: UsernamePickerInteractor(userProfileService: diContainer.accountProfileService),
              P: UsernamePickerPresenter(),
              R: UsernamePickerRouter())
    }
  }
}
