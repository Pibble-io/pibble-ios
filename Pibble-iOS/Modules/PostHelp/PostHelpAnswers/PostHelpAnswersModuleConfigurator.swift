//
//  PostHelpAnswersModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum PostHelpAnswersModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PostHelpRequestProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let postHelpRequest):
      return (V: PostHelpAnswersViewController.self,
              I: PostHelpAnswersInteractor(coreDataStorage: diContainer.coreDataStorageService,  accountProfileService: diContainer.accountProfileService,
                                    postHelpService: diContainer.postHelpService,
                                    eventTrackingService: diContainer.eventTrackingService,
                                    postHelpRequest: postHelpRequest),
              P: PostHelpAnswersPresenter(),
              R: PostHelpAnswersRouter())
    }
  }
}
