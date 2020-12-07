//
//  SearchResultDetailContainerModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum SearchResultDetailContainerModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, SearchResultDetailContainer.ContentType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let targetUser):
      return (V: SearchResultDetailContainerViewController.self,
              I: SearchResultDetailContainerInteractor(userInteractionService: diContainer.userInteractionService,
                                                       tagService: diContainer.tagService,
                                                       targetUser: targetUser),
              P: SearchResultDetailContainerPresenter(),
              R: SearchResultDetailContainerRouter())
    }
  }
}
