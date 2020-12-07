//
//  ResetPasswordModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum ResetPasswordModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, String)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let countainer, let code):
      return (V: ResetPasswordViewController.self,
              I: ResetPasswordInteractor(loginService: countainer.loginService, code: code),
              P: ResetPasswordPresenter(),
              R: ResetPasswordRouter())
    }
  }
}
