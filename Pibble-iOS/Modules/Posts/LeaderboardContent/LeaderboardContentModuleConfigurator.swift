//
//  LeaderboardContentModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum LeaderboardContentModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, LeaderboardType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let leaderboardType):
      return (V: LeaderboardContentViewController.self,
              I: LeaderboardContentInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                              topGroupsService: diContainer.topGroupService, leaderboardType: leaderboardType),
              P: LeaderboardContentPresenter(),
              R: LeaderboardContentRouter())
    }
  }
}
