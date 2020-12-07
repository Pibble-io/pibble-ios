//
//  TopBannerInfoModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum TopBannerInfoModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: TopBannerInfoViewController.self,
              I: TopBannerInfoInteractor(accountProfileService: diContainer.accountProfileService),
              P: TopBannerInfoPresenter(),
              R: TopBannerInfoRouter())
    }
  }
}
