//
//  Invoice+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 27.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension InvoiceManagedObject: PartiallyUpdatable {
  
}

extension InvoiceManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: InvoiceProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    activityDescription = object.walletActivityDescription
    activityStatus = object.walletActivityStatus.rawValue
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
     
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
  
  fileprivate func update(with object: PartialInvoiceProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    
    activityType = object.walletActivityType.rawValue
    isHidden = object.isActivityHidden
    value = NSDecimalNumber(value: object.activityValue)
    activityDescription = object.walletActivityDescription
    activityStatus = object.walletActivityStatus.rawValue
    createdAt = object.activityCreatedAt
    currency = object.activityCurrency.rawValue
    
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
  
  static func replaceOrCreate(with object: InvoiceProtocol, in context: NSManagedObjectContext) -> InvoiceManagedObject {
    let managedObject = InvoiceManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialInvoiceProtocol, in context: NSManagedObjectContext) -> InvoiceManagedObject {
    let managedObject = InvoiceManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension InvoiceManagedObject {
  static func createObservable(with object: PartialInvoiceProtocol, in context: NSManagedObjectContext) -> ObservableManagedObject<InvoiceManagedObject> {
    let id = Int32(object.identifier)
    let fetchRequest: NSFetchRequest<InvoiceManagedObject> = InvoiceManagedObject.fetchRequest()
    let observableManagedObject = ObservableManagedObject(id, fetchRequest: fetchRequest, context: context)
    return observableManagedObject
  }
}

extension InvoiceManagedObject: InvoiceProtocol {
  var activityFromUser: UserProtocol? {
    return fromUser
  }
  
  var activityToUser: UserProtocol? {
    return toUser
  }
  
  var activityValue: Double {
    return value?.doubleValue ?? 0.0
  }
  
  var walletActivityDescription: String {
    return activityDescription ?? ""
  }
  
  var walletActivityStatus: InvoiceStatus {
    let status = activityStatus ?? ""
    return InvoiceStatus(rawValue: status)!
  }
  
  var activityCurrency: BalanceCurrency {
    return BalanceCurrency(rawValue: currency ?? "")
  }
}

extension InvoiceProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = InvoiceManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = InvoiceManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialInvoiceProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = InvoiceManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = InvoiceManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
