//
//  NotificationsFeedModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum NotificationsFeedModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: NotificationsFeedViewController.self,
              I: NotificationsFeedInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                             notificationsFeedService: diContainer.notificationsFeedService,
                                             userInteractionsService: diContainer.userInteractionService,
                                             accountProfileService: diContainer.accountProfileService),
              P: NotificationsFeedPresenter(),
              R: NotificationsFeedRouter())
    }
  }
}
