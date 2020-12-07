//
//  TimeIntervalExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 05.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

extension TimeInterval {
  var formattedMinutesSecondsTimeString: String {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    return formatter.string(from: self)!
  }
  
  var formattedHoursMinutesSecondsTimeString: String {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .brief
    return formatter.string(from: self)!
  }
  
  var formattedSecondsString: String {
    let formatter = DateComponentsFormatter()
    formatter.zeroFormattingBehavior = .dropAll
    formatter.allowedUnits = [.second]
    return formatter.string(from: self)!
  }
}

