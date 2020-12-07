//
//  ThirdPartExchangeTransaction+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 22/01/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension ExternalExchangeTransactionManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: ExternalExchangeTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    createdAt = object.activityCreatedAt
    fromCurrency = object.fromBalance.currency.symbol
    toCurrency = object.toBalance.currency.symbol
    currency = toCurrency
    fromAmount = NSDecimalNumber(value: object.fromBalance.value)
    toAmount = NSDecimalNumber(value: object.toBalance.value)
    fromCurrencyName = object.fromBalance.currency.name
    fromCurrencyIconUrlString = object.fromBalance.currency.iconUrlString
    
    fromAppName = object.fromExternalAppName
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    if let date = dateFormatter.date(from: object.activityCreatedAt) {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    return self
  }
  
  fileprivate func update(with object: PartialExternalExchangeTransactionProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    createdAt = object.activityCreatedAt
    fromCurrency = object.fromBalance.currency.symbol
    toCurrency = object.toBalance.currency.symbol
    currency = toCurrency
    fromAmount = NSDecimalNumber(value: object.fromBalance.value)
    toAmount = NSDecimalNumber(value: object.toBalance.value)
    fromCurrencyName = object.fromBalance.currency.name
    fromCurrencyIconUrlString = object.fromBalance.currency.iconUrlString
    
    fromAppName = object.fromExternalAppName
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    if let date = dateFormatter.date(from: object.activityCreatedAt) {
      createdAtDate = NSDate(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: ExternalExchangeTransactionProtocol, in context: NSManagedObjectContext) -> ExternalExchangeTransactionManagedObject {
    
    let managedObject = ExternalExchangeTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialExternalExchangeTransactionProtocol, in context: NSManagedObjectContext) -> ExternalExchangeTransactionManagedObject {
    
    let managedObject = ExternalExchangeTransactionManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension ExternalExchangeTransactionManagedObject: ExternalExchangeTransactionProtocol {
  var fromExternalAppName: String {
    return fromAppName ?? ""
  }
  
  var fromBalance: ExternalBalanceProtocol {
    let currency = ExternalCurrency(name: fromCurrencyName ?? "",
                                    symbol: fromCurrency ?? "",
                                    iconUrlString: fromCurrencyIconUrlString ?? "")
    let value = fromAmount?.doubleValue ?? 0.0
    return ExternalBalance(currency: currency, value: value)
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

extension ExternalExchangeTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ExternalExchangeTransactionManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ExternalExchangeTransactionManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialExternalExchangeTransactionProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ExternalExchangeTransactionManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ExternalExchangeTransactionManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
