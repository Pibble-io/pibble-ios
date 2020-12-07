//
//  Date+TimeAgo.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

struct DateComponentUnitFormatter {
  
  private struct DateComponentUnitFormat {
    let unit: Calendar.Component
    
    let singularUnit: String
    let pluralUnit: String
    
    let futureSingular: String
    let pastSingular: String
  }
  
  private let formats: [DateComponentUnitFormat] = [
    
    DateComponentUnitFormat(unit: .year,
                            singularUnit: "year",
                            pluralUnit: "years",
                            futureSingular: "Next year",
                            pastSingular: "Last year"),
    
    DateComponentUnitFormat(unit: .month,
                            singularUnit: "month",
                            pluralUnit: "months",
                            futureSingular: "Next month",
                            pastSingular: "Last month"),
    
    DateComponentUnitFormat(unit: .weekOfYear,
                            singularUnit: "week",
                            pluralUnit: "weeks",
                            futureSingular: "Next week",
                            pastSingular: "Last week"),
    
    DateComponentUnitFormat(unit: .day,
                            singularUnit: "day",
                            pluralUnit: "days",
                            futureSingular: "Tomorrow",
                            pastSingular: "Yesterday"),
    
    DateComponentUnitFormat(unit: .hour,
                            singularUnit: "hour",
                            pluralUnit: "hours",
                            futureSingular: "In an hour",
                            pastSingular: "An hour ago"),
    
    DateComponentUnitFormat(unit: .minute,
                            singularUnit: "minute",
                            pluralUnit: "minutes",
                            futureSingular: "In a minute",
                            pastSingular: "A minute ago"),
    
    DateComponentUnitFormat(unit: .second,
                            singularUnit: "second",
                            pluralUnit: "seconds",
                            futureSingular: "Just now",
                            pastSingular: "Just now"),
    
    ]
  
  private let compactFormats: [DateComponentUnitFormat] = [
    
    DateComponentUnitFormat(unit: .year,
                            singularUnit: "y",
                            pluralUnit: "y",
                            futureSingular: "Next year",
                            pastSingular: "Last year"),
    
    DateComponentUnitFormat(unit: .month,
                            singularUnit: "m",
                            pluralUnit: "m",
                            futureSingular: "Next month",
                            pastSingular: "Last month"),
    
    DateComponentUnitFormat(unit: .weekOfYear,
                            singularUnit: "w",
                            pluralUnit: "w",
                            futureSingular: "Next week",
                            pastSingular: "Last week"),
    
    DateComponentUnitFormat(unit: .day,
                            singularUnit: "d",
                            pluralUnit: "d",
                            futureSingular: "Tomorrow",
                            pastSingular: "Yesterday"),
    
    DateComponentUnitFormat(unit: .hour,
                            singularUnit: "h",
                            pluralUnit: "h",
                            futureSingular: "In an hour",
                            pastSingular: "An hour ago"),
    
    DateComponentUnitFormat(unit: .minute,
                            singularUnit: "m",
                            pluralUnit: "m",
                            futureSingular: "In a minute",
                            pastSingular: "A minute ago"),
    
    DateComponentUnitFormat(unit: .second,
                            singularUnit: "s",
                            pluralUnit: "s",
                            futureSingular: "Just now",
                            pastSingular: "Just now"),
    
    ]
  
  func string(forDateComponents dateComponents: DateComponents, useNumericDates: Bool, useCompactDates: Bool) -> String {
    for format in formats {
      let unitValue: Int
      
      switch format.unit {
      case .year:
        unitValue = dateComponents.year ?? 0
      case .month:
        unitValue = dateComponents.month ?? 0
      case .weekOfYear:
        unitValue = dateComponents.weekOfYear ?? 0
      case .day:
        unitValue = dateComponents.day ?? 0
      case .hour:
        unitValue = dateComponents.hour ?? 0
      case .minute:
        unitValue = dateComponents.minute ?? 0
      case .second:
        unitValue = dateComponents.second ?? 0
      default:
        assertionFailure("Date does not have requried components")
        return ""
      }
      
      switch unitValue {
      case 2 ..< Int.max:
        return "\(unitValue) \(format.pluralUnit) ago"
      case 1:
        return useNumericDates ? "\(unitValue) \(format.singularUnit) ago" : format.pastSingular
      case -1:
        return useNumericDates ? "In \(-unitValue) \(format.singularUnit)" : format.futureSingular
      case Int.min ..< -1:
        return "In \(-unitValue) \(format.pluralUnit)"
      default:
        break
      }
    }
    
    return "Just now"
  }
  
  func compactString(forDateComponents dateComponents: DateComponents, useNumericDates: Bool, useCompactDates: Bool) -> String {
    for format in compactFormats {
      let unitValue: Int
      
      switch format.unit {
      case .year:
        unitValue = dateComponents.year ?? 0
      case .month:
        unitValue = dateComponents.month ?? 0
      case .weekOfYear:
        unitValue = dateComponents.weekOfYear ?? 0
      case .day:
        unitValue = dateComponents.day ?? 0
      case .hour:
        unitValue = dateComponents.hour ?? 0
      case .minute:
        unitValue = dateComponents.minute ?? 0
      case .second:
        unitValue = dateComponents.second ?? 0
      default:
        assertionFailure("Date does not have requried components")
        return ""
      }
      
      switch unitValue {
      case 2 ..< Int.max:
        return "\(unitValue)\(format.pluralUnit)"
      case 1:
        return useNumericDates ? "\(unitValue)\(format.singularUnit)" : format.pastSingular
      case -1:
        return useNumericDates ? "In \(-unitValue)\(format.singularUnit)" : format.futureSingular
      case Int.min ..< -1:
        return "In \(-unitValue)\(format.pluralUnit)"
      default:
        break
      }
    }
    
    return "Just now"
  }
}

extension Date {
  
  func timeAgoSinceNow(useNumericDates: Bool = false, useCompactDates: Bool = false) -> String {
    
    let calendar = Calendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = Date()
    let components = calendar.dateComponents(unitFlags, from: self, to: now)
    
    let formatter = DateComponentUnitFormatter()
    
    return useCompactDates ?
      formatter.compactString(forDateComponents: components, useNumericDates: useNumericDates, useCompactDates: useCompactDates) :
      formatter.string(forDateComponents: components, useNumericDates: useNumericDates, useCompactDates: useCompactDates)
  }
}
