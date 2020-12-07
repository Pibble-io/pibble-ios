//
//  PostHelpRequest+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 01/10/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension PostHelpRequestManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  static func replaceOrCreate(with object: PostHelpRequestProtocol, in context: NSManagedObjectContext) -> PostHelpRequestManagedObject {
    let managedObject = PostHelpRequestManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.id = Int32(object.identifier)
    managedObject.reward = NSDecimalNumber(value: object.rewardAmount.value)
    managedObject.isClosed = object.isHelpClosed
    managedObject.descriptionText = object.helpDescription
    managedObject.createdAt = object.createdAtDate.toNSDate
    managedObject.updatedAt = object.updatedAtDate.toNSDate
    
    if let user = object.helpForUser {
      managedObject.user = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialPostHelpRequestProtocol, in context: NSManagedObjectContext) -> PostHelpRequestManagedObject {
    let managedObject = PostHelpRequestManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.id = Int32(object.identifier)
    managedObject.reward = NSDecimalNumber(value: object.rewardAmount.value)
    managedObject.isClosed = object.isHelpClosed
    managedObject.descriptionText = object.helpDescription
    managedObject.createdAt = object.createdAtDate.toNSDate
    managedObject.updatedAt = object.updatedAtDate.toNSDate
    
    if let user = object.helpForUser {
      managedObject.user = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    return managedObject
  }
}

extension PostHelpRequestManagedObject {
  static func createObservable(with object: PostHelpRequestProtocol, in context: NSManagedObjectContext) ->   ObservableManagedObject<PostHelpRequestManagedObject> {
    let id = Int32(object.identifier)
    let fetchRequest: NSFetchRequest<PostHelpRequestManagedObject> = PostHelpRequestManagedObject.fetchRequest()
    let observableManagedObject = ObservableManagedObject(id, fetchRequest: fetchRequest, context: context)
    return observableManagedObject
  }
  
  static func createObservable(with object: PartialPostHelpRequestProtocol, in context: NSManagedObjectContext) -> ObservableManagedObject<PostHelpRequestManagedObject> {
    let id = Int32(object.identifier)
    let fetchRequest: NSFetchRequest<PostHelpRequestManagedObject> = PostHelpRequestManagedObject.fetchRequest()
    let observableManagedObject = ObservableManagedObject(id, fetchRequest: fetchRequest, context: context)
    return observableManagedObject
  }
}

extension PostHelpRequestManagedObject: PostHelpRequestProtocol {
  var identifier: Int {
    return Int(id)
  }
  
  var helpDescription: String {
    return descriptionText ?? ""
  }
  
  var createdAtDate: Date {
    return createdAt?.toDate ?? Date(timeIntervalSince1970: 0)
  }
  
  var updatedAtDate: Date {
    return updatedAt?.toDate ?? Date(timeIntervalSince1970: 0)
  }
  
  var helpForUser: UserProtocol? {
    return user
  }
  
  var isHelpClosed: Bool {
    return isClosed
  }
  
  var rewardAmount: BalanceProtocol {
    return Balance(currency: rewardCurrency, value: reward?.doubleValue ?? 0.0)
  }
}

extension PostHelpRequestProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostHelpRequestManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostHelpRequestManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialPostHelpRequestProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostHelpRequestManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostHelpRequestManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

