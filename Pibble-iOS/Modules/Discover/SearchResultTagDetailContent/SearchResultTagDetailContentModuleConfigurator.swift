//
//  SearchResultTagDetailContentModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum SearchResultTagDetailContentModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, TagProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let tag):
      return (V: SearchResultTagDetailContentViewController.self,
              I: SearchResultTagDetailContentInteractor(tagService: diContainer.tagService,
                                                        coreDataStorage: diContainer.coreDataStorageService,
                                                        tag: tag),
              P: SearchResultTagDetailContentPresenter(),
              R: SearchResultTagDetailContentRouter())
    }
  }
}
