//
//  NumericExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 24/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

extension Double {
  func toInt() -> Int? {
    if self >= Double(Int.min) && self < Double(Int.max) {
      return Int(self)
    } else {
      return nil
    }
  }
}
