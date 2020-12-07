//
//  BannedUserProfileContentModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 31/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum BannedUserProfileContentModuleConfigurator: ModuleConfigurator {
  case defaultConfig(UserProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let user):
      return (V: BannedUserProfileContentViewController.self,
              I: BannedUserProfileContentInteractor(user: user),
              P: BannedUserProfileContentPresenter(),
              R: BannedUserProfileContentRouter())
    }
  }
}
