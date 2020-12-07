//
//  GiftsInviteModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum GiftsInviteModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: GiftsInviteViewController.self,
              I: GiftsInviteInteractor(accountProfileService: diContainer.accountProfileService),
              P: GiftsInvitePresenter(),
              R: GiftsInviteRouter())
    }
  }
}
