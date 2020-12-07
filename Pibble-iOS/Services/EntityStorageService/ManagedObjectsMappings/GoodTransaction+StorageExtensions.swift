//
//  GoodTransaction+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 29/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension GoodTransactionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: GoodTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    goodsTransactionType = object.acitivityGoodTransactionType.rawValue
    
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
  
  fileprivate func update(with object: PartialGoodTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    goodsTransactionType = object.acitivityGoodTransactionType.rawValue
    
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
  
  static func replaceOrCreate(with object: GoodTransactionProtocol, in context: NSManagedObjectContext) -> GoodTransactionManagedObject {
    
    let managedObject = GoodTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialGoodTransactionProtocol, in context: NSManagedObjectContext) -> GoodTransactionManagedObject {
    
    let managedObject = GoodTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension GoodTransactionManagedObject: GoodTransactionProtocol {
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
  
  var acitivityGoodTransactionType: GoodsTransactionType {
    return GoodsTransactionType(rawValue: goodsTransactionType ?? "")
  }
}

extension GoodTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = GoodTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = GoodTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialGoodTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = GoodTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = GoodTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
