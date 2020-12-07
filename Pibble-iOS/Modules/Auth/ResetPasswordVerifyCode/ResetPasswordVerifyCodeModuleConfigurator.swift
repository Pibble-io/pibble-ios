//
//  ResetPasswordVerifyCodeModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum ResetPasswordVerifyCodeModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, ResetPasswordVerifyCode.Purpose)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let container, let purpose):
      return (V: ResetPasswordVerifyCodeViewController.self,
              I: ResetPasswordVerifyCodeInteractor(loginService: container.loginService,
                                                   purpose: purpose),
              P: ResetPasswordVerifyCodePresenter(),
              R: ResetPasswordVerifyCodeRouter())
    }
  }
}
