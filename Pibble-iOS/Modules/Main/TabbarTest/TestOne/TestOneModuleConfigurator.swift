//
//  TestOneModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum TestOneModuleConfigurator: ModuleConfigurator {
  case defaultConfig
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig:
      return (V: TestOneViewController.self,
              I: TestOneInteractor(),
              P: TestOnePresenter(),
              R: TestOneRouter())
    }
  }
}
