//
//  PostHelpTransactions+StrorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 05/10/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension PostHelpRewardTransactionManagedObject: MappableManagedObject {
  static func replaceOrCreate(with object: PostHelpRewardTransactionProtocol, in context: NSManagedObjectContext) -> PostHelpRewardTransactionManagedObject {
    
    let managedObject = PostHelpRewardTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialPostHelpRewardTransactionProtocol, in context: NSManagedObjectContext) -> PostHelpRewardTransactionManagedObject {
    
    let managedObject = PostHelpRewardTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension PostHelpRewardTransactionManagedObject: PostHelpRewardTransactionProtocol {
  
}

extension PostHelpRewardTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostHelpRewardTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostHelpRewardTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialPostHelpRewardTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostHelpRewardTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostHelpRewardTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}


