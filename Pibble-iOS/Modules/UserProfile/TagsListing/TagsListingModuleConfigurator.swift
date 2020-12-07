//
//  TagsListingModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 14/03/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum TagsListingModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, TagsListing.FilterType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let filterType):
      return (V: TagsListingViewController.self,
              I: TagsListingInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                       tagService: diContainer.tagService,
                                       filterType: filterType),
              P: TagsListingPresenter(),
              R: TagsListingRouter())
    }
  }
}
