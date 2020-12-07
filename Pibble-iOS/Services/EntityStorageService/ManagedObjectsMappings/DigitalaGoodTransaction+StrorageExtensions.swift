//
//  DigitalaGoodTransaction+StrorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 21/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension DigitalGoodTransactionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: DigitalGoodTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    
    fee = NSDecimalNumber(value: object.transactionFee)
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    if let user = object.activityFromUser {
      fromUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    if let user = object.activityToUser {
      toUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    if let relatedPost = object.relatedPost {
      post = PostingManagedObject.replaceOrCreate(with: relatedPost, in: context)
    }
    
    return self
  }
  
  fileprivate func update(with object: PartialDigitalGoodTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    
    fee = NSDecimalNumber(value: object.transactionFee)
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    if let user = object.activityFromUser {
      fromUser = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    if let user = object.activityToUser {
      toUser = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    if let relatedPost = object.relatedPost {
      post = PostingManagedObject.updateOrCreate(with: relatedPost, in: context)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: DigitalGoodTransactionProtocol, in context: NSManagedObjectContext) -> DigitalGoodTransactionManagedObject {
    
    let managedObject = DigitalGoodTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialDigitalGoodTransactionProtocol, in context: NSManagedObjectContext) -> DigitalGoodTransactionManagedObject {
    
    let managedObject = DigitalGoodTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension DigitalGoodTransactionManagedObject: DigitalGoodTransactionProtocol {
  var transactionFee: Double {
    return fee?.doubleValue ?? 0.0
  }
  
  var relatedPost: PostingProtocol? {
    return post
  }
  
  var activityFromUser: UserProtocol? {
    return fromUser
  }
  
  var activityToUser: UserProtocol? {
    return toUser
  }
  
  var activityValue: Double {
    return value?.doubleValue ?? 0.0
  }
  
  var activityCurrency: BalanceCurrency {
    return BalanceCurrency(rawValue: currency ?? "")
  }
}

extension DigitalGoodTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = DigitalGoodTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = DigitalGoodTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialDigitalGoodTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = DigitalGoodTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = DigitalGoodTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
