//
//  PartiallyUpdatableProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 22/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol PartiallyUpdatable {
  
}

extension PartiallyUpdatable {
  func setValueIfNotNil<V>(_ path: ReferenceWritableKeyPath<Self, V>, value: V?) where Self: AnyObject {
    guard let newValue = value else {
      return
    }
    
    self[keyPath: path] = newValue
  }
}
