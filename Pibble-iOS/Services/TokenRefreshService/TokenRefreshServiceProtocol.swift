//
//  TokenRefreshServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation


enum TokenRefreshResult {
  case noTokenData
  case refreshSuccess
  case tokenIsAlive
  case tokenMalformedError(Error)
  case error(Error)
}

typealias TokenRefreshResultHandler = ((TokenRefreshResult)-> Void)

protocol TokenRefreshServiceProtocol {
  func scheduleTokenRefreshIfNeeded(refreshTokenHandler: @escaping TokenRefreshResultHandler)
}
