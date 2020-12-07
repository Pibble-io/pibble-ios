//
//  AboutHomeModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

enum AboutHome {
  enum AboutHomeItems: Int {
    case commerce
    case croudFunding
    case album
    case event
    case notifications
    case logout
    
    static let allCases: [AboutHomeItems] = Array(AboutHomeItems.commerce.rawValue...AboutHomeItems.notifications.rawValue)
     .map { return AboutHomeItems(rawValue: $0)! }
  }
  
  
}
