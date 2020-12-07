//
//  NSManagedObjectContextExtension.swift
//  Pibble
//
//  Created by Kazakov Sergey on 03.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
  func saveIfNeeded(batchSize: Int = 1) {
    guard hasChanges else {
      return
    }
    
    let pendingObjectsMinCount = max(batchSize, 1)
    
    let pendingObjectsCount = (insertedObjects.count + deletedObjects.count + updatedObjects.filter({ $0.hasPersistentChangedValues }).count)
    let shouldSave = pendingObjectsCount >= pendingObjectsMinCount
 
    AppLogger.debug("objects to save \(pendingObjectsCount)")
    
    if shouldSave {
      do {
        AppLogger.debug("Core Data Save")
        try save()
      } catch {
        AppLogger.error("Core Data Error \(error)")
      }
    }
  }
}
