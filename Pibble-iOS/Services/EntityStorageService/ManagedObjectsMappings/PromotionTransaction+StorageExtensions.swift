//
//  PromotionTransaction+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 07.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension PromotionTransactionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: PromotionTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    promotionType = object.promotionTransactionType.rawValue
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
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
  
  fileprivate func update(with object: PartialPromotionTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    promotionType = object.promotionTransactionType.rawValue
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
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
  
  static func replaceOrCreate(with object: PromotionTransactionProtocol, in context: NSManagedObjectContext) -> PromotionTransactionManagedObject {
    
    let managedObject = PromotionTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialPromotionTransactionProtocol, in context: NSManagedObjectContext) -> PromotionTransactionManagedObject {
    
    let managedObject = PromotionTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}


extension PromotionTransactionManagedObject: PromotionTransactionProtocol {
  var activityFromUser: UserProtocol? {
    return fromUser
  }
  
  var activityToUser: UserProtocol? {
    return toUser
  }
  
  var promotionTransactionType: PromotionType {
    return PromotionType(rawValue: promotionType ?? "") ?? .defaultType
  }
  
  var activityValue: Double {
    return value?.doubleValue ?? 0.0
  }
  
  var activityCurrency: BalanceCurrency {
    return BalanceCurrency(rawValue: currency ?? "")
  }
}

extension PromotionTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PromotionTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PromotionTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialPromotionTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PromotionTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PromotionTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
