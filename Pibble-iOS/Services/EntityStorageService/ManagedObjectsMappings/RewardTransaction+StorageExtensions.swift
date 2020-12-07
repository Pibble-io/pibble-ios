//
//  RewardTransaction+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 10.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension RewardTransactionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: RewardTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    rewardType = object.rewardActivityType.rawValue
     
    if let date = object.activityCreatedAt.toDateWithCommonFormat()  {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    if let user = object.activityFromUser {
      fromUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    if let user = object.activityToUser {
      toUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    return self
  }
  
  fileprivate func update(with object: PartialRewardTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    rewardType = object.rewardActivityType.rawValue
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat()  {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    if let user = object.activityFromUser {
      fromUser = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    if let user = object.activityToUser {
      toUser = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: RewardTransactionProtocol, in context: NSManagedObjectContext) -> RewardTransactionManagedObject {
    
    let managedObject = RewardTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialRewardTransactionProtocol, in context: NSManagedObjectContext) -> RewardTransactionManagedObject {
    
    let managedObject = RewardTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension RewardTransactionManagedObject: RewardTransactionProtocol {
  var activityFromUser: UserProtocol? {
    return fromUser
  }
  
  var activityToUser: UserProtocol? {
    return toUser
  }
  
  var rewardActivityType: RewardType {
    return RewardType(rawValue: rewardType ?? "")
  }
  
  var activityValue: Double {
    return value?.doubleValue ?? 0.0
  }
  
  var activityCurrency: BalanceCurrency {
    return BalanceCurrency(rawValue: currency ?? "")
  }
}

extension RewardTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = RewardTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = RewardTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialRewardTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = RewardTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = RewardTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

