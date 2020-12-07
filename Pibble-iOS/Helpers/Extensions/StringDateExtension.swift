//
//  StringDateExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 04.10.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

extension String {
  fileprivate static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = PibbleBackendAPI.dateStringFormat
    return dateFormatter
  }()
  
  func toDateWithCommonFormat() -> Date? {
    return String.dateFormatter.date(from: self)
  }
}
