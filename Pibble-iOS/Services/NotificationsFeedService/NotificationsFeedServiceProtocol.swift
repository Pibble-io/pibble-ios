//
//  NotificationsFeedServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 26/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol NotificationsFeedServiceProtocol {
  func getNotificationsFeed(cursorId: Int?, perPage: Int, complete: @escaping ResultCompleteHandler<([PartialNotificationEntity], PaginationInfoProtocol), PibbleError>)
}
