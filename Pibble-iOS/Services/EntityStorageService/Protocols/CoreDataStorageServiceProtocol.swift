//
//  StorageServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 03.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStorageServiceProtocol {
  func batchUpdateStorage(with objects: [CoreDataStorableEntity])
  func updateStorage(with objects: [CoreDataStorableEntity])
  func removeFromStorage(objects: [CoreDataStorableEntity])
  func updateTemporaryStorage(with objects: [CoreDataStorableEntity])
  func releaseTemporaryStorage()
  func removeFromTemporaryStorage(objects: [CoreDataStorableEntity])
  var viewContext: NSManagedObjectContext { get }
  
  var workerContext: NSManagedObjectContext { get }
  
  func batchUpdateObjects<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate, propertiesToUpdate: [String: Any])
  func batchUpdateObjects<T: NSManagedObject>(_ entityType: T.Type, predicate: NSPredicate, propertiesToUpdate: [String: Any], completeHandler: EmptyCompleteHandler?)
}
