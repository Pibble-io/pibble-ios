//
//  GiftsFeedModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum GiftsFeedModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, GiftsFeed.ContentType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let contentType):
      return (V: GiftsFeedViewController.self,
              I: GiftsFeedInteractor(accountProfileService: diContainer.accountProfileService, contentType: contentType),
              P: GiftsFeedPresenter(),
              R: GiftsFeedRouter())
    }
  }
}
