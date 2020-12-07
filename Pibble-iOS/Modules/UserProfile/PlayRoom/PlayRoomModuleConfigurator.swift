//
//  PlayRoomModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum PlayRoomModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, PlayRoom.PlayRoomType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let playRoomType):
      return (V: PlayRoomViewController.self,
              I: PlayRoomInteractor(userInteractionService: diContainer.userInteractionService,
                                    accountProfileService: diContainer.accountProfileService,
                                    playRoomType: playRoomType),
              P: PlayRoomPresenter(),
              R: PlayRoomRouter())
    }
  }
}
