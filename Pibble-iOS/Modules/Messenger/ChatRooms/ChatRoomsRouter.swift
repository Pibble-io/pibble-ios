//
//  ChatRoomsRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 16/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ChatRoomsRouter class
final class ChatRoomsRouter: Router {
  
}

// MARK: - ChatRoomsRouter API
extension ChatRoomsRouter: ChatRoomsRouterApi {
  func routeToChatRoom(_ room: ChatRoomProtocol) {
    AppModules
      .Messenger
      .chat(.existingRoom(room))
      .build()?
      .router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - ChatRooms Viper Components
fileprivate extension ChatRoomsRouter {
  var presenter: ChatRoomsPresenterApi {
    return _presenter as! ChatRoomsPresenterApi
  }
}
