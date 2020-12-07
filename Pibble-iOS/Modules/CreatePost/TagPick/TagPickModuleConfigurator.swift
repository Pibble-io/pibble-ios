//
//  TagPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum TagPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, TagPickDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let tagPickDelegate):
      return (V: TagPickViewController.self,
              I: TagPickInteractor(postingService: diContainer.postingService),
              P: TagPickPresenter(tagPickDelegate: tagPickDelegate),
              R: TagPickRouter())
    }
  }
}
