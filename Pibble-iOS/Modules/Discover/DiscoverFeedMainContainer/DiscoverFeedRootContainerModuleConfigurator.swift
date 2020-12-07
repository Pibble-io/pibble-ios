//
//  DiscoverFeedRootContainerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum DiscoverFeedRootContainerModuleConfigurator: ModuleConfigurator {
  case defaultConfig
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig:
      return (V: DiscoverFeedRootContainerViewController.self,
              I: DiscoverFeedRootContainerInteractor(),
              P: DiscoverFeedRootContainerPresenter(),
              R: DiscoverFeedRootContainerRouter())
    }
  }
}
