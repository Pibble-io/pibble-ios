//
//  VerifyCodeModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum VerifyCodeModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, VerifyCode.Purpose)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let container, let purpose):
      return
        (V: VerifyCodeViewController.self,
         I: VerifyCodeInteractor(loginService: container.loginService, purpose: purpose),
         P: VerifyCodePresenter(),
         R: VerifyCodeRouter())
    }
  }
}
