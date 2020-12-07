//
//  CoreDataDeleteAsyncOperation.swift
//  Pibble
//
//  Created by Kazakov Sergey on 02.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

class CoreDataDeleteOperation: Operation {
  fileprivate let context: NSManagedObjectContext
  fileprivate let objects: [CoreDataStorableEntity]
  fileprivate let shouldSave: Bool
  fileprivate let batchSize: Int
  
  init(objects: [CoreDataStorableEntity], context: NSManagedObjectContext, shouldSave: Bool, batchSize: Int) {
    self.objects = objects
    self.shouldSave = shouldSave
    self.batchSize = batchSize
    self.context = context
    super.init()
  }
  
  override func main() {
    AppLogger.debug("pending: \(objects.count)")
    context.performAndWait {
      objects.forEach {
        $0.delete(in: context)
      }
      
      if shouldSave {
        context.saveIfNeeded(batchSize: batchSize)
      }
    }
  }
}

class CoreDataDeleteAsyncOperation: AsyncOperation {
  fileprivate let objects: [CoreDataStorableEntity]
  fileprivate let persistentContainer: NSPersistentContainer
  
  init(objects: [CoreDataStorableEntity], persistentContainer: NSPersistentContainer) {
    self.objects = objects
    self.persistentContainer = persistentContainer
  }
  
  override func main() {
    if isCancelled {
      return
    }
    persistentContainer.performBackgroundTask { [weak self ](context) in
      guard let strongSelf = self else {
        return
      }
      strongSelf.objects.forEach {
        $0.delete(in: context)
      }
      
      context.saveIfNeeded()
      strongSelf.finish()
    }
  }
}
