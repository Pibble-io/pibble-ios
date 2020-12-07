//
//  WebSocketServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 18/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol WebSocketServiceProtocol {
  var notificationNameKey: NSNotification.Name { get }
  var notificationEventKey: String { get }
  func connect()
  func disconnect()
}
