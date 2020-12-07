//
//  ResetPasswordWithEmailModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum ResetPasswordWithEmailModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: ResetPasswordWithEmailViewController.self,
              I: ResetPasswordWithEmailInteractor(loginService: diContainer.loginService),
              P: ResetPasswordWithEmailPresenter(),
              R: ResetPasswordWithEmailRouter())
    }
  }
}
