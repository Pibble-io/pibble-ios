//
//  DescriptionPickModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum DescriptionPickModuleConfigurator: ModuleConfigurator {
  case defaultConfig(DescriptionPickDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let descriptionPickDelegate):
      return (V: DescriptionPickViewController.self,
              I: DescriptionPickInteractor(),
              P: DescriptionPickPresenter(delegate: descriptionPickDelegate),
              R: DescriptionPickRouter())
    }
  }
}
