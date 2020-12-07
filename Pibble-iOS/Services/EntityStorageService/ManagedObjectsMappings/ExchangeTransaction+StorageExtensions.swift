//
//  ExchangeTransaction+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 25.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension ExchangeTransactionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: ExchangeTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    createdAt = object.activityCreatedAt
    fromCurrency = object.fromBalance.currency.symbol
    toCurrency = object.toBalance.currency.symbol
    currency = "\(object.fromBalance.currency.symbol) \(object.toBalance.currency.symbol)"
    fromAmount = NSDecimalNumber(value: object.fromBalance.value)
    toAmount = NSDecimalNumber(value: object.toBalance.value)
     
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    return self
  }
  
  fileprivate func update(with object: PartialExchangeTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    createdAt = object.activityCreatedAt
    fromCurrency = object.fromBalance.currency.symbol
    toCurrency = object.toBalance.currency.symbol
    currency = "\(object.fromBalance.currency.symbol) \(object.toBalance.currency.symbol)"
    fromAmount = NSDecimalNumber(value: object.fromBalance.value)
    toAmount = NSDecimalNumber(value: object.toBalance.value)
    
    if let date = object.activityCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: ExchangeTransactionProtocol, in context: NSManagedObjectContext) -> ExchangeTransactionManagedObject {
    
    let managedObject = ExchangeTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialExchangeTransactionProtocol, in context: NSManagedObjectContext) -> ExchangeTransactionManagedObject {
    
    let managedObject = ExchangeTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension ExchangeTransactionManagedObject: ExchangeTransactionProtocol {
  var fromBalance: BalanceProtocol {
    let currency = BalanceCurrency(rawValue: fromCurrency ?? "")
    let value = fromAmount?.doubleValue ?? 0.0
    return Balance(currency: currency, value: value)
  }
  
  var toBalance: BalanceProtocol {
    let currency = BalanceCurrency(rawValue: toCurrency ?? "")
    let value = toAmount?.doubleValue ?? 0.0
    return Balance(currency: currency, value: value)
  }
  
  var exchangeRate: Double {
    return exchangeCurrencyRate
  }
}

extension ExchangeTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ExchangeTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ExchangeTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialExchangeTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ExchangeTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ExchangeTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
