//
//  InternalTransaction+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 05/10/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension InternalTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: InternalTransactionProtocol, in context: NSManagedObjectContext) -> InternalTransactionManagedObject {
    
    let managedObject = InternalTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialInternalTransactionProtocol, in context: NSManagedObjectContext) -> InternalTransactionManagedObject {
    
    let managedObject = InternalTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension InternalTransactionManagedObject: InternalTransactionProtocol {
  
}

extension InternalTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = InternalTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = InternalTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialInternalTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = InternalTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = InternalTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}


