//
//  InternalTransactions+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 27.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//
import CoreData

extension BaseInternalTransactionManagedObject {
  func replace(with object: BaseInternalTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
     
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
  
  func update(with object: PartialBaseInternalTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    
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
}

extension BaseInternalTransactionManagedObject: BaseInternalTransactionProtocol {
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


