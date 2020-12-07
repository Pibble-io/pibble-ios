//
//  BaseFundingResultTransaction+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension BaseFundingResultTransactionManagedObject {
  func replace(with object: BaseFundingResultTransactionProtocol, in context: NSManagedObjectContext) {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    isSuccess = object.isFundingSuccessful
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
  }
  
  func update(with object: PartialBaseFundingResultTransactionProtocol, in context: NSManagedObjectContext) {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    isSuccess = object.isFundingSuccessful

    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
  }
}


extension BaseFundingResultTransactionManagedObject: BaseFundingResultTransactionProtocol {
  var isFundingSuccessful: Bool {
    return isSuccess
  }
  
  var activityValue: Double {
    return value?.doubleValue ?? 0.0
  }
  
  var activityCurrency: BalanceCurrency {
    return BalanceCurrency(rawValue: currency ?? "")
  }
}
