//
//  ChatRoomsContainerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum ChatRoomsContainerModuleConfigurator: ModuleConfigurator {
  case defaultConfig
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig:
      return (V: ChatRoomsContainerViewController.self,
              I: ChatRoomsContainerInteractor(),
              P: ChatRoomsContainerPresenter(),
              R: ChatRoomsContainerRouter())
    }
  }
}
