//
//  FundingTransaction+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 20.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension FundingTransactionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: FundingTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
   
    if let fundingPosting = object.fundingPosting {
      posting = PostingManagedObject.replaceOrCreate(with: fundingPosting, in: context)
    }
    
    return self
  }
  
  fileprivate func update(with object: PartialFundingTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    if let fundingPosting = object.fundingPosting {
      posting = PostingManagedObject.updateOrCreate(with: fundingPosting, in: context)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: FundingTransactionProtocol, in context: NSManagedObjectContext) -> FundingTransactionManagedObject {
    
    let managedObject = FundingTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialFundingTransactionProtocol, in context: NSManagedObjectContext) -> FundingTransactionManagedObject {
    
    let managedObject = FundingTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension FundingTransactionManagedObject: FundingTransactionProtocol {
  var fundingPosting: PostingProtocol? {
    return posting
  }
 
  var activityValue: Double {
    return value?.doubleValue ?? 0.0
  }
  
  var activityCurrency: BalanceCurrency {
    return BalanceCurrency(rawValue: currency ?? "")
  }
}

extension FundingTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = FundingTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = FundingTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialFundingTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = FundingTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = FundingTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
