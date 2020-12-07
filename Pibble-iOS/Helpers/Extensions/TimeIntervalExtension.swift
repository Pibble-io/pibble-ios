//
//  TimeIntervalExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 27.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

extension TimeInterval {
  static func daysInterval(_ days: Int) -> TimeInterval {
    return 60.0 * 60.0 * 24.0 * Double(days)
  }
  
  static func hoursInterval(_ hours: Int) -> TimeInterval {
    return 60.0 * minutesInterval(1) * Double(hours)
  }
  
  static func minutesInterval(_ minutes: Int) -> TimeInterval {
    return 60.0 * Double(minutes)
  }
  
  static func secondsInterval(_ seconds: Int) -> TimeInterval {
    return Double(seconds)
  }
}
