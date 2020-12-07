//
//  CoreDataUpdateOperation.swift
//  Pibble
//
//  Created by Kazakov Sergey on 07.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

class CoreDataUpdateOperation: Operation {
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
    context.performAndWait {
      objects.forEach {
        $0.updateOrCreateManagedObject(in: context)
      }
      
      if shouldSave {
        context.saveIfNeeded(batchSize: batchSize)
      }
    }
  }
}


class CoreDataUpdateAsyncOperation: AsyncOperation {
  fileprivate let objects: [CoreDataStorableEntity]
  fileprivate let persistentContainer: NSPersistentContainer
  fileprivate let isTemporaryStorage: Bool
  
  init(objects: [CoreDataStorableEntity], persistentContainer: NSPersistentContainer, isTemporaryStorage: Bool = false) {
    self.objects = objects
    self.persistentContainer = persistentContainer
    self.isTemporaryStorage = isTemporaryStorage
  }
  
  override func main() {
    if isCancelled {
      return
    }
    
    guard !isTemporaryStorage else {
      objects.forEach {
        $0.updateOrCreateManagedObject(in: persistentContainer.viewContext)
      }
      finish()
      return
    }
    
    persistentContainer.performBackgroundTask { [weak self ](context) in
      guard let strongSelf = self else {
        return
      }
    
      strongSelf.objects.forEach {
        $0.updateOrCreateManagedObject(in: context)
      }
      
      context.saveIfNeeded()
      strongSelf.finish()
    }
  }
}
