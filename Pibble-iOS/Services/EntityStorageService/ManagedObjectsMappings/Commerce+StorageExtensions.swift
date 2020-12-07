//
//  Commerce+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 03/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension CommerceManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  static func replaceOrCreate(with object: CommerceInfoProtocol, in context: NSManagedObjectContext) -> CommerceManagedObject {
    let managedObject = CommerceManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.id = Int32(object.identifier)
    managedObject.title = object.commerceItemTitle
    
    managedObject.price = NSDecimalNumber(value: object.commerceItemPrice)
    managedObject.discount = Int32(object.commerceDiscount)
    managedObject.limit = Int32(object.commerceLimit)
    managedObject.reward = object.commerceReward
    
    managedObject.isCommercialUse = object.isCommercialUseAvailable
    managedObject.isEditorialUse = object.isEditorialUseAvailable
    managedObject.isRoyaltyFreeUse = object.isRoyaltyFreeUseAvailable
    managedObject.isExclusiveUse = object.isExclusiveUseAvailable
    
    managedObject.isDownloadable = object.isDownloadAvailable
    
    managedObject.createdAt = object.commerceCreatedAt
    
    managedObject.status = object.commerceProcessingStatus.rawValue
    managedObject.errorCode = object.commerceProcessingError?.rawValue

    return managedObject
  }
}

extension CommerceManagedObject: CommerceInfoProtocol {
  var commerceReward: Double {
    return reward
  }
  
  var commerceProcessingStatus: CommerceStatus {
    return CommerceStatus(rawValue: status ?? "") ?? .waiting
  }
  
  var commerceProcessingError: CommerceProcessingError? {
    guard let error = errorCode, error.count > 0 else {
      return nil
    }
    
    return CommerceProcessingError(rawValue: error) ?? .unknownError
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  var commerceItemTitle: String {
    return title ?? ""
  }
  
  var commerceItemPrice: Int {
    return price?.intValue ?? 0
  }
  
  var commerceDiscount: Int {
    return Int(discount)
  }
  
  var commerceLimit: Int {
    return Int(limit)
  }
  
  var isCommercialUseAvailable: Bool {
    return isCommercialUse
  }
  
  var isEditorialUseAvailable: Bool {
    return isEditorialUse
  }
  
  var isRoyaltyFreeUseAvailable: Bool {
    return isRoyaltyFreeUse
  }
  
  var isExclusiveUseAvailable: Bool {
    return isExclusiveUse
  }
  
  var isDownloadAvailable: Bool {
    return isDownloadable
  }
  
  var commerceCreatedAt: String {
    return createdAt ?? ""
  }
}

extension CommerceInfoProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = CommerceManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = CommerceManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
