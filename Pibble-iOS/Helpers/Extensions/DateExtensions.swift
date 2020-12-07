//
//  DateExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 31/05/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

extension Date {
  var hasPassed: Bool {
    return timeIntervalSinceNow.isLess(than: 0.0)
  }
  
  var toNSDate: NSDate {
    return NSDate(timeIntervalSince1970: timeIntervalSince1970)
  }
  
  func dateByRemovingTimeComponent() -> Date {
    guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
      return self
    }
    return date
  }
}

extension NSDate {
  var toDate: Date {
    return Date(timeIntervalSince1970: timeIntervalSince1970)
  }
}


