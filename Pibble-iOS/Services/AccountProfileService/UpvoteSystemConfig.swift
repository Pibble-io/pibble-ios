//
//  UpvoteSystemConfig.swift
//  Pibble
//
//  Created by Kazakov Sergey on 07.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

struct UpvoteSystemConfig {
  static let defaultConfig = UpvoteSystemConfig(upvoteMin: 10, upvoteMax: 100, upvoteMaxForHighLevelCoef: 100)
  
  
  fileprivate let upvoteMin: Int
  fileprivate let upvoteMax: Int
  
  fileprivate let upvoteMaxForHighLevelCoef: Int
  
  func upvoteMinForUserLevel(_ level: Int) -> Int {
    return upvoteMin
  }
  
  func upvoteMaxForUserLevel(_ level: Int) -> Int {
    guard level >= 10 else {
      return upvoteMax
    }
    
    return level * upvoteMaxForHighLevelCoef
  }
}
