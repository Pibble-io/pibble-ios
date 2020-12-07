//
//  ChatRoomGroupsContentModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum ChatRoomGroupsContentModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer):
      return (V: ChatRoomGroupsContentViewController.self,
              I: ChatRoomGroupsContentInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                                 chatService: diContainer.chatService,
                                                 accountProfileService: diContainer.accountProfileService,
                                                 webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService),
              P: ChatRoomGroupsContentPresenter(),
              R: ChatRoomGroupsContentRouter())
    }
  }
}
