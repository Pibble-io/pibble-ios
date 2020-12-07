//
//  TrackedEventsProcessingServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 14/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol EventsTrackingServiceProtocol {
  var notificationNameKey: NSNotification.Name { get }
  var notificationEventKey: String { get }
  
  func trackEvent(_ event: InteractionEventProtocol)
}
