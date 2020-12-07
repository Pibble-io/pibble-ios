//
//  PersistableManagedObject.swift
//  Pibble
//
//  Created by Kazakov Sergey on 08.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData


protocol PersistableManagedObject {
  associatedtype ID
  static func primaryKeyPredicateFor(_ id: ID) -> NSPredicate
  
  var id: ID { get }
}



extension PersistableManagedObject where Self: NSManagedObject, ID == Int64 {
  static func primaryKeyPredicateFor(_ id: Int64) -> NSPredicate {
    return NSPredicate(format: "id = \(id)")
  }
  
  static func findOrCreate(with id: Int, in context: NSManagedObjectContext) -> Self {
    let longId = Int64(id)
    return findOrCreate(with: longId, in: context)
  }
}

extension PersistableManagedObject where Self: NSManagedObject, ID == Int32 {
  static func primaryKeyPredicateFor(_ id: Int32) -> NSPredicate {
    return NSPredicate(format: "id = \(id)")
  }
  
  static func findOrCreate(with id: Int, in context: NSManagedObjectContext) -> Self {
    let castedId = Int32(id)
    return findOrCreate(with: castedId, in: context)
  }
}

extension PersistableManagedObject where Self: NSManagedObject, ID == String {
  static func primaryKeyPredicateFor(_ id: String) -> NSPredicate {
    return NSPredicate(format: "id = %@", id)
  }
}

extension PersistableManagedObject where Self: NSManagedObject, ID == String? {
  static func primaryKeyPredicateFor(_ id: String?) -> NSPredicate {
    let identifier = id ?? ""
    return NSPredicate(format: "id = %@", identifier)
  }
}

extension PersistableManagedObject where Self: NSManagedObject {
//  static func findOrCreate(with id: ID, in context: NSManagedObjectContext) -> Self {
//    let fetchReq = Self.fetchRequest()
//    fetchReq.predicate = primaryKeyPredicateFor(id)
//
//    let result: [Self]?
//    do {
//      result = try context.fetch(fetchReq) as? [Self]
//    } catch {
//      AppLogger.info("Core Data Error: \(error)")
//      result = nil
//    }
//
//    return result?.first ?? Self(context: context)
//  }
  
  
  
  static func findOrCreate(with id: ID, in context: NSManagedObjectContext) -> Self {
    let predicate = primaryKeyPredicateFor(id)
    return findOrCreate(predicate: predicate, in: context)
  }
  
  static func findOrCreate(predicate: NSPredicate, in context: NSManagedObjectContext) -> Self {
    let fetchReq = Self.fetchRequest()
    fetchReq.predicate = predicate
    
    let result: [Self]?
    do {
      result = try context.fetch(fetchReq) as? [Self]
    } catch {
      AppLogger.critical("Core Data Error: \(error)")
      result = nil
    }
    
    return result?.first ?? Self(context: context)
  }
}
