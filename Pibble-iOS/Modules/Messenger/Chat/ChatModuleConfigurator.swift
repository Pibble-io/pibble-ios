//
//  ChatModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum ChatModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, Chat.RoomType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let roomType):
      return (V: ChatViewController.self,
              I: ChatInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                chatService: diContainer.chatService,
                                accountService: diContainer.accountProfileService,
                                walletService: diContainer.walletService,
                                mediaDownloadService: diContainer.mediaDownloadService, webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService,
                                roomType: roomType),
              P: ChatPresenter(),
              R: ChatRouter())
    }
  }
}
