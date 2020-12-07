//
//  CoreDataStorageService.swift
//  Pibble
//
//  Created by Kazakov Sergey on 03.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

class CoreDataCustomStackStorageService {
  fileprivate var pendingObjects: [CoreDataStorableEntity] = []
  fileprivate let delayBlock = DelayBlockObject()
  fileprivate let longDelayBlock = DelayBlockObject()
  fileprivate let modelName = "PibbleModel"
  fileprivate lazy var operationsQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Core Data save queue"
    queue.qualityOfService = .utility
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
 
  private lazy var managedObjectModel: NSManagedObjectModel = {
    guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
      fatalError("Unable to Find Data Model")
    }

    guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Unable to Load Data Model")
    }

    return managedObjectModel
  }()
  
  private(set) lazy var mainContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    managedObjectContext.automaticallyMergesChangesFromParent = true
    managedObjectContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    return managedObjectContext
  }()

  private(set) lazy var workerContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator

    return managedObjectContext
  }()

  private(set) lazy var readContext: NSManagedObjectContext = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    managedObjectContext.automaticallyMergesChangesFromParent = true
    return managedObjectContext
  }()

  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

    let fileManager = FileManager.default
    let storeName = "\(modelName).sqlite"

    let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

    let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

    do {
      try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                        configurationName: nil,
                                                        at: persistentStoreURL,
                                                        options: nil)
    } catch {
      fatalError("Unable to Load Persistent Store")
    }

    return persistentStoreCoordinator
  }()

  init() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextDidSave, object: workerContext)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc func managedObjectContextDidSave(notification: Notification) {
    AppLogger.debug("managedObjectContextDidSave")
  }
}

class CoreDataStorageService {
  fileprivate var pendingObjects: [CoreDataStorableEntity] = []
  fileprivate let delayBlock = DelayBlockObject()
  
  fileprivate let modelName: String
  
  fileprivate lazy var operationsQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Core Data \(modelName) save queue"
    queue.qualityOfService = .utility
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
  
  
  fileprivate lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    
    let container = NSPersistentContainer(name: modelName)
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      guard let error = error as NSError? else {
        return
      }
      
      if let url = storeDescription.url {
        try? container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
        AppLogger.debug("Destroying old persistent store")
      }
      
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        guard let error = error as NSError? else {
          return
        }
        
        fatalError("Unresolved error \(error), \(error.userInfo)")
      })
    })
    
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.undoManager = nil
    return container
  }()
  
  lazy var workerContext: NSManagedObjectContext = {
    let context = persistentContainer.newBackgroundContext()
    context.undoManager = nil
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return context
  }()
  
  init(model: CoreDataModelType) {
    modelName = model.rawValue
  }
}

extension CoreDataStorageService: CoreDataStorageServiceProtocol {
  func updateTemporaryStorage(with objects: [CoreDataStorableEntity]) {
    let operation = CoreDataUpdateOperation(objects: objects, context: viewContext, shouldSave: false,  batchSize: 1)
    OperationQueue.main.addOperation(operation)
  }
  
  func releaseTemporaryStorage() {
    viewContext.rollback()
  }
  
  func removeFromTemporaryStorage(objects: [CoreDataStorableEntity]) {
    let operation = CoreDataDeleteOperation(objects: objects, context: viewContext, shouldSave: false, batchSize: 1)
    OperationQueue.main.addOperation(operation)
  }
  
  func batchUpdateStorage(with objects: [CoreDataStorableEntity]) {
    batchUpdateStorage(with: objects, batchSize: 1, delay: 0.5)
  }
  
  fileprivate func batchUpdateStorage(with objects: [CoreDataStorableEntity], batchSize: Int, delay: TimeInterval = 0.5) {
    pendingObjects.append(contentsOf: objects)
    delayBlock.cancel()
    
    delayBlock.scheduleAfter(delay: delay) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      let operation = CoreDataUpdateOperation(objects: strongSelf.pendingObjects, context: strongSelf.workerContext, shouldSave: true, batchSize: batchSize)
      
      strongSelf.operationsQueue.addOperation(operation)
      strongSelf.pendingObjects = []
    }
  }
  
  func updateStorage(with objects: [CoreDataStorableEntity]) {
    let operation = CoreDataUpdateOperation(objects: objects, context: workerContext, shouldSave: true, batchSize: 1)
    
    operationsQueue.addOperation(operation)
//    batchUpdateStorage(with: objects, batchSize: 1, delay: 0.05)
  }
  
  func batchUpdateObjects<T: NSManagedObject>(_ entityType: T.Type, predicate: NSPredicate, propertiesToUpdate: [String: Any]) {
    batchUpdateObjects(entityType, predicate: predicate, propertiesToUpdate: propertiesToUpdate, completeHandler: nil)
  }
  
  func batchUpdateObjects<T: NSManagedObject>(_ entityType: T.Type, predicate: NSPredicate, propertiesToUpdate: [String: Any], completeHandler: EmptyCompleteHandler?) {
    
    let batchUpdateOperation = BlockOperation() { [weak self] in
      do {
        guard let strongSelf = self else {
          return
        }
        
        let batchRequest = NSBatchUpdateRequest(entity: entityType.entity())
        batchRequest.predicate = predicate
        batchRequest.propertiesToUpdate = propertiesToUpdate
        batchRequest.resultType = NSBatchUpdateRequestResultType.updatedObjectIDsResultType
        
        let result = try strongSelf.workerContext.execute(batchRequest) as? NSBatchUpdateResult
        guard let objectIDArray = result?.result as? [NSManagedObjectID] else {
          return
        }
        
        let changes = [NSUpdatedObjectsKey : objectIDArray]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [strongSelf.viewContext, strongSelf.workerContext])
      } catch {
        AppLogger.error("batchUpdate error: \(error)")
      }
    }
    
    batchUpdateOperation.completionBlock = {
      DispatchQueue.main.async {
        completeHandler?()
      }
    }
    
    operationsQueue.addOperation(batchUpdateOperation)
  }
  
  func removeFromStorage(objects: [CoreDataStorableEntity]) {
    let operation = CoreDataDeleteOperation(objects: objects, context: workerContext, shouldSave: true, batchSize: 1)
    operationsQueue.addOperation(operation)
  }
  
  var viewContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
}


