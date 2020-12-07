//
//  CommerceTransaction+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 22/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension CommerceTransactionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: CommerceTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    if let relatedPost = object.relatedPost {
      post = PostingManagedObject.replaceOrCreate(with: relatedPost, in: context)
    }
    
    return self
  }
  
  fileprivate func update(with object: PartialCommerceTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    if let relatedPost = object.relatedPost {
      post = PostingManagedObject.updateOrCreate(with: relatedPost, in: context)
    }
    
    return self
  }
  
  
  static func replaceOrCreate(with object: CommerceTransactionProtocol, in context: NSManagedObjectContext) -> CommerceTransactionManagedObject {
    
    let managedObject = CommerceTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialCommerceTransactionProtocol, in context: NSManagedObjectContext) -> CommerceTransactionManagedObject {
    
    let managedObject = CommerceTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension CommerceTransactionManagedObject: CommerceTransactionProtocol {
  var relatedPost: PostingProtocol? {
    return post
  }
  
  var activityValue: Double {
    return value?.doubleValue ?? 0.0
  }
  
  var activityCurrency: BalanceCurrency {
    return BalanceCurrency(rawValue: currency ?? "")
  }
}

extension CommerceTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = CommerceTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = CommerceTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialCommerceTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = CommerceTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = CommerceTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
