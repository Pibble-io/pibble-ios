//
//  UpvotedUsersModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UpvotedUsersModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, UpvotedUsers.UpvotedContentType, UpvotePickDelegateProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let contentType, let delegate):
      return (V: UpvotedUsersViewController.self,
              I: UpvotedUsersInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                        postingService: diContainer.postingService,
                                        userInteractionsService: diContainer.userInteractionService,
                                        contentType: contentType),
              P: UpvotedUsersPresenter(delegate: delegate),
              R: UpvotedUsersRouter())
    }
  }
}
