//
//  SuggestionsModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum SuggestionsModuleConfigurator: ModuleConfigurator {
  case defaultConfig
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig:
      return (V: SuggestionsViewController.self,
              I: SuggestionsInteractor(),
              P: SuggestionsPresenter(),
              R: SuggestionsRouter())
    }
  }
}
