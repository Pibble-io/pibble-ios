//
//  CompleteHandlers.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 14.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

typealias ResultCompleteHandler<T, E: PibbleErrorProtocol> = (Result<T, E>) -> ()
typealias EmptyCompleteHandler = () -> Void
typealias CompleteHandler = (Error?) -> ()
typealias ErrorHandler = (Error) -> ()

enum Result<T, Error: Swift.Error> {
  case success(T)
  case failure(Error)

  init(value: T) {
    self = .success(value)
  }

  init(error: Error) {
    self = .failure(error)
  }
}
