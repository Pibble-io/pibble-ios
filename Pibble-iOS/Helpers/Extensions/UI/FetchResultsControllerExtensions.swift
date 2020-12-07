//
//  FetchResultsControllerExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension NSFetchedResultsController {
  @objc var hasData: Bool {
    let nonEmptySection = sections?.first { return $0.numberOfObjects > 0  }
    guard let _ = nonEmptySection else {
      return false
    }
    
    return true
  }
}
