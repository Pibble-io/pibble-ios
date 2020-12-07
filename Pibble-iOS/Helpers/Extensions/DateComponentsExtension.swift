//
//  DateComponentsExtension.swift
//  Pibble
//
//  Created by Sergey Kazakov on 08/03/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

extension Date {
  func dateComponent() -> Date? {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
    let date = Calendar.current.date(from: components)
    return date
  }
}
