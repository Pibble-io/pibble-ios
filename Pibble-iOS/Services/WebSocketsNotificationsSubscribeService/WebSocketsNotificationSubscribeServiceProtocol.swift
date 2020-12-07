//
//  WebSocketsNotificationSubscribeServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 01/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol WebSocketsNotificationDelegateProtocol: class {
  func handleEvent(_ event: WebSocketsEvent)
}

protocol WebSocketsNotificationSubscribeServiceProtocol {
  func subscribe(_ delegate: WebSocketsNotificationDelegateProtocol)
  func unsubscribe()
}
