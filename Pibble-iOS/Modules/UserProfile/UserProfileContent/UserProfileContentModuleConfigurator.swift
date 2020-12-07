//
//  UserProfileContentModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum UserProfileContentModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, UserProfileContent.TargetUser)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let targetUser):
      return (V: UserProfileContentViewController.self,
              I: UserProfileContentInteractor(userInteractionService: diContainer.userInteractionService,
                                              storageService: diContainer.coreDataStorageService,
                                              mediaLibraryExportService: diContainer.mediaLibraryExportService, accountProfileService: diContainer.accountProfileService,
                                              targetUser: targetUser),
              P: UserProfileContentPresenter(),
              R: UserProfileContentRouter())
    }
  }
}
