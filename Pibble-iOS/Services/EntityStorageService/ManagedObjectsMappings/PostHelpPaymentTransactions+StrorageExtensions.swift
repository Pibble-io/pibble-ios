//
//  PostHelpPaymentTransactions+StrorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 05/10/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension PostHelpPaymentTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: PostHelpPaymentTransactionProtocol, in context: NSManagedObjectContext) -> PostHelpPaymentTransactionManagedObject {
    
    let managedObject = PostHelpPaymentTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialPostHelpPaymentTransactionProtocol, in context: NSManagedObjectContext) -> PostHelpPaymentTransactionManagedObject {
    
    let managedObject = PostHelpPaymentTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension PostHelpPaymentTransactionManagedObject: PostHelpPaymentTransactionProtocol {
  
}

extension PostHelpPaymentTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostHelpPaymentTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostHelpPaymentTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialPostHelpPaymentTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostHelpPaymentTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostHelpPaymentTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
