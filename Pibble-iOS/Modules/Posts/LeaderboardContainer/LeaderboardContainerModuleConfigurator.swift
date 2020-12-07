//
//  LeaderboardContainerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 19/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum LeaderboardContainerModuleConfigurator: ModuleConfigurator {
  case defaultConfig
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig:
      return (V: LeaderboardContainerViewController.self,
              I: LeaderboardContainerInteractor(),
              P: LeaderboardContainerPresenter(),
              R: LeaderboardContainerRouter())
    }
  }
}
