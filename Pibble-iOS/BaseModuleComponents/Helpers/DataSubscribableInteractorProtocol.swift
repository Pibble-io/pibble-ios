//
//  DataSubscribableInteractorProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 21/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol DataSubscribableInteractorProtocol {
  func subscribeDataUpdates()
  
  func unsubscribeDataUpdates()
}
