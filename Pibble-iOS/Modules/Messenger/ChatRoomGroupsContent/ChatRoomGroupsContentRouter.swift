//
//  ChatRoomGroupsContentRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ChatRoomGroupsContentRouter class
final class ChatRoomGroupsContentRouter: Router {
  
}

// MARK: - ChatRoomGroupsContentRouter API
extension ChatRoomGroupsContentRouter: ChatRoomGroupsContentRouterApi {
  func routeToChatRoomsFor(_ group: ChatRoomsGroupProtocol) {
    let configurator = ChatRoomsModuleConfigurator.chatRoomsForGroupConfig(AppModules.servicesContainer,
                                                                 .chatRoomsForExistingGroup(group))
    AppModules
      .Messenger
      .chatRooms(.chatRoomsForExistingGroup(group))
      .build(configurator: configurator)?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - ChatRoomGroupsContent Viper Components
fileprivate extension ChatRoomGroupsContentRouter {
  var presenter: ChatRoomGroupsContentPresenterApi {
    return _presenter as! ChatRoomGroupsContentPresenterApi
  }
}
