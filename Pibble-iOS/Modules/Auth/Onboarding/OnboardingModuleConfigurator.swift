//
//  OnboardingModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 04/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum OnboardingModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: OnboardingViewController.self,
              I: OnboardingInteractor(authService: diContainer.loginService),
              P: OnboardingPresenter(),
              R: OnboardingRouter())
    }
  }
}
