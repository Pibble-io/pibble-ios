//
//  CommentsModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum CommentsModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PostingProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let posting):
      return (V: CommentsViewController.self,
              I: CommentsInteractor(coreDataStorage: diContainer.coreDataStorageService,  accountProfileService: diContainer.accountProfileService,
                                    postingService: diContainer.postingService,
                                    eventTrackingService: diContainer.eventTrackingService,
                                    posting: posting),
              P: CommentsPresenter(),
              R: CommentsRouter())
    }
  }
}
