//
//  ResetPasswordSuccessModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum ResetPasswordSuccessModuleConfigurator: ModuleConfigurator {
  case defaultConfig
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig:
      return (V: ResetPasswordSuccessViewController.self,
              I: ResetPasswordSuccessInteractor(),
              P: ResetPasswordSuccessPresenter(),
              R: ResetPasswordSuccessRouter())
    }
  }
}
