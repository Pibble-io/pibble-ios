//
//  BaseFundingTransaction+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension BaseFundingTransactionManagedObject {
  func replace(with object: BaseFundingTransactionProtocol, in context: NSManagedObjectContext) {
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
  }
  
  func update(with object: PartialBaseFundingTransactionProtocol, in context: NSManagedObjectContext) {
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
  }
}

extension BaseFundingTransactionManagedObject: BaseFundingTransactionProtocol {
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
