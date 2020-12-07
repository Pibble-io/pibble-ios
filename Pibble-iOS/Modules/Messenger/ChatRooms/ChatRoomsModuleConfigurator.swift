//
//  ChatRoomsModuleConfigurator.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 16/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum ChatRoomsModuleConfigurator: ModuleConfigurator {
  case defaultConfig(ServiceContainerProtocol, ChatRooms.ContentType)
  case chatRoomsForGroupConfig(ServiceContainerProtocol, ChatRooms.ContentType)
  case contentConfig(ServiceContainerProtocol, ChatRooms.ContentType)
  
  var components: ModuleComponents {
    switch self {
    case .defaultConfig(let diContainer, let contentType):
      return (V: ChatRoomsViewController.self,
              I: ChatRoomsInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                     chatService: diContainer.chatService,
                                     accountProfileService: diContainer.accountProfileService,
                                     webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService, contentType: contentType),
              P: ChatRoomsPresenter(),
              R: ChatRoomsRouter())
    case .chatRoomsForGroupConfig(let diContainer, let contentType):
      return (V: ChatRoomsForGroupViewController.self,
              I: ChatRoomsInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                     chatService: diContainer.chatService,
                                     accountProfileService: diContainer.accountProfileService,
                                     webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService, contentType: contentType),
              P: ChatRoomsPresenter(),
              R: ChatRoomsRouter())
    case .contentConfig(let diContainer, let contentType):
      return (V: ChatRoomsContentViewController.self,
              I: ChatRoomsInteractor(coreDataStorage: diContainer.coreDataStorageService,
                                     chatService: diContainer.chatService,
                                     accountProfileService: diContainer.accountProfileService,
                                     webSocketsNotificationSubscribeService: diContainer.webSocketsNotificationSubscribeService, contentType: contentType),
              P: ChatRoomsPresenter(),
              R: ChatRoomsRouter())
    }
  }
}
