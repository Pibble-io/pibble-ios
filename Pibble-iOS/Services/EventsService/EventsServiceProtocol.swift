//
//  EventsServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 17/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol EventsServiceProtocol {
  func saveEvents(_ events: [InteractionEventProtocol], complete: @escaping CompleteHandler)
}
