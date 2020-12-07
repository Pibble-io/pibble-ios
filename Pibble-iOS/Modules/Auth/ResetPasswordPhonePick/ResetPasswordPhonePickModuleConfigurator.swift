//
//  ResetPasswordPhonePickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 26.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum ResetPasswordPhonePickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let container):
      return (V: ResetPasswordPhonePickViewController.self,
              I: ResetPasswordPhonePickInteractor(loginService: container.loginService),
              P: ResetPasswordPhonePickPresenter(),
              R: ResetPasswordPhonePickRouter())
    }
  }
}
