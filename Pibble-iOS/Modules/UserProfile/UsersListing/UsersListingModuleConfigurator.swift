//
//  UsersListingModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UsersListingModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, UsersListing.ContentType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let filterType):
      return (V: UsersListingViewController.self,
              I: UsersListingInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                        userInteractionService: diContainer.userInteractionService,
                                        tagService: diContainer.tagService,
                                        filterType: filterType),
              P: UsersListingPresenter(),
              R: UsersListingRouter())
    }
  }
}
