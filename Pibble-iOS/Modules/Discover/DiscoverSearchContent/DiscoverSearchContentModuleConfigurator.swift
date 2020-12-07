//
//  DiscoverSearchContentModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum DiscoverSearchContentModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, DiscoverSearchContent.ContentType, DiscoverSearchContentDelegate)
  case searchHistory(ServiceContainerProtocol, DiscoverSearchContentDelegate)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let contentType, let delegate):
      return (V: DiscoverSearchContentViewController.self,
              I: DiscoverSearchContentInteractor(discoverService: diContainer.discoverService,
                                                 storageService: diContainer.coreDataStorageService,
                                                 contentType: contentType),
              P: DiscoverSearchContentPresenter(delegate: delegate),
              R: DiscoverSearchContentRouter())
    case .searchHistory(let diContainer, let delegate):
      return (V: DiscoverSearchContentViewController.self,
              I: DiscoverSearchContentSearchHistoryInteractor(coreDataStorage: diContainer.coreDataStorageService),
              P: DiscoverSearchContentPresenter(delegate: delegate),
              R: DiscoverSearchContentRouter())
    }
  }
}
