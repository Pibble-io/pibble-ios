//
//  CreatePostHelpModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/09/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum CreatePostHelpModuleConfigurator: ModuleConfigurator {
  case defaultConfig(CreatePostHelpDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let delegate):
      return (V: CreatePostHelpViewController.self,
              I: CreatePostHelpInteractor(),
              P: CreatePostHelpPresenter(delegate: delegate),
              R: CreatePostHelpRouter())
    }
  }
}
