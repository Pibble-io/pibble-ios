//
//  ResetPasswordEmailSentModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum ResetPasswordEmailSentModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ResetPasswordEmailProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let email):
      return (V: ResetPasswordEmailSentViewController.self,
              I: ResetPasswordEmailSentInteractor(email: email),
              P: ResetPasswordEmailSentPresenter(),
              R: ResetPasswordEmailSentRouter())
    }
  }
}
