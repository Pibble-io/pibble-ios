//
//  TestFourModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum TestFourModuleConfigurator: ModuleConfigurator {
  case defaultConfig
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig:
      return (V: TestFourViewController.self,
              I: TestFourInteractor(),
              P: TestFourPresenter(),
              R: TestFourRouter())
    }
  }
}
