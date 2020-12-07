//
//  PushNotificationServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 22/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

protocol PushNotificationServiceProtocol {
  func registerForPushNotifications()
  
  func removeCurrentDeviceToken()
}
