//
//  AirdropTransaction+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 18/04/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension AirdropTransactionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: AirdropTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat()  {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
   
    return self
  }
  
  fileprivate func update(with object: PartialAirdropTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat()  {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: AirdropTransactionProtocol, in context: NSManagedObjectContext) -> AirdropTransactionManagedObject {
    
    let managedObject = AirdropTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialAirdropTransactionProtocol, in context: NSManagedObjectContext) -> AirdropTransactionManagedObject {
    
    let managedObject = AirdropTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension AirdropTransactionManagedObject: AirdropTransactionProtocol {
  var activityValue: Double {
    return value?.doubleValue ?? 0.0
  }
  
  var activityCurrency: BalanceCurrency {
    return BalanceCurrency(rawValue: currency ?? "")
  }
}

extension AirdropTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = AirdropTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = AirdropTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialAirdropTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = AirdropTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = AirdropTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
