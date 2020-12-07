//
//  ExternalTransaction+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 27.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension ExternalTransactionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: ExternalTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    transactionHash = object.transactionId
    
    fromAddress = object.transactionFromAddress
    toAddress = object.transactionToAddress
  
    if let date = object.activityCreatedAt.toDateWithCommonFormat()  {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    return self
  }
  
  fileprivate func update(with object: PartialExternalTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    transactionHash = object.transactionId
    fromAddress = object.transactionFromAddress
    toAddress = object.transactionToAddress
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat()  {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: ExternalTransactionProtocol, in context: NSManagedObjectContext) -> ExternalTransactionManagedObject {
    
    let managedObject = ExternalTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialExternalTransactionProtocol, in context: NSManagedObjectContext) -> ExternalTransactionManagedObject {
    
    let managedObject = ExternalTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension ExternalTransactionManagedObject: ExternalTransactionProtocol {
  var transactionId: String {
    return transactionHash ?? ""
  }
  
  var transactionFromAddress: String {
    return fromAddress ?? ""
  }
  
  var transactionToAddress: String {
     return toAddress ?? ""
  }
  
  var activityValue: Double {
    return value?.doubleValue ?? 0.0
  }
  
  var activityCurrency: BalanceCurrency {
    return BalanceCurrency(rawValue: currency ?? "")
  }
}

extension ExternalTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ExternalTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ExternalTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialExternalTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ExternalTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ExternalTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
