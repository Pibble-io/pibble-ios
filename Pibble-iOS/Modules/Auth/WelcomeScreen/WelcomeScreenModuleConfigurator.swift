//
//  WelcomeModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WelcomeScreenModuleConfigurator: ModuleConfigurator {
  case defaultConfig
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig:
      return (V: WelcomeScreenViewController.self,
              I: WelcomeScreenInteractor(),
              P: WelcomeScreenPresenter(),
              R: WelcomeScreenRouter())
    }
  }
}
