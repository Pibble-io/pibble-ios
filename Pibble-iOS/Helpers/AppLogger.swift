//
//  Logger.swift
//  Pibble
//
//  Created by Sergey Kazakov on 13/07/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import SwiftyBeaver
import Crashlytics

enum AppLogger {
  static let logger: SwiftyBeaver.Type = {
    let log = SwiftyBeaver.self
    
    let console = ConsoleDestination()  // l
//    console.format =  "$DHH:mm:ss$d $L $M"
    log.addDestination(console)
    
    return log
  }()
  
  
  static func trace(_ items: Any..., function: String = #function) {
    logger.verbose(items, function)
  }
  
  static func info(_ items: Any..., function: String = #function) {
    logger.info(items, function)
  }
  
  static func notice(_ items: Any..., function: String = #function) {
    logger.verbose(items, function)
  }
  
  static func debug(_ items: Any..., function: String = #function) {
    logger.debug(items, function)
  }
  
  static func warning(_ items: Any..., function: String = #function) {
    logger.warning(items, function)
  }
  
  static func error(_ items: Any..., function: String = #function) {
    let msg = items.map { "\($0)"}.joined(separator: " ")
    Answers.logCustomEvent(withName: "Error", customAttributes: ["Message": msg])
    logger.error(items, function)
  }
  
  static func critical(_ items: Any..., function: String = #function) {
    logger.error(items, function)
  }
}
